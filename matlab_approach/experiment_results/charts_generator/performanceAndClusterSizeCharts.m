importCommonConstants;
kmeansCqrMean = calculateMeanCqrAllExecutions(KMEANS_BASE_PATH);
gmmCqrMean = calculateMeanCqrAllExecutions(GMM_BASE_PATH);

plotComparison(kmeansCqrMean, gmmCqrMean);

kmeansCspsMean = calculateMeanCspsAllExecutions(KMEANS_BASE_PATH);
gmmCspsMean = calculateMeanCspsAllExecutions(GMM_BASE_PATH);

plotComparison(kmeansCspsMean, gmmCspsMean);

function plotComparison(array1, array2)
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
    cqrAccAllExecutions = zeros(NUMBER_EXECUTIONS, 10);
    for execution = 1:NUMBER_EXECUTIONS
        cqrFilePath = join([algorithmBasePath, NUMBER_CLUSTERS_STR, CLUSTER_SIZES_FOLDER, CLUSTER_SIZES_FILE_PREFIX, int2str(execution)]);
        cqrAccAllExecutions(execution, :) = importdata(cqrFilePath);
    end
    meanCspsAllExecutions = mean(cqrAccAllExecutions);
end