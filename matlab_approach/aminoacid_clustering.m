%constants util
number_of_files = 16383;
number_of_clusters = 500;
data_column_start = 2;
data_column_finish = 67;

%read file
fileID = fopen('../protein_base/formatted_protein_base.txt', 'r');
formatSpec = '%d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n';
distance_matrix = fscanf(fileID, formatSpec, [67, 16383])';
fclose(fileID);

%execute k-means
idx = kmeans(distance_matrix(:, (data_column_start:data_column_finish)), number_of_clusters, 'Start', 'sample');

%create matrix to map each id file to the associated cluster
map_file_id_to_cluster_id = cat(2, distance_matrix(:,1), idx);

%group each index to its determined cluster into a result matrix
result_grouping = zeros(number_of_files, number_of_clusters);
for i = 1:number_of_files
    result_grouping(i, map_file_id_to_cluster_id(i,2)) = map_file_id_to_cluster_id(i,1);  
end

