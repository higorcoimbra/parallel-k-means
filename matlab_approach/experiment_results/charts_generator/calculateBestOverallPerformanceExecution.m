function bestOverallPerformanceExecutionNumber = calculateBestOverallPerformanceExecution(analysisClusteringAlgorithm, numberClustersStr, numberExecutions, clusterMetricsFolder, clusterMetricsFilePrefix)
    
    clusterMetricsBaseFilePath = join([analysisClusteringAlgorithm, numberClustersStr, clusterMetricsFolder, clusterMetricsFilePrefix]);
    
    overallPerformanceAllExecutions = zeros(numberExecutions, 1);
    
    for execution = 1:numberExecutions
        clusterMetricsExecutionFilePath = join([clusterMetricsBaseFilePath, int2str(execution)]);
        clusterMetricsOfExecution = importdata(clusterMetricsExecutionFilePath);
        
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
end