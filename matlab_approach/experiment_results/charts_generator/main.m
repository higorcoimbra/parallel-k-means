importCommonConstants;

bestOverallPerformanceExecution = calculateBestOverallPerformanceExecution(KMEANS_BASE_PATH, NUMBER_CLUSTERS_STR, NUMBER_EXECUTIONS, CLUSTER_METRICS_FOLDER, CLUSTER_METRICS_FILE_PREFIX);

clusterMetricsFilePath = join([KMEANS_BASE_PATH, NUMBER_CLUSTERS_STR, CLUSTER_METRICS_FOLDER, CLUSTER_METRICS_FILE_PREFIX, int2str(bestOverallPerformanceExecution)]);
distanceStatisticsFilePath = join([KMEANS_BASE_PATH, NUMBER_CLUSTERS_STR, DISTANCE_STATISTICS_FOLDER, DISTANCE_STATISTICS_FILE_PREFIX, int2str(bestOverallPerformanceExecution)]);

clusterMetrics = importdata(clusterMetricsFilePath);
distanceStatistics = importdata(distanceStatisticsFilePath);

plot(clusterMetrics(:, 4)./clusterMetrics(:, 3), distanceStatistics(:, 2));

% 
% function distanceStatistics = readClusterDistanceStatistics()
%     distanceStatisticsFilePath
%     distanceStatistics = importdata();
% end