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
formatted_protein_base_file_location = '../protein_base/formatted_protein_base.txt';
formatted_protein_base_format_spec = '%d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n';
call_empty_rms_file_command="../lsqkab_scripts/empty_rms_file.sh";

%start random seed with clock seconds
c = clock;
rng(c(6));

%read file
distance_matrix = read_distance_file_to_matrix(formatted_protein_base_file_location, formatted_protein_base_format_spec, [data_column_finish, number_of_files]);

for experiment_number = 1:number_of_experiments   
    [idx, C, sumd, D] = kmeans(distance_matrix(:, (data_column_start:data_column_finish)), number_of_clusters, 'Start', 'plus', 'MaxIter',max_iterations_number, 'EmptyAction', 'error', 'Display', 'final');
%     fitted_gmm = fit_gmm_to_data(distance_matrix, number_of_clusters);
%     idx = cluster(fitted_gmm, distance_matrix);
    map_file_id_to_cluster_id = cat(2, distance_matrix(:,1), idx);
    result_grouping = group_clusters(number_of_files, number_of_clusters, map_file_id_to_cluster_id);
    system(call_empty_rms_file_command);
    successfull_rms_rate_acc = cluster_lsqkab_superposition(number_of_clusters, result_grouping);
    cluster_quality_results = sum_cluster_quality_results(successfull_rms_rate_acc);
end

function cluster_quality_results = sum_cluster_quality_results(successfull_rms_rate_acc)
    cluster_quality_results = zeros(10, 1);
    for i = 1:10
        cluster_quality_results(i) = cluster_quality_results(i) + size(successfull_rms_rate_acc(successfull_rms_rate_acc > ((i-1)*10) & successfull_rms_rate_acc <= (i*10)), 1);
    end
    cluster_quality_results(1) = cluster_quality_results(1) + size(successfull_rms_rate_acc(successfull_rms_rate_acc == 0),1);
end


function distance_matrix = read_distance_file_to_matrix(file_location, format_spec, output_size_array)
    fileID = fopen(file_location, 'r');
    distance_matrix = fscanf(fileID, format_spec, output_size_array)';
    fclose(fileID);
end

function result_grouping = group_clusters(number_of_files, number_of_clusters, map_file_id_to_cluster_id)
    result_grouping = zeros(number_of_files, number_of_clusters);
    for i = 1:number_of_files
        result_grouping(i, map_file_id_to_cluster_id(i,2)) = map_file_id_to_cluster_id(i,1);  
    end
end

function successfull_rms_rate_acc = cluster_lsqkab_superposition(number_of_clusters, result_grouping)
    call_lsqkab_shell_command = "../lsqkab_scripts/get_rms.sh ../lsqkab_scripts/map_file_id_to_file_name ";
    successfull_rms_rate_acc = zeros(number_of_clusters, 1);
    for i = 1:number_of_clusters
        result_column_i = result_grouping(:, i);
        file_ids_of_cluster_i = result_column_i(result_column_i > 0);
        number_of_files_cluster_i = size(file_ids_of_cluster_i, 1);
        if number_of_files_cluster_i > 1
            if(number_of_files_cluster_i == 2); background_process = ''; else; background_process='&'; end
            for j = 1:(number_of_files_cluster_i-1)
                for k = (j+1):number_of_files_cluster_i
                    [~, ~] = system(join([call_lsqkab_shell_command, int2str(file_ids_of_cluster_i(j)), ' ', int2str(file_ids_of_cluster_i(k)), ' ', i,' ', background_process]));
                end
            end
            pause(1);
            rms_results_cluster_i_fileID = fopen(join(['rms_files/rms_results_cluster_', int2str(i)]), 'r');
            rms_results_cluster_i = fscanf(rms_results_cluster_i_fileID, '%f');
            
            number_of_successfull_superpositions = size(rms_results_cluster_i(rms_results_cluster_i < 0.5), 1);
            total_number_superpositions = nchoosek(number_of_files_cluster_i, 2);
            successfull_rms_rate = number_of_successfull_superpositions/total_number_superpositions;
            fclose(rms_results_cluster_i_fileID);
        else
            successfull_rms_rate = 0;
        end
        successfull_rms_rate_acc(i) = round(successfull_rms_rate*100);
    end
end

function gmfit = fit_gmm_to_data(distance_matrix, number_of_clusters)
     covariance_type = 'full';
     shared_covariance = true;
     options = statset('MaxIter',1000, 'Display', 'iter');
     gmfit = fitgmdist(distance_matrix,number_of_clusters,'CovarianceType',covariance_type, 'SharedCovariance',shared_covariance,'Options',options);
end


