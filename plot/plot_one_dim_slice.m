function [] = plot_one_dim_slice(err_accum_g, err_accum_d, mark_ind)

% mark_ind = 17;

nan_count_d = sum(squeeze(isnan(err_accum_d(:,end,:))));
nan_count_g = sum(squeeze(isnan(err_accum_g(:,end,:))));

disp([nan_count_d; nan_count_g])

err    = squeeze(nanmean(err_accum_d(:,end,:,1) ./err_accum_g(:,end,:,1),1));
err_sd = squeeze(nanstd(err_accum_d(:,end,:,1)  ./err_accum_g(:,end,:,1),[],1));

pvals = 0.0:0.05:0.95;
plot(pvals, err, '-o', 'LineWidth', 2); hold on;
plot(pvals, err + err_sd, '--k')
plot(pvals(mark_ind), err(mark_ind), 'rx', 'LineWidth',2)
plot(pvals, err - err_sd, '--k')

grid on
size_as_single_panel_small

%
title('Impact of Anisotropy Strength')
xlabel('Parameter P')
ylabel('Relative Error')
legend({'Ensemble Mean', 'Ensemble S.D.','Param Setting'})

%
title('Impact of Input Overlap')
xlabel('Input Correlation')
ylabel('Relative Error')
legend({'Ensemble Mean', 'Ensemble S.D.','Param Setting'})


end