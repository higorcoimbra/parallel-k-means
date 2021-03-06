function bestOverallPerformanceExecutionNumber = calculateBestOverallPerformanceExecution(analysisClusteringAlgorithm, numberClustersStr, numberExecutions, clusterMetricsFolder, clusterMetricsFilePrefix)
    
    clusterMetricsBaseFilePath = join([analysisClusteringAlgorithm, numberClustersStr, clusterMetricsFolder, clusterMetricsFilePrefix]);
    
    overallPerformanceAllExecutions = zeros(numberExecutions, 1);
    
    for execution = 1:numberExecutions
        clusterMetricsExecutionFilePath = join([clusterMetricsBaseFilePath, int2str(execution)]);
        clusterMetricsOfExecution = importdata(clusterMetricsExecutionFilePath);
        if isequal(analysisClusteringAlgorithm, '../gmm_')
            clusterMetricsOfExecution = sanitizeGmm500ClusterMetrics(clusterMetricsOfExecution);
        end
        
        overallPerformanceExecution = calculateOverallPerformance(clusterMetricsOfExecution);
        overallPerformanceAllExecutions(execution) = overallPerformanceExecution;
    end
    
    [~, bestOverallPerformanceExecutionNumber]  = max(overallPerformanceAllExecutions);
    
    function overallPerformance = calculateOverallPerformance(clusterMetrics)
        TOTAL_SUPERPOSITIONS_COLUMN = 3;
        SUCCESSFULL_SUPERPOSITIONS_NUMBER = 4;
        
        sumTotalSuperpositionsPerCluster = sum(clusterMetrics(:, TOTAL_SUPERPOSITIONS_COLUMN));
        sumSuccesfullSuperpositionsPerCluster = sum(clusterMetrics(:, SUCCESSFULL_SUPERPOSITIONS_NUMBER));
        
        overallPerformance = sumSuccesfullSuperpositionsPerCluster/sumTotalSuperpositionsPerCluster;
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
end