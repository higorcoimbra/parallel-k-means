%constants
%numeric
number_of_files = 16383;
number_of_clusters = 100;
data_column_start = 2;
data_column_finish = 67;
number_of_atoms = 12;
max_rms = 0.5;
%text
formatted_protein_base_format_spec = '%d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n';
call_lsqkab_shell_command = "../lsqkab_scripts/get_rms.sh ../lsqkab_scripts/map_file_id_to_file_name ";

%read file
fileID = fopen('../protein_base/formatted_protein_base.txt', 'r');
distance_matrix = fscanf(fileID, formatted_protein_base_format_spec, [data_column_finish, number_of_files])';
fclose(fileID);

%execute k-means
idx = kmeans(distance_matrix(:, (data_column_start:data_column_finish)), number_of_clusters, 'Start', 'sample');

%create matrix to map each id file to the associated cluster
map_file_id_to_cluster_id = cat(2, distance_matrix(:,1), idx);

%load the map structure from file id to filename
fileID = fopen('../lsqkab_scripts/map_file_id_to_file_name', 'r');
file_id_to_filename_cell_array = textscan(fileID, '%s %s');
map_file_id_to_filename = containers.Map(file_id_to_filename_cell_array{1}, file_id_to_filename_cell_array{2});
fclose(fileID);

% group each index to its determined cluster into a result matrix
result_grouping = zeros(number_of_files, number_of_clusters);
for i = 1:number_of_files
    result_grouping(i, map_file_id_to_cluster_id(i,2)) = map_file_id_to_cluster_id(i,1);  
end

for i = 1:1
    result_column_i = result_grouping(:, i);
    file_ids_of_cluster_i = result_column_i(result_column_i > 0);
    number_of_files_cluster_i = size(file_ids_of_cluster_i, 1);
    number_of_successfull_superpositions = 0;
    
    for j = 1:(number_of_files_cluster_i-1)
        for k = (j+1):number_of_files_cluster_i
            [~, cmdout] = system(join([call_lsqkab_shell_command, int2str(file_ids_of_cluster_i(j)), ' ', int2str(file_ids_of_cluster_i(k))]));
            match_rms_criteria = str2double(cmdout);
            [~, cmdout] = system(join([call_lsqkab_shell_command, int2str(file_ids_of_cluster_i(k)), ' ', int2str(file_ids_of_cluster_i(j))]));
            match_rms_criteria_inverted_arguments = str2double(cmdout);
            number_of_successfull_superpositions = number_of_successfull_superpositions + (match_rms_criteria > max_rms);
            number_of_successfull_superpositions = number_of_successfull_superpositions + (match_rms_criteria_inverted_arguments > max_rms);
        end
    end
    
    succesfull_rms_rate = number_of_successfull_superpositions/((number_of_files_cluster_i)*(number_of_files_cluster_i-1));
end







