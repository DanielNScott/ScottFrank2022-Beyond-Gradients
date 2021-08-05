
% Workspace cleanup
clear; close all;

% Define simulation parameters
params = init_params();

% Make sure plotting is off. 
% This can crash some computers if not!
params.plot = 0;

% Define loop parameters
lp = init_loop_params();

% Initialize error data arrays
err_means_g = zeros(lp.p1_len, lp.p2_len);
err_means_d = zeros(lp.p1_len, lp.p2_len);

err_stds_g = zeros(lp.p1_len, lp.p2_len);
err_stds_d = zeros(lp.p1_len, lp.p2_len);

% for dim = dim_min:dim_max
for p1_ind = 1:lp.p1_len
   p1 = lp.p1_list(p1_ind);
   
   % Set params dictated by p1
   for i = 1:length(lp.p1_name)
      params.(lp.p1_name{i}) = p1;
   end
   
   % params.dim_in  = p1;
   % params.dim_hid = p1;
   eval(lp.p1_do_addnl);

   for p2_ind = 1:lp.p2_len
      p2 = lp.p2_list(p2_ind);

      % Set params dictated by p2
      for i = 1:length(lp.p2_name)
         params.(lp.p2_name{i}) = p2;
      end
      
      % params.n_inputs = n_inputs;
      eval(lp.p2_do_addnl);
      
      err_accum_g = [];
      err_accum_d = [];
      for iter = 1:lp.n_iters
         
         clc
         disp(['(', lp.p1_desc, ', ' lp.p2_desc, ', iter): (', num2str(p1), ',', num2str(p2), ',' num2str(iter), ')'])
                 
         [hist, tsk] = run(params);
         
         [W_diag_g, W_diag_d, W_off_g, W_off_d] = get_wgt_summaries(hist.d, hist.g);
         
         err_accum_d(iter,:) = cumsum(sum(hist.d.err,1)); 
         err_accum_g(iter,:) = cumsum(sum(hist.g.err,1));

         accum_w_diag_g(iter,:) = W_diag_g;
         accum_w_diag_d(iter,:) = W_diag_d;
         
         accum_w_off_g(iter,:) = W_off_g;
         accum_w_off_d(iter,:) = W_off_d;

      end
      
      avg_errsum_g = mean(err_accum_g,1);
      avg_errsum_d = mean(err_accum_d,1);
      
      std_errsum_g = std(err_accum_g, [], 1);
      std_errsum_d = std(err_accum_d, [], 1);
      
      err_means_g(p1_ind, p2_ind) = avg_errsum_g(end);
      err_means_d(p1_ind, p2_ind) = avg_errsum_d(end);
      
      err_sds_g(p1_ind, p2_ind) = std_errsum_g(end);
      err_sds_d(p1_ind, p2_ind) = std_errsum_d(end);
   end
   
end

