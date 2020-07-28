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
base_otaviano_location = '../protein_base/base_otaviano';
formatted_protein_base_format_spec = '%d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n';
base_otaviano_format_spec = '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n';
call_empty_rms_file_command="../lsqkab_scripts/empty_rms_file.sh";

distance_matrix = importdata(formatted_protein_base_file_location);
distance_matrix = distance_matrix(:, 2:67);

%[idx, C, sumd, D] = kmeans(distance_matrix, number_of_clusters, 'MaxIter', 1000, 'Display', 'iter');
%fitted_gmm = fit_gmm_to_data(distance_matrix, number_of_clusters);
idx = cluster(fitted_gmm, distance_matrix);
result_grouping = group_clusters(number_of_files, number_of_clusters, idx);
mean_distance_to_gmm_centroid = gmm_cluster_distance_to_centroid(fitted_gmm, distance_matrix,result_grouping, 1);
% system(call_empty_rms_file_command);
% [successfull_rms_rate_acc, cluster_metrics] = cluster_lsqkab_superposition(number_of_clusters, result_grouping);
% cluster_quality_results = sum_cluster_quality_results(successfull_rms_rate_acc); 
% cluster_size_per_successfull_superpositions = sum_cluster_size_per_successfull_superpositions(successfull_rms_rate_acc, cluster_metrics); 

function cluster_quality_results = sum_cluster_quality_results(successfull_rms_rate_acc)
    cluster_quality_results = zeros(10, 1);
    for i = 1:10
        cluster_quality_results(i) = cluster_quality_results(i) + size(successfull_rms_rate_acc(successfull_rms_rate_acc > ((i-1)*10) & successfull_rms_rate_acc <= (i*10)), 1);
    end
    cluster_quality_results(1) = cluster_quality_results(1) + size(successfull_rms_rate_acc(successfull_rms_rate_acc == 0),1);
end

function cluster_size_per_successfull_superpositions = sum_cluster_size_per_successfull_superpositions(successfull_rms_rate_acc, cluster_metrics)
    n_lines_rms_rate_acc = size(successfull_rms_rate_acc, 1);
    rms_rate_acc_indexed = [(1:n_lines_rms_rate_acc)' successfull_rms_rate_acc];
    cluster_size_per_successfull_superpositions = zeros(10, 1);
     for i = 1:10
        index_interval_i = rms_rate_acc_indexed(rms_rate_acc_indexed(:, 2) > ((i-1)*10) & rms_rate_acc_indexed(:, 2) <= (i*10));
        cluster_size_per_successfull_superpositions(i) = sum(cluster_metrics(index_interval_i, 2));
    end
    index_interval_1 = rms_rate_acc_indexed(rms_rate_acc_indexed(:, 2) == 0);
    cluster_size_per_successfull_superpositions(1) = cluster_size_per_successfull_superpositions(1) + sum(cluster_metrics(index_interval_1, 2));
end

function distance_matrix = read_distance_file_to_matrix(file_location, format_spec, output_size_array)
    fileID = fopen(file_location, 'r');
    distance_matrix = fscanf(fileID, format_spec, output_size_array)';
    fclose(fileID);
end

function result_grouping = group_clusters(number_of_files, number_of_clusters, idx)
    result_grouping = zeros(number_of_files, number_of_clusters);
    for i = 1:number_of_files
        result_grouping(i, idx(i)) = i;  
    end
end

function [successfull_rms_rate_acc, cluster_metrics, file_ids_clusters] = cluster_lsqkab_superposition(number_of_clusters, result_grouping)
    call_lsqkab_shell_command = "../lsqkab_scripts/get_rms.sh ../lsqkab_scripts/map_file_id_to_file_name ";
    successfull_rms_rate_acc = zeros(number_of_clusters, 1);
    cluster_metrics = zeros(number_of_clusters, 4);
    for i = 1:number_of_clusters
        disp(i);
        result_column_i = result_grouping(:, i);
        file_ids_of_cluster_i = result_column_i(result_column_i > 0);
        number_of_files_cluster_i = size(file_ids_of_cluster_i, 1);
        disp('tamanho do cluster:');
        disp(number_of_files_cluster_i);
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
            fclose(rms_results_cluster_i_fileID);
            
            number_of_successfull_superpositions = size(rms_results_cluster_i(rms_results_cluster_i <= 0.5), 1);
            total_number_superpositions = (number_of_files_cluster_i * (number_of_files_cluster_i - 1))/2;
            cluster_metrics(i, 1) = i;
            cluster_metrics(i, 2) = number_of_files_cluster_i;
            cluster_metrics(i, 3) = total_number_superpositions;
            cluster_metrics(i, 4) = number_of_successfull_superpositions;
            successfull_rms_rate = number_of_successfull_superpositions/total_number_superpositions;
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
     gmfit = fitgmdist(distance_matrix,number_of_clusters,'Start','randSample','CovarianceType',covariance_type, 'SharedCovariance',shared_covariance,'Options',options);
end

function mean_distance_to_gmm_centroid = gmm_cluster_distance_to_centroid(fitted_gmm, distance_matrix,result_grouping, cluster_i)
    result_column_i = result_grouping(:, cluster_i);
    file_ids_of_cluster_i = result_column_i(result_column_i > 0);
    sum_distance = 0;
    gmm_cluster_centroid = fitted_gmm.mu(cluster_i, :);
    for i = 1:size(file_ids_of_cluster_i, 1)
        id = file_ids_of_cluster_i(i);
        sum_distance = sum_distance + sqrt(sum((distance_matrix(id,:) - gmm_cluster_centroid) .^ 2));
    end
    mean_distance_to_gmm_centroid = sum_distance/size(file_ids_of_cluster_i, 1);
end


