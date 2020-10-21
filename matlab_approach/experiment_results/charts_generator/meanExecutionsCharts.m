% - concatenar as colunas de media, variancia e desvio padrao da distancia ate o centroide com o cluster_metrics
% - gerar uma nova matriz com as colunas: [porcentagem_acerto media variancia desvio]
% - para cada valor distinto de porcentagem_acerto:
%     - resgatar os indices da nova matriz que possuam aquela porcentagem
%     - armazenar os valores de media, variancia e desvio desses indices em um array
%     - calcular a media para cada uma das estatisticas
%     - gravar em uma nova matriz com as colunas [porcentagem media_media media_variancia media_desvio]

importCommonConstants;

allExecutionsClusterPerformanceDistanceStatisticsKmeans = generateClusterPerformanceDistanceStatisticsMatrix(KMEANS_BASE_PATH);
uniquePerformanceValuesKmeans = unique(allExecutionsClusterPerformanceDistanceStatisticsKmeans(:, 1));
meanExecutionChartsDataKmeans = generateMeanExecutionChartsData(allExecutionsClusterPerformanceDistanceStatisticsKmeans, uniquePerformanceValuesKmeans);

allExecutionsClusterPerformanceDistanceStatisticsGmm = generateClusterPerformanceDistanceStatisticsMatrix(GMM_BASE_PATH);
uniquePerformanceValuesGmm = unique(allExecutionsClusterPerformanceDistanceStatisticsGmm(:, 1));
meanExecutionChartsDataGmm = generateMeanExecutionChartsData(allExecutionsClusterPerformanceDistanceStatisticsGmm, uniquePerformanceValuesGmm);

%distance mean
plot(meanExecutionChartsDataKmeans(:, 1), meanExecutionChartsDataKmeans(:, 2));
hold on 
plot(meanExecutionChartsDataGmm(:, 1), meanExecutionChartsDataGmm(:, 2));

figure;

%distance variance
plot(meanExecutionChartsDataKmeans(:, 1), meanExecutionChartsDataKmeans(:, 3));
hold on 
plot(meanExecutionChartsDataGmm(:, 1), meanExecutionChartsDataGmm(:, 3));

figure;

%distance standard deviation
plot(meanExecutionChartsDataKmeans(:, 1), meanExecutionChartsDataKmeans(:, 4));
hold on 
plot(meanExecutionChartsDataGmm(:, 1), meanExecutionChartsDataGmm(:, 4));

function meanExecutionChartsData = generateMeanExecutionChartsData(allExecutionsClusterPerformanceDistanceStatistics, uniquePerformanceValues)
    meanExecutionChartsData = [];
    for i = 1:size(uniquePerformanceValues, 1)
        performanceValueIndexes = find(allExecutionsClusterPerformanceDistanceStatistics(:, 1) == uniquePerformanceValues(i));
        distanceStatistics = allExecutionsClusterPerformanceDistanceStatistics(performanceValueIndexes, 2:4);
        if size(distanceStatistics, 1) > 1
            distanceStatistics = mean(distanceStatistics);
        end
        meanExecutionChartsData = cat(1, meanExecutionChartsData, [uniquePerformanceValues(i) distanceStatistics]);
    end
end

function [allExecutionsClusterPerformanceDistanceStatistics] = generateClusterPerformanceDistanceStatisticsMatrix(algorithmBasePath)    
    importCommonConstants; 
    TOTAL_SUPERPOSITIONS_COLUMN = 3;
    SUCCESSFULL_SUPERPOSITIONS_NUMBER = 4;
    allExecutionsClusterPerformanceDistanceStatistics = [];
    for execution = 1:NUMBER_EXECUTIONS
        clusterMetrics = retrieveClusterMetricsMatrix(execution, algorithmBasePath, NUMBER_CLUSTERS_STR, CLUSTER_METRICS_FOLDER, CLUSTER_METRICS_FILE_PREFIX);
        distanceStatistics = retrieveDistanceStatisticsMatrix(execution, algorithmBasePath, NUMBER_CLUSTERS_STR, DISTANCE_STATISTICS_FOLDER, DISTANCE_STATISTICS_FILE_PREFIX);
        executionPerformance = clusterMetrics(:, SUCCESSFULL_SUPERPOSITIONS_NUMBER)./clusterMetrics(:, TOTAL_SUPERPOSITIONS_COLUMN);
        executionPerformance(isnan(executionPerformance)) = 0;
        executionClusterPerformanceDistanceStatistics = [executionPerformance distanceStatistics(:, 2:4)];
        allExecutionsClusterPerformanceDistanceStatistics = cat(1, allExecutionsClusterPerformanceDistanceStatistics, executionClusterPerformanceDistanceStatistics);
    end
end

function clusterMetrics = retrieveClusterMetricsMatrix(execution, KMEANS_BASE_PATH, NUMBER_CLUSTERS_STR, CLUSTER_METRICS_FOLDER, CLUSTER_METRICS_FILE_PREFIX)
    clusterMetricsFilePath = join([KMEANS_BASE_PATH, NUMBER_CLUSTERS_STR, CLUSTER_METRICS_FOLDER, CLUSTER_METRICS_FILE_PREFIX, int2str(execution)]);
    clusterMetrics = importdata(clusterMetricsFilePath);
end

function distanceStatistics = retrieveDistanceStatisticsMatrix(execution, KMEANS_BASE_PATH, NUMBER_CLUSTERS_STR, DISTANCE_STATISTICS_FOLDER, DISTANCE_STATISTICS_FILE_PREFIX)
    distanceStatisticsFilePath = join([KMEANS_BASE_PATH, NUMBER_CLUSTERS_STR, DISTANCE_STATISTICS_FOLDER, DISTANCE_STATISTICS_FILE_PREFIX, int2str(execution)]);
    distanceStatistics = importdata(distanceStatisticsFilePath);
end



function [performanceDistanceStatisticsMatrix] = generatePerformanceDistanceStatisticsMatrix
end