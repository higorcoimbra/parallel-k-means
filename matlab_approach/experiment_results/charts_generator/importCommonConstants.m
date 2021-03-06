UPPER_DIRECTORY_REFERENCE = '../';

KMEANS_BASE_PATH = '../kmeans_';
GMM_BASE_PATH = '../gmm_';

CLUSTER_METRICS_FOLDER = 'cluster_metrics/';
CLUSTER_METRICS_FILE_PREFIX = 'cm_';

DISTANCE_STATISTICS_FOLDER = 'cdm/';
DISTANCE_STATISTICS_FILE_PREFIX = 'cdm_';

CLUSTER_QUALITY_RESULTS_FOLDER = 'cqr/';
CLUSTER_QUALITY_RESULTS_FILE_PREFIX = 'cqr_';

CLUSTER_SIZES_FOLDER = 'csps/';
CLUSTER_SIZES_FILE_PREFIX = 'csps_';

IDX_FOLDER = 'idx/';
IDX_FILE_PREFIX = 'idx_';

NUMBER_CLUSTERS_STR = join([int2str(750), '/']);
NUMBER_CLUSTERS = 750;
NUMBER_EXECUTIONS = 30;

DISTANCE_MEAN_COLUMN = 2;
DISTANCE_VARIANCE_COLUMN = 3;
DISTANCE_STD_DEVIATON_COLUMN = 4;

xLabel = 'Porcentagem de acerto dos clusters';
yLabel = 'Valor da média das distâncias';
CHART_CONFIG_DISTANCE_MEAN_STRUCT = struct('xLabel', xLabel, 'yLabel', yLabel);

xLabel = 'Porcentagem de acerto dos clusters';
yLabel = 'Valor da variância das distâncias';
CHART_CONFIG_DISTANCE_VARIANCE_STRUCT = struct('xLabel', xLabel, 'yLabel', yLabel);

xLabel = 'Porcentagem de acerto dos clusters';
yLabel = 'Valor do desvio padrão das distâncias';
CHART_CONFIG_DISTANCE_STD_DEVIATION_STRUCT = struct('xLabel', xLabel, 'yLabel', yLabel);