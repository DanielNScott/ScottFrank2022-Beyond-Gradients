function [] = plot_all(ps, tsk, hist)


   plot_task_err(tsk, hist)

   if strcmp(ps.task, 'ff')
      plot_depth_err(ps, tsk, hist)
   end

   plot_cum_err(ps, tsk, hist)

   plot_wgt_hist(tsk, hist)
   
   % Plots
   %[u0, s0, v0] = svd(W0);
   %[u,   s,  v] = svd(W);
   
   %c_trgs = zeros(dim_out,2);
   %c_trgs(noise_dims(1,:),1) = trgs(noise_dims(1,:),1);
   %c_trgs(noise_dims(2,:),2) = trgs(noise_dims(2,:),2);

   %rho_c_trgs = c_trgs'*c_trgs;

   % figure()
   % plot(diff_diag)
   % grid on
   % hold on
   % plot(diff_off)
   % title('Weight Differences \Delta W_{g} - \Delta W_{d}')
   % legend({'Diagonal weight sum', 'Off-diagonal weight sum'})
   % xlabel('Trial Number')
   % ylabel('Weight Sum')
end