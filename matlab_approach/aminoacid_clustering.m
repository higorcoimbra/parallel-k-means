%read file
fileID = fopen('../protein_base/formatted_protein_base.txt', 'r');
formatSpec = '%d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n';
distance_matrix = fscanf(fileID, formatSpec, [67, 16383])';
fclose(fileID);

%execute k-means
idx = kmeans(distance_matrix(:, (2:67)), 500, 'Start', 'sample');

%create matrix to map each id file to the associated cluster
map_id_to_cluster = cat(2, distance_matrix(:,1), idx);

%group each cluster number on subsequent rows in a matrix


