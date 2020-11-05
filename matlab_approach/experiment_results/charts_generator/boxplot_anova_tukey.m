importCommonConstants;

kmeansExecutionsClusterPerformance  = retrieveExecutionsClusterPerformance(KMEANS_BASE_PATH);

gmmExecutionsClusterPerformance  = retrieveExecutionsClusterPerformance(GMM_BASE_PATH);

%boxplot([kmeansExecutionsClusterPerformance gmmExecutionsClusterPerformance]);

function executionsClusterPerformance = retrieveExecutionsClusterPerformance(algorithmBasePath)
    importCommonConstants;
    executionsClusterPerformance  = zeros(NUMBER_EXECUTIONS, 1);
    for execution = 1:NUMBER_EXECUTIONS
        clusterMetrics = retrieveClusterMetricsMatrix(algorithmBasePath, execution);
        executionsClusterPerformance(execution) = sum(clusterMetrics(:, 4))/sum(clusterMetrics(:, 3));
    end
end

function clusterMetrics = retrieveClusterMetricsMatrix(clusteringAlgorithmBasePath,execution)
    importCommonConstants;
    clusterMetricsFilePath = join([clusteringAlgorithmBasePath, NUMBER_CLUSTERS_STR, CLUSTER_METRICS_FOLDER, CLUSTER_METRICS_FILE_PREFIX, int2str(execution)]);
    clusterMetrics = importdata(clusterMetricsFilePath);
end