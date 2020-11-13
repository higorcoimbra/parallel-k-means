function evaluatedXAxisValuesOverLinearRegressionResult = constructAndPlotLinearRegression(sortedDistanceChartData, color)
    X_AXIS_COLUMN = 1;
    Y_AXIS_COLUMN = 2;
    linearRegression = polyfit(sortedDistanceChartData(:, X_AXIS_COLUMN),sortedDistanceChartData(:, Y_AXIS_COLUMN),1);
    evaluatedXAxisValuesOverLinearRegressionResult = polyval(linearRegression, sortedDistanceChartData(:, X_AXIS_COLUMN));
    plot(sortedDistanceChartData(:, X_AXIS_COLUMN), evaluatedXAxisValuesOverLinearRegressionResult, 'Color', color);
end