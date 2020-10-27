importCommonConstants;

kmeansCqrMean = calculateMeanCqrAllExecutions(KMEANS_BASE_PATH);
gmmCqrMean = calculateMeanCqrAllExecutions(GMM_BASE_PATH);
config.xlabel = 'Porcentagem de sobreposições satisfatórias (Faixas de 10%)';
config.ylabel = 'Quantidade de clusters';
config.title = 'Relação entre sobreposições satisfatórias e número de clusters - 500 clusters';
config.legend = {'K-Means', 'MMG + EM'};
config.legendLocation = 'northwest';

plotComparison(kmeansCqrMean, gmmCqrMean, config);

kmeansCspsMean = calculateMeanCspsAllExecutions(KMEANS_BASE_PATH);
gmmCspsMean = calculateMeanCspsAllExecutions(GMM_BASE_PATH);
config.xlabel = 'Porcentagem de sobreposições satisfatórias (Faixas de 10%)';
config.ylabel = 'Quantidade de registros';
config.title = 'Relação entre sobreposições satisfatórias e quantidade de registros nos clusters - 500 clusters';
config.legend = {'K-Means', 'MMG + EM'};
config.legendLocation = 'northwest';

plotComparison(kmeansCspsMean, gmmCspsMean, config);

function plotComparison(array1, array2, config)
    bin_edges = 0:10:100;
    locs = 1:10;
    y1 = array1;
    y2 = array2;
    fig = figure();
    ax = axes();
    bar(locs, [y1' y2'])
    ax.XTick = locs;
    ax.XTickLabel = compose('%d-%d', bin_edges(1:end-1)', bin_edges(2:end)');
    ax.XTickLabelRotation = 90;
    xlabel(config.xlabel);
    ylabel(config.ylabel);
    title(config.title);
    legend(config.legend, 'Location', config.legendLocation);
end

function meanCqrAllExecutions = calculateMeanCqrAllExecutions(algorithmBasePath)
    importCommonConstants;
    cspsAccAllExecutions = zeros(NUMBER_EXECUTIONS, 10);
    for execution = 1:NUMBER_EXECUTIONS
        cspsFilePath = join([algorithmBasePath, NUMBER_CLUSTERS_STR, CLUSTER_QUALITY_RESULTS_FOLDER, CLUSTER_QUALITY_RESULTS_FILE_PREFIX, int2str(execution)]);
        cspsAccAllExecutions(execution, :) = importdata(cspsFilePath);
    end
    meanCqrAllExecutions = mean(cspsAccAllExecutions);
end


function meanCspsAllExecutions = calculateMeanCspsAllExecutions(algorithmBasePath)
    importCommonConstants;
    cspsAccAllExecutions = zeros(NUMBER_EXECUTIONS, 10);
    for execution = 1:NUMBER_EXECUTIONS
        cqrFilePath = join([algorithmBasePath, NUMBER_CLUSTERS_STR, CLUSTER_SIZES_FOLDER, CLUSTER_SIZES_FILE_PREFIX, int2str(execution)]);
        cspsAccAllExecutions(execution, :) = importdata(cqrFilePath);
    end
    meanCspsAllExecutions = mean(cspsAccAllExecutions);
end