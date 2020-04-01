%constants
%numeric
number_of_files = 16383;
number_of_clusters = 500;
data_column_start = 2;
data_column_finish = 67;
number_of_atoms = 12;
max_rms = 0.5;
number_of_experiments = 1;
max_iterations_number = 1000;
%text
formatted_protein_base_format_spec = '%d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n';
call_lsqkab_shell_command = "../lsqkab_scripts/get_rms.sh ../lsqkab_scripts/map_file_id_to_file_name ";
call_empty_rms_file_command="../lsqkab_scripts/empty_rms_file.sh";

%read file
fileID = fopen('../protein_base/formatted_protein_base.txt', 'r');
distance_matrix = fscanf(fileID, formatted_protein_base_format_spec, [data_column_finish, number_of_files])';
fclose(fileID);

%experiments results variables
cluster_quality_results = zeros(10, 1);
successfull_rms_rate_acc = zeros(number_of_clusters, 1);

%outliers successfull_rms_rate variables
number_of_successfull_superpositions_outlier = 0;
total_number_superpositions_outlier = 0;

for experiment_number = 1:number_of_experiments   
    %execute k-means
    idx = kmeans(distance_matrix(:, (data_column_start:data_column_finish)), number_of_clusters, 'Start', 'sample', 'MaxIter',max_iterations_number);

    %create matrix to map each id file to the associated cluster
    map_file_id_to_cluster_id = cat(2, distance_matrix(:,1), idx);

    % group each index to its determined cluster into a result matrix
    result_grouping = zeros(number_of_files, number_of_clusters);
    for i = 1:number_of_files
        result_grouping(i, map_file_id_to_cluster_id(i,2)) = map_file_id_to_cluster_id(i,1);  
    end
    
    for i = 1:number_of_clusters
        result_column_i = result_grouping(:, i);
        file_ids_of_cluster_i = result_column_i(result_column_i > 0);
        number_of_files_cluster_i = size(file_ids_of_cluster_i, 1);
        system(call_empty_rms_file_command);
        if number_of_files_cluster_i > 1
            if(number_of_files_cluster_i == 2); background_process = ''; else; background_process='&'; end
            for j = 1:(number_of_files_cluster_i-1)
                for k = (j+1):number_of_files_cluster_i
                    [~, ~] = system(join([call_lsqkab_shell_command, int2str(file_ids_of_cluster_i(j)), ' ', int2str(file_ids_of_cluster_i(k)), ' ', background_process]));
                end
            end
            rms_results_cluster_i_fileID = fopen('rms_results_cluster_i', 'r');
            rms_results_cluster_i = fscanf(rms_results_cluster_i_fileID, '%f');
            
            number_of_successfull_superpositions = size(rms_results_cluster_i(rms_results_cluster_i < 0.5), 1);
            total_number_superpositions = factorial(number_of_files_cluster_i)/(factorial(2)*factorial(number_of_files_cluster_i-2));
            if number_of_successfull_superpositions/total_number_superpositions > 1
                number_of_successfull_superpositions_outlier = number_of_successfull_superpositions;
                total_number_superpositions_outlier = total_number_superpositions;
                rms_results_cluster_i_outlier = rms_results_cluster_i;
                cluster_number_outlier = i;
                number_of_files_cluster_i_outlier = number_of_files_cluster_i;
            end
            successfull_rms_rate = number_of_successfull_superpositions/total_number_superpositions;
            fclose(rms_results_cluster_i_fileID);
        else
            successfull_rms_rate = 0;
        end
        successfull_rms_rate_acc(i) = successfull_rms_rate*100;
    end
    for i = 1:10
        cluster_quality_results(i) = size(successfull_rms_rate_acc(successfull_rms_rate_acc > ((i-1)*10) & successfull_rms_rate_acc <= (i*10)), 1);
    end
    cluster_quality_results(1) = cluster_quality_results(1) + size(successfull_rms_rate_acc(successfull_rms_rate_acc == 0),1);
end

for i = 1:10
    cluster_quality_results(i) = cluster_quality_results(i)/number_of_experiments;
end





