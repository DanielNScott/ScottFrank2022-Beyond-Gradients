
figure()
histogram(hist.g.stats.corrs, 'BinEdges', -1:0.02:1, 'Normalization', 'probability')


std(hist.g.stats.corrs)
mad(hist.g.stats.corrs)
xlim([0.4,1])

[df2,dx2] = ecdf(hist.g.corrs);
plot(dx2,df2, 'LineWidth', 2)
grid on
yticks(0:0.1:1)
xticks(-1:0.25:1)
ylabel('F(\rho)')
xlabel('\rho(g, y)')
title('Empirical Filter Correlation CDF')