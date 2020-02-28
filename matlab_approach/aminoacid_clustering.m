%constants util
number_of_files = 16383;
number_of_clusters = 100;
data_column_start = 2;
data_column_finish = 67;

%read file
fileID = fopen('../protein_base/formatted_protein_base.txt', 'r');
formatSpec = '%d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n';
distance_matrix = fscanf(fileID, formatSpec, [data_column_finish, number_of_files])';
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


