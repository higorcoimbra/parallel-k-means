%read file
fileID = fopen('../protein_base/formatted_protein_base.txt', 'r');
formatSpec = '%d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n';
distance_matrix = fscanf(fileID, formatSpec, [67, 16383])';
fclose(fileID);

%execute k-means
f = @() kmeans(distance_matrix(:, (2:67)), 500, 'Start', 'sample');
timeit(f)

