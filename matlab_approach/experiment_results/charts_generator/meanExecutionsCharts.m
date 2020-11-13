% - concatenar as colunas de media, variancia e desvio padrao da distancia ate o centroide com o cluster_metrics
% - gerar uma nova matriz com as colunas: [porcentagem_acerto media variancia desvio]
% - para cada valor distinto de porcentagem_acerto:
%     - resgatar os indices da nova matriz que possuam aquela porcentagem
%     - armazenar os valores de media, variancia e desvio desses indices em um array
%     - calcular a media para cada uma das estatisticas
%     - gravar em uma nova matriz com as colunas [porcentagem media_media media_variancia media_desvio]
clear all;
close all;
importCommonConstants;

[allExecutionsClusterPerformanceDistanceStatisticsKmeans, eachExecutionMeanPerformanceKmeans, eachExecTotalSuccessfullOverlapsKmeans, eachExecTotalOverlapsKmeans] = generateClusterPerformanceDistanceStatisticsMatrix(KMEANS_BASE_PATH);
uniquePerformanceValuesKmeans = unique(allExecutionsClusterPerformanceDistanceStatisticsKmeans(:, 1));
meanExecutionChartsDataKmeans = generateMeanExecutionChartsData(allExecutionsClusterPerformanceDistanceStatisticsKmeans, uniquePerformanceValuesKmeans);

[allExecutionsClusterPerformanceDistanceStatisticsGmm, eachExecutionMeanPerformanceGmm, eachExecTotalSuccessfullOverlapsGmm, eachExecTotalOverlapsGmm] = generateClusterPerformanceDistanceStatisticsMatrix(GMM_BASE_PATH);
uniquePerformanceValuesGmm = unique(allExecutionsClusterPerformanceDistanceStatisticsGmm(:, 1));
meanExecutionChartsDataGmm = generateMeanExecutionChartsData(allExecutionsClusterPerformanceDistanceStatisticsGmm, uniquePerformanceValuesGmm);

%performance boxplot
boxplot([eachExecutionMeanPerformanceKmeans, eachExecutionMeanPerformanceGmm], 'Labels', {'K-Means', 'EM + MMG'});
ylabel('Taxa de aproveitamento média (todos os clusters)', 'FontSize', 12);
title(join(['Boxplot da taxa de aproveitamento média para comparação entre K-Means e EM + MMG -', int2str(NUMBER_CLUSTERS), ' clusters']));
% 
% eachExecutionSuccessfullOverlapsPercentageKmeans = eachExecTotalSuccessfullOverlapsKmeans./eachExecTotalOverlapsKmeans;
% eachExecutionSuccessfullOverlapsPercentageGmm = eachExecTotalSuccessfullOverlapsGmm./eachExecTotalOverlapsGmm;

% successfull overlaps
% boxplot([eachExecutionSuccessfullOverlapsPercentageKmeans.*100, eachExecutionSuccessfullOverlapsPercentageGmm.*100], 'Labels', {'K-Means', 'EM + MMG'});
% ylabel('Porcentagem de sobreposições satisfatórias');
% title(join(['Boxplot da porcentagem de sobreposições satisfatórias para comparação entre K-Means e EM + MMG - ', int2str(NUMBER_CLUSTERS), ' clusters']));
% hDifferentPercentageSuccessfullOverlaps = ttest2(eachExecutionSuccessfullOverlapsPercentageKmeans.*100, eachExecutionSuccessfullOverlapsPercentageGmm.*100);
% hKmeansHaveGreaterPercentageSuccessfullOverlaps = ttest2(eachExecutionSuccessfullOverlapsPercentageKmeans.*100, eachExecutionSuccessfullOverlapsPercentageGmm.*100, 'Tail', 'right');
% 
% meanExecutionChartsDataKmeans(:, 1) = meanExecutionChartsDataKmeans(:, 1)*100;
% meanExecutionChartsDataGmm(:, 1) = meanExecutionChartsDataGmm(:, 1)*100;

% distance mean
% plot(meanExecutionChartsDataKmeans(:, 1), meanExecutionChartsDataKmeans(:, 2));
% hold on;
% constructAndPlotLinearRegression(meanExecutionChartsDataKmeans, 'green');
% xlabel('Taxa de aproveitamento (%)', 'FontSize', 13);
% ylabel('Média das distâncias dos registros ao centróide do cluster', 'FontSize', 13);
% legend({'Relação aproveitamento x média das distâncias', 'Regressão Linear'}, 'FontSize',12);
% title(join(['K-Means: relação aproveitamento x média das distâncias dos pontos aos centróides - ', int2str(NUMBER_CLUSTERS),' clusters']));
% 
% figure;
% 
% plot(meanExecutionChartsDataGmm(:, 1), meanExecutionChartsDataGmm(:, 2), 'Color', [0.8500, 0.3250, 0.0980]);
% hold on;
% evaluatedXAxisValuesOverLinearRegressionResult = constructAndPlotLinearRegression(meanExecutionChartsDataGmm, [0.4940, 0.1840, 0.5560]);
% xlabel('Taxa de aproveitamento (%)', 'FontSize', 13);
% ylabel('Média das distâncias dos registros ao centróide do cluster', 'FontSize', 13);
% legend({'Relação aproveitamento x média das distâncias', 'Regressão Linear'}, 'FontSize', 12);
% title(join(['MMG: relação aproveitamento x média das distâncias dos pontos aos centróides - ', int2str(NUMBER_CLUSTERS),' clusters']));

% xlabel('Porcentagem de sobreposições satisfatórias');
% ylabel('Média da distância dos elementos do cluster ao centróide');
% title('Relação entre porcentagem de sobreposições satisfatórias e média da distância dos elementos ao centróide - 500 clusters');
% legend('K-Means', 'MMG + EM');

% %distance variance
% plot(meanExecutionChartsDataKmeans(:, 1), meanExecutionChartsDataKmeans(:, 3));
% hold on 
% plot(meanExecutionChartsDataGmm(:, 1), meanExecutionChartsDataGmm(:, 3), 'Color', [1, 0, 0, 0.2]);
% xlabel('Porcentagem de sobreposições satisfatórias');
% ylabel('Variância da distância dos elementos do cluster ao centróide');
% title('Relação entre porcentagem de sobreposições satisfatórias e variância da distância dos elementos ao centróide - 500 clusters');
% legend('K-Means', 'MMG + EM');
% figure;
% 
% %distance standard deviation
% plot(meanExecutionChartsDataKmeans(:, 1), meanExecutionChartsDataKmeans(:, 4));
% hold on 
% plot(meanExecutionChartsDataGmm(:, 1), meanExecutionChartsDataGmm(:, 4), 'Color', [1, 0, 0, 0.2]);
% xlabel('Porcentagem de sobreposições satisfatórias');
% ylabel('Desvio padrão da distância dos elementos do cluster ao centróide');
% title('Relação entre porcentagem de sobreposições satisfatórias e desvio padrão da distância dos elementos ao centróide - 500 clusters');
% legend('K-Means', 'MMG + EM');

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

function [allExecutionsClusterPerformanceDistanceStatistics, eachExecutionMeanPerformance, eachExecTotalSuccessfullOverlaps, eachExecTotalOverlaps] = generateClusterPerformanceDistanceStatisticsMatrix(algorithmBasePath)    
    importCommonConstants; 
    TOTAL_SUPERPOSITIONS_COLUMN = 3;
    SUCCESSFULL_SUPERPOSITIONS_NUMBER = 4;
    allExecutionsClusterPerformanceDistanceStatistics = [];
    eachExecutionMeanPerformance = zeros(NUMBER_EXECUTIONS, 1);
    eachExecTotalSuccessfullOverlaps = zeros(NUMBER_EXECUTIONS, 1);
    eachExecTotalOverlaps = zeros(NUMBER_EXECUTIONS, 1);
    for execution = 1:NUMBER_EXECUTIONS
        clusterMetrics = retrieveClusterMetricsMatrix(execution, algorithmBasePath, NUMBER_CLUSTERS_STR, CLUSTER_METRICS_FOLDER, CLUSTER_METRICS_FILE_PREFIX);
        distanceStatistics = retrieveDistanceStatisticsMatrix(execution, algorithmBasePath, NUMBER_CLUSTERS_STR, DISTANCE_STATISTICS_FOLDER, DISTANCE_STATISTICS_FILE_PREFIX);
        eachExecTotalSuccessfullOverlaps(execution) = sum(clusterMetrics(:, SUCCESSFULL_SUPERPOSITIONS_NUMBER));
        eachExecTotalOverlaps(execution) = sum(clusterMetrics(:, TOTAL_SUPERPOSITIONS_COLUMN));
        executionPerformance = clusterMetrics(:, SUCCESSFULL_SUPERPOSITIONS_NUMBER)./clusterMetrics(:, TOTAL_SUPERPOSITIONS_COLUMN);
        executionPerformance(isnan(executionPerformance)) = 0;
        eachExecutionMeanPerformance(execution) = mean(executionPerformance);
        executionClusterPerformanceDistanceStatistics = [executionPerformance distanceStatistics(:, 2:4)];
        allExecutionsClusterPerformanceDistanceStatistics = cat(1, allExecutionsClusterPerformanceDistanceStatistics, executionClusterPerformanceDistanceStatistics);
    end
end
%0.5331, 0.5584; 0.5957, 0.5963
function clusterMetrics = retrieveClusterMetricsMatrix(execution, KMEANS_BASE_PATH, NUMBER_CLUSTERS_STR, CLUSTER_METRICS_FOLDER, CLUSTER_METRICS_FILE_PREFIX)
    clusterMetricsFilePath = join([KMEANS_BASE_PATH, NUMBER_CLUSTERS_STR, CLUSTER_METRICS_FOLDER, CLUSTER_METRICS_FILE_PREFIX, int2str(execution)]);
    clusterMetrics = importdata(clusterMetricsFilePath);
end

function distanceStatistics = retrieveDistanceStatisticsMatrix(execution, KMEANS_BASE_PATH, NUMBER_CLUSTERS_STR, DISTANCE_STATISTICS_FOLDER, DISTANCE_STATISTICS_FILE_PREFIX)
    distanceStatisticsFilePath = join([KMEANS_BASE_PATH, NUMBER_CLUSTERS_STR, DISTANCE_STATISTICS_FOLDER, DISTANCE_STATISTICS_FILE_PREFIX, int2str(execution)]);
    distanceStatistics = importdata(distanceStatisticsFilePath);
end