function [] = plot_loop_data(lp, err_means_g, err_means_d, avg_errsum_g, avg_errsum_d, accum_w_diag_d, accum_w_diag_g, accum_w_off_g, accum_w_off_d)


% ---------------------------------------------------
% This is the phase diagram-like heatmap
% ---------------------------------------------------
figure()
imagesc((err_means_g - err_means_d)./err_means_g)

xlabel(lp.p2_desc, 'Interpreter', 'None')
ylabel(lp.p1_desc, 'Interpreter', 'None')

xticklabels(lp.p2_list)
yticklabels(lp.p1_list)

xticklabels()

title('Relative Performance')
cb = colorbar();
%ylabel(cb,'\bf{Improvement Relative to Gradient Descent}')
set(get(cb,'YLabel'),'Rotation',270)


% ---------------------------------------------------
% These are just for plotting averages without
% changes in params
% ---------------------------------------------------

% Error improvement
destr = err_accum_g(:,end) > err_accum_d(:,end);

figure();
plot(         mean(err_accum_d,1) ./ mean(err_accum_g,1)          , 'LineWidth', 2); hold on
plot(mean(err_accum_d(destr,:),1) ./ mean(err_accum_g(destr,:),1) , 'LineWidth', 2)
plot(mean(err_accum_d             ./ err_accum_g         )        , 'LineWidth', 2)
plot(mean(err_accum_d(destr,:)    ./ err_accum_g(destr,:))        , 'LineWidth', 2)

grid on
title('Relative Cumulative Error')
ylabel('Fraction Grad. Descent')
xlabel('Trial Number')
legend({'Ratio of Means, Ensemble', 'Ratio of Means, Destructive', 'Mean of Ratios, Ensemble', 'Mean of Ratios, Destructive'})
%xlim([0,18000])

[f,xi] = ksdensity((err_accum_d(:,end) ./ err_accum_g(:,end)));
histogram((err_accum_d(:,end) ./ err_accum_g(:,end)),'BinEdges',0:0.05:1.2, 'Normalization','pdf')
hold on
plot(xi,f,'LineWidth',2);
grid on
title('')


err    = squeeze(mean(err_accum_d(:,end,:,1) ./err_accum_g(:,end,:,1),1));
err_sd = squeeze(std(err_accum_d(:,end,:,1) ./err_accum_g(:,end,:,1),[],1));

pvals = 0.05:0.05:0.95;
plot(pvals, err); hold on;
plot(pvals, err + err_sd, '--k')
plot(pvals, err - err_sd, '--k')


% Weight Trajectory Comparison
figure()
plot(mean(accum_w_diag_g,1), 'LineWidth', 2)
hold on
plot(mean(accum_w_diag_d,1), 'LineWidth', 2)
plot(mean(accum_w_off_g,1) , 'LineWidth', 2)
plot(mean(accum_w_off_d,1) , 'LineWidth', 2)
grid on
legend({'G, diag', 'D, diag', 'G, off', 'D, off'})
title('Weight Trajectory Comparison')
xlabel('Trial Number')
ylabel('Weight Sum')
%xlim([0,18000])


% Improvement by depth
err_g = avg_errsum_depth_g;
err_d = avg_errsum_depth_d;

for i = 1:(tsk.depth+1)
   plot((err_g(i,:) - err_d(i,:)) ./ err_g(i,:), 'LineWidth',2); hold on
end

grid on
title('Improvement by Depth')
xlabel('Trial Number')
ylabel('Fractional Improvement')
ylabel('Improvement')
legend({'Depth 1', 'Depth 2', 'Depth 3'}, 'Location', 'SouthEast')
grid on


% ---------------------------------------------------
% These are for mixture variation only
% ---------------------------------------------------

% Off diagonal weights by mixture
figure()
cmap = cool(6);

plot(mean(mean(accum_w_off_g(:,:,:),1),3), 'k', 'LineWidth', 2)
hold on;
for i = 1:6
   plot(mean(accum_w_off_d(:,:,i),1), 'LineWidth', 2, 'Color', cmap(i,:))
end
grid on
xlabel('Trial Number')
ylabel('Weight')
title('Off Diag. Weight Trajectories')
legend({'G', 'P = 0', 'P = 0.2', 'P = 0.4', 'P = 0.6', 'P = 0.8', 'P = 1.0'})


% Cumulative error improvement by mixture
figure()
cmap = cool(6);

plot(mean(mean(err_accum_g(:,:,:),1),3), 'k', 'LineWidth', 2)
hold on;
for i = 1:6
   plot(mean(err_accum_d(:,:,i),1), 'LineWidth', 2, 'Color', cmap(i,:))
end
grid on
xlabel('Trial Number')
ylabel('Cumulative Error')
title('Performance by Mixture')
legend({'G', 'P = 0', 'P = 0.2', 'P = 0.4', 'P = 0.6', 'P = 0.8', 'P = 1.0'})


end