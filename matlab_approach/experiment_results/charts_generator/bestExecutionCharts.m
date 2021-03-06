importCommonConstants;

bestKmeansOverallPerformanceExecution = calculateBestOverallPerformanceExecution(KMEANS_BASE_PATH, NUMBER_CLUSTERS_STR, NUMBER_EXECUTIONS, CLUSTER_METRICS_FOLDER, CLUSTER_METRICS_FILE_PREFIX);

bestGmmOverallPerformanceExecution = calculateBestOverallPerformanceExecution(GMM_BASE_PATH, NUMBER_CLUSTERS_STR, NUMBER_EXECUTIONS, CLUSTER_METRICS_FOLDER, CLUSTER_METRICS_FILE_PREFIX);

kmeansClusterMetrics = retrieveClusterMetricsMatrix(bestKmeansOverallPerformanceExecution, KMEANS_BASE_PATH, NUMBER_CLUSTERS_STR, CLUSTER_METRICS_FOLDER, CLUSTER_METRICS_FILE_PREFIX);
kmeansDistanceStatistics = retrieveDistanceStatisticsMatrix(bestKmeansOverallPerformanceExecution, KMEANS_BASE_PATH, NUMBER_CLUSTERS_STR, DISTANCE_STATISTICS_FOLDER, DISTANCE_STATISTICS_FILE_PREFIX);

gmmClusterMetrics = retrieveClusterMetricsMatrix(bestGmmOverallPerformanceExecution, GMM_BASE_PATH, NUMBER_CLUSTERS_STR, CLUSTER_METRICS_FOLDER, CLUSTER_METRICS_FILE_PREFIX);
gmmClusterMetrics = sanitizeGmm500ClusterMetrics(gmmClusterMetrics);
gmmDistanceStatistics = retrieveDistanceStatisticsMatrix(bestGmmOverallPerformanceExecution, GMM_BASE_PATH, NUMBER_CLUSTERS_STR, DISTANCE_STATISTICS_FOLDER, DISTANCE_STATISTICS_FILE_PREFIX);

sortedDistanceChartData = constructAndPlotDistanceStatisticsChart(kmeansClusterMetrics, kmeansDistanceStatistics, DISTANCE_MEAN_COLUMN, CHART_CONFIG_DISTANCE_MEAN_STRUCT);
hold on;
constructAndPlotLinearRegression(sortedDistanceChartData);
hold on;
sortedDistanceChartData = constructAndPlotDistanceStatisticsChart(gmmClusterMetrics, gmmDistanceStatistics, DISTANCE_MEAN_COLUMN, CHART_CONFIG_DISTANCE_MEAN_STRUCT);
hold on;
constructAndPlotLinearRegression(sortedDistanceChartData);

figure;

constructAndPlotDistanceStatisticsChart(kmeansClusterMetrics, kmeansDistanceStatistics, DISTANCE_VARIANCE_COLUMN, CHART_CONFIG_DISTANCE_VARIANCE_STRUCT);
hold on;
constructAndPlotDistanceStatisticsChart(gmmClusterMetrics, gmmDistanceStatistics, DISTANCE_VARIANCE_COLUMN, CHART_CONFIG_DISTANCE_VARIANCE_STRUCT);

figure;

constructAndPlotDistanceStatisticsChart(kmeansClusterMetrics, kmeansDistanceStatistics, DISTANCE_STD_DEVIATON_COLUMN, CHART_CONFIG_DISTANCE_STD_DEVIATION_STRUCT);
hold on;
constructAndPlotDistanceStatisticsChart(gmmClusterMetrics, gmmDistanceStatistics, DISTANCE_STD_DEVIATON_COLUMN, CHART_CONFIG_DISTANCE_STD_DEVIATION_STRUCT);

function distanceStatistics = retrieveDistanceStatisticsMatrix(bestOverallPerformanceExecution, KMEANS_BASE_PATH, NUMBER_CLUSTERS_STR, DISTANCE_STATISTICS_FOLDER, DISTANCE_STATISTICS_FILE_PREFIX)
    distanceStatisticsFilePath = join([KMEANS_BASE_PATH, NUMBER_CLUSTERS_STR, DISTANCE_STATISTICS_FOLDER, DISTANCE_STATISTICS_FILE_PREFIX, int2str(bestOverallPerformanceExecution)]);
    distanceStatistics = importdata(distanceStatisticsFilePath);
end

function clusterMetrics = retrieveClusterMetricsMatrix(bestOverallPerformanceExecution, KMEANS_BASE_PATH, NUMBER_CLUSTERS_STR, CLUSTER_METRICS_FOLDER, CLUSTER_METRICS_FILE_PREFIX)
    clusterMetricsFilePath = join([KMEANS_BASE_PATH, NUMBER_CLUSTERS_STR, CLUSTER_METRICS_FOLDER, CLUSTER_METRICS_FILE_PREFIX, int2str(bestOverallPerformanceExecution)]);
    clusterMetrics = importdata(clusterMetricsFilePath);
end

function sanitizedClusterMetrics = sanitizeGmm500ClusterMetrics(unsanitizedClusterMetrics)
    uniqueElementClustersIndex = unsanitizedClusterMetrics(unsanitizedClusterMetrics(:, 2) == 1);
    unsanitizedClusterMetrics(uniqueElementClustersIndex, 3) = 0;
    unsanitizedClusterMetrics(uniqueElementClustersIndex, 4) = 0;
    emptyClustersIndex = unsanitizedClusterMetrics(unsanitizedClusterMetrics(:, 2) == 0);
    unsanitizedClusterMetrics(emptyClustersIndex , 3) = 0;
    unsanitizedClusterMetrics(emptyClustersIndex , 4) = 0;
    sanitizedClusterMetrics = unsanitizedClusterMetrics; 
end
