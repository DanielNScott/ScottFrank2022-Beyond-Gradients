function [] = plot_loop_data(lp, err_means_g, err_means_d, avg_errsum_g, avg_errsum_d, accum_w_diag_d, accum_w_diag_g, accum_w_off_g, accum_w_off_d)


% This is the phase diagram-like heatmap
figure()
imagesc((err_means_g - err_means_d)./err_means_g)
xlabel(lp.p1_name, 'Interpreter', 'None')
ylabel(lp.p2_name, 'Interpreter', 'None')
xticklabels()

title('Projective Algorithm Performance')
cb = colorbar();
ylabel(cb,'\bf{Improvement Relative to Gradient Descent}')
set(get(cb,'YLabel'),'Rotation',270)


% ---------------------------------------------------
% These are just for plotting averages without
% changes in params
% ---------------------------------------------------

% Error improvement
figure(); 
plot((avg_errsum_g - avg_errsum_d) ./ avg_errsum_g)
grid on
title('Cumulative Error Improvement by Time')
ylabel('Fraction of Cumulative Gradient Error')
xlabel('Trial Number')
%xlim([0,18000])

% Weight Trajectory Comparison
figure()
plot(mean(accum_w_diag_g,1))
hold on
plot(mean(accum_w_diag_d,1))
plot(mean(accum_w_off_g,1))
plot(mean(accum_w_off_d,1))
grid on
legend({'Diag. Wgts under G', 'Diag. Wgts Under D', 'Off-Diag Wgts under G', 'Off-Diag Wgts under D'})
title('Weight Trajectory Comparison')
xlabel('Trial Number')
ylabel('Weight Sum')
%xlim([0,18000])


end