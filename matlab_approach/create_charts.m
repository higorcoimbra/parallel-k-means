bin_edges = 0:10:100;
locs = 1:10;
y1 = cqr_naive;
y2 = cqr_plus;
y3 = cqr_gmm;
fig = figure();
ax = axes();
bar(locs, [y1 y2 y3])
ax.XTick = locs;
ax.XTickLabel = compose('%d-%d', bin_edges(1:end-1)', bin_edges(2:end)');
ax.XTickLabelRotation = 90;