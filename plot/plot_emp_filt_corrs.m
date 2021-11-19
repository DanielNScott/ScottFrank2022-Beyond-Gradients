
figure()

[cs  , cms  , msk  ] = get_cms(  hist.g.corrs,   hist.g.mags);
[cs2k, cms2k, msk2k] = get_cms(hist2k.g.corrs, hist2k.g.mags);

% subplot(2,2,1)
% plot(cms  , 'LineWidth', 2); hold on
% plot(cms2k, 'LineWidth', 2); hold on
% 
% ylabel('Cumulative Weight Change')
% xlabel('Mag. Sorted Update Number')
% title('Update Magnitude Impact')
% grid on

subplot(1,2,1)
[f  , x  ] = ecdf(cs(msk));
[f2k, x2k] = ecdf(cs2k(msk2k));

plot(x  , f  , 'LineWidth', 2); hold on;
plot(x2k, f2k, 'LineWidth', 2);

grid on
xlim([0.95,1])
yticks(0:0.2:1)
xticks(0.95:0.01:1)
ylabel('F(\rho)')
xlabel('\rho(g, y)')
title('Empirical Filter Correlation CDF')
legend({'1k','2k'},'Location','NorthWest')


[cs  , cms  , msk  ] = get_cms(  hist.d.corrs,   hist.d.mags);
[cs2k, cms2k, msk2k] = get_cms(hist2k.d.corrs, hist2k.d.mags);
% 
% subplot(2,2,2)
% plot(cms  , 'LineWidth', 2); hold on
% plot(cms2k, 'LineWidth', 2); hold on
% 
% ylabel('Cumulative Weight Change')
% xlabel('Mag. Sorted Update Number')
% title('Update Magnitude Impact')
% grid on

subplot(1,2,2)
[f  , x  ] = ecdf(cs(msk));
[f2k, x2k] = ecdf(cs2k(msk2k));

plot(x  , f  , 'LineWidth', 2); hold on;
plot(x2k, f2k, 'LineWidth', 2);

grid on
xlim([0.95,1])
yticks(0:0.2:1)
xticks(0.95:0.01:1)
ylabel('F(\rho)')
xlabel('\rho(d, y)')
title('Empirical Filter Correlation CDF')
legend({'1k','2k'},'Location','NorthWest')

set(gcf,'Position', [100   649   915   295])


function [cs, cms, msk] = get_cms(corrs, mags)

   cs = corrs;
   ms = mags;
   [ms, inds] = sort(ms);
   cs = cs(inds);

   cms = cumsum(ms);
   cms = cms./max(cms);

   msk = cms > 0.05;

end