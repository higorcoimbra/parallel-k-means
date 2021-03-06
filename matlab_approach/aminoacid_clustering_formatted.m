clear;

number_of_experiments = 5;

number_of_files = 16383;
data_column_start = 2;
data_column_finish = 67;
number_of_atoms = 12;
max_rms = 0.5;
max_iterations_number = 1000;

formatted_protein_base_file_location = '../protein_base/formatted_protein_base.txt';
formatted_protein_base_format_spec = '%d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n';
call_empty_rms_file_command="../lsqkab_scripts/empty_rms_file.sh";
cluster_distance_metrics_file_path = './experiment_results/kmeans_750/cdm/cdm_';
cluster_metrics_file_path = './experiment_results/kmeans_750/cluster_metrics/cm_';


for experiment = 1:30
    
    distance_matrix = importdata(formatted_protein_base_file_location);
    distance_matrix = distance_matrix(:, 2:67);
    
    disp('EXPERIMENTO:');
    disp(experiment);
    
    cqr_file_id = fopen(join(['./experiment_results/kmeans_750/cqr/cqr_', int2str(experiment)]), 'w');
    csps_file_id = fopen(join(['./experiment_results/kmeans_750/csps/csps_', int2str(experiment)]), 'w');
    idx_file_id = fopen(join(['./experiment_results/kmeans_750/idx/idx_', int2str(experiment)]), 'w');
    
    c = clock;
    rng(c(6));
    
    number_of_clusters = 750;
    
    %[idx, C, sumd, D] = kmeans(distance_matrix, number_of_clusters, 'MaxIter', 1000, 'Display', 'iter');    
    idx = importdata(join(['kmeans_ext_results/idx/',int2str(number_of_clusters), '/idx_', int2str(experiment)]));
    C = importdata(join(['kmeans_ext_results/C/',int2str(number_of_clusters), '/C_', int2str(experiment)]));
    %fitted_gmm = fit_gmm_to_data(distance_matrix, number_of_clusters);
    %idx = cluster(fitted_gmm, distance_matrix);
    
    result_grouping = group_clusters(number_of_files, number_of_clusters, idx);
    record_distance_statistics_kmeans(C, distance_matrix, result_grouping, join([cluster_distance_metrics_file_path, int2str(experiment)]));
    %record_cluster_distance_metrics(fitted_gmm, distance_matrix, result_grouping, join([cluster_distance_metrics_file_path, int2str(experiment)]));
    system(call_empty_rms_file_command);
    [successfull_rms_rate_acc, cluster_metrics] = cluster_lsqkab_superposition(number_of_clusters, result_grouping, join([cluster_metrics_file_path, int2str(experiment)]));
    cluster_quality_results = sum_cluster_quality_results(successfull_rms_rate_acc); 
    cluster_size_per_successfull_superpositions = sum_cluster_size_per_successfull_superpositions(successfull_rms_rate_acc, cluster_metrics);
    
    
    fprintf(cqr_file_id, '%d\n', cluster_quality_results);
    fprintf(csps_file_id, '%d\n', cluster_size_per_successfull_superpositions);
    fprintf(idx_file_id, '%d\n', idx);
    
    fclose(cqr_file_id);
    fclose(csps_file_id);
    fclose(idx_file_id);
end

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

function result_grouping = group_clusters(number_of_files, number_of_clusters, idx)
    result_grouping = zeros(number_of_files, number_of_clusters);
    for i = 1:number_of_files
        result_grouping(i, idx(i)) = i;  
    end
end

function [successfull_rms_rate_acc, cluster_metrics] = cluster_lsqkab_superposition(number_of_clusters, result_grouping, cluster_metrics_file_path)
    cluster_metrics_file_id = fopen(cluster_metrics_file_path, 'w');
    call_lsqkab_shell_command = "../lsqkab_scripts/get_rms.sh ../lsqkab_scripts/map_file_id_to_file_name ";
    successfull_rms_rate_acc = zeros(number_of_clusters, 1);
    cluster_metrics = zeros(number_of_clusters, 4);
    for i = 1:number_of_clusters
        disp(i);
        result_column_i = result_grouping(:, i);
        file_ids_of_cluster_i = result_column_i(result_column_i > 0);
        number_of_files_cluster_i = size(file_ids_of_cluster_i, 1);
        if number_of_files_cluster_i > 1
            if(number_of_files_cluster_i == 2); background_process=''; else; background_process='&'; end
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
            fprintf(cluster_metrics_file_id, '%d %d %d %d\n', i, number_of_files_cluster_i, total_number_superpositions, number_of_successfull_superpositions);
        else
            successfull_rms_rate = 0;
            fprintf(cluster_metrics_file_id, '%d %d %d %d\n', i, number_of_files_cluster_i, 0, 0);
        end
        successfull_rms_rate_acc(i) = round(successfull_rms_rate*100);
    end
    fclose(cluster_metrics_file_id);
end

function gmfit = fit_gmm_to_data(distance_matrix, number_of_clusters)
     covariance_type = 'full';
     shared_covariance = true;
     options = statset('MaxIter',1000, 'Display', 'iter');
     gmfit = fitgmdist(distance_matrix,number_of_clusters,'Start','randSample','CovarianceType',covariance_type, 'SharedCovariance',shared_covariance,'Options',options);
end

function [mean_distance, variance_distance, std_distance] = gmm_cluster_distance_to_centroid(fitted_gmm, distance_matrix,result_grouping, cluster_i)
    result_column_i = result_grouping(:, cluster_i);
    file_ids_of_cluster_i = result_column_i(result_column_i > 0);
    gmm_cluster_centroid = fitted_gmm.mu(cluster_i, :);
    sum_distance = zeros(size(file_ids_of_cluster_i, 1), 1);
    for i = 1:size(file_ids_of_cluster_i, 1)
        id = file_ids_of_cluster_i(i);
        sum_distance(i) = sqrt(sum((distance_matrix(id,:) - gmm_cluster_centroid) .^ 2));
    end
    if(size(sum_distance, 1) == 0)
        sum_distance = 0;
    end
    mean_distance = mean(sum_distance);
    variance_distance = var(sum_distance);
    std_distance = std(sum_distance);
end

function record_cluster_distance_metrics(fitted_gmm, distance_matrix, result_grouping, cluster_distance_metrics_path)
    fileID = fopen(cluster_distance_metrics_path, 'w');
    for i = 1:size(result_grouping, 2)
        [mean_distance, variance_distance, std_distance] = gmm_cluster_distance_to_centroid(fitted_gmm, distance_matrix,result_grouping, i);
        fprintf(fileID, "%d %f %f %f\n",i, mean_distance, variance_distance, std_distance); 
    end
    fclose(fileID);
end

function record_distance_statistics_kmeans(C, distance_matrix, result_grouping, cluster_distance_metrics_path)
    fileID = fopen(cluster_distance_metrics_path, 'w');
    amount_clusters = size(result_grouping, 2);
    for i = 1:amount_clusters
        [mean_distance, variance_distance, std_distance] = kmeans_distance_statistics_to_centroid(C, distance_matrix,result_grouping, i);
        fprintf(fileID, "%d %f %f %f\n",i, mean_distance, variance_distance, std_distance); 
    end
    fclose(fileID);
end


function [mean_distance, variance_distance, std_distance] = kmeans_distance_statistics_to_centroid(C, distance_matrix, result_grouping, cluster_i)
    result_column_i = result_grouping(:, cluster_i);
    file_ids_of_cluster_i = result_column_i(result_column_i > 0);
    amount_file_ids = size(file_ids_of_cluster_i, 1);
    
    cluster_i_centroid = C(cluster_i,:);
    individual_distance = zeros(amount_file_ids, 1);
    for i = 1:amount_file_ids
        id = file_ids_of_cluster_i(i);
        individual_distance(i) = sqrt(sum((distance_matrix(id,:) - cluster_i_centroid) .^ 2));
    end
    
    empty_cluster = size(individual_distance, 1) == 0;
    if(empty_cluster)
        individual_distance = 0;
    end
    
    mean_distance = mean(individual_distance);
    variance_distance = var(individual_distance);
    std_distance = std(individual_distance);
end

