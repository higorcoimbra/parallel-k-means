function constructAndPlotDistanceStatisticsChart(clusterMetrics, distanceStatistics, statisticPropertyColumn, chartConfiguration)
    
    TOTAL_SUPERPOSITIONS_COLUMN = 3;
    SUCCESSFULL_SUPERPOSITIONS_NUMBER = 4;
    CLUSTER_PERFORMANCE_COLUMN = 1;
    X_AXIS_COLUMN = 1;
    Y_AXIS_COLUMN = 2;
    
    distanceChartXAxis = (clusterMetrics(:, SUCCESSFULL_SUPERPOSITIONS_NUMBER)./clusterMetrics(:, TOTAL_SUPERPOSITIONS_COLUMN)).*100;
    distanceChartYAxis = distanceStatistics(:, statisticPropertyColumn);
    distanceChartData = [distanceChartXAxis distanceChartYAxis];
    
    [~, idxSortedByClusterPerformance] = sort(distanceChartData(:, CLUSTER_PERFORMANCE_COLUMN));
    
    sortedDistanceChartData = distanceChartData(idxSortedByClusterPerformance, :);

    plot(sortedDistanceChartData(:, X_AXIS_COLUMN), sortedDistanceChartData(:, Y_AXIS_COLUMN));
    xlabel(chartConfiguration.xLabel);
    ylabel(chartConfiguration.yLabel);
end