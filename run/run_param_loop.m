
% Workspace cleanup
close all;

% Which quantities do we want to accumulate?
accum_wgts = 0;
avg_things = 0;

% Define simulation parameters
ps = init_params(sim);

% We need this for the number of trials
% Otherwise, it is a dummy copy and is unused.
tsk = init_task(ps);

% Define loop parameters
lp = init_loop_params(loop_code);

% Initialize error data arrays
err_means_g = zeros(lp.p1_len, lp.p2_len);
err_means_d = zeros(lp.p1_len, lp.p2_len);

err_stds_g = zeros(lp.p1_len, lp.p2_len);
err_stds_d = zeros(lp.p1_len, lp.p2_len);

err_accum_g = zeros(lp.n_iters, tsk.n_trials, lp.p2_len, lp.p1_len);
err_accum_d = zeros(lp.n_iters, tsk.n_trials, lp.p2_len, lp.p1_len);

% for dim = dim_min:dim_max
for p1_ind = 1:lp.p1_len
   p1 = lp.p1_list(p1_ind);
   
   % Set params dictated by p1
   for i = 1:length(lp.p1_name)
      ps.(lp.p1_name{i}) = p1;
   end
   
   % ps.dim_in  = p1;
   % ps.dim_hid = p1;
   eval(lp.p1_do_addnl);

   for p2_ind = 1:lp.p2_len
      p2 = lp.p2_list(p2_ind);

      % Set params dictated by p2
      for i = 1:length(lp.p2_name)
         ps.(lp.p2_name{i}) = p2;
      end
      
      % params.n_inputs = n_inputs;
      eval(lp.p2_do_addnl);
      
      for iter = 1:lp.n_iters
         
         % Inform the user about loop state
         clc
         disp(['(', lp.p1_desc, ', ' lp.p2_desc, ', iter): (', num2str(p1), ',', num2str(p2), ',' num2str(iter), ')'])
         
         % Run the simulations
         [hist, tsk] = run_algs(ps);
         
         % Process the weight histories
         [W_diag_g, W_diag_d, W_off_g, W_off_d] = get_wgt_summaries(hist.d, hist.g);
         
         
         if strcmp(ps.task,'ff') && lp.aggregate_depth
            % Depth aggregation of errors
            for depth = 1:(tsk.depth+1)
               dinds{depth} = find(tsk.tuples(:,1) == depth);

               err_accum_depth_d(depth,iter,:) = cumsum(sum(hist.d.err(dinds{depth},:),1)); 
               err_accum_depth_g(depth,iter,:) = cumsum(sum(hist.g.err(dinds{depth},:),1));
            end
         end

         % Update loop accumulators
         err_accum_d(iter, :, p2_ind, p1_ind) = cumsum(sum(hist.d.err,1)); 
         err_accum_g(iter, :, p2_ind, p1_ind) = cumsum(sum(hist.g.err,1));

         if accum_wgts
            accum_w_diag_g(iter, :, p2_ind, p1_ind) = W_diag_g;
            accum_w_diag_d(iter, :, p2_ind, p1_ind) = W_diag_d;

            accum_w_off_g(iter, :, p2_ind, p1_ind) = W_off_g;
            accum_w_off_d(iter, :, p2_ind, p1_ind) = W_off_d;
         end

         % Angles
         %for i = 1:tsk.n_trials
         %   angles(iter, :, i) = get_upper(corr(hist.g.gs(:,:,i)));
         %end
         
      end % repetition loop
      
      % Time-courses of error mean and sd over repetitions
      if avg_things 
         avg_errsum_g = mean(err_accum_g,1);
         avg_errsum_d = mean(err_accum_d,1);

         std_errsum_g = std(err_accum_g, [], 1);
         std_errsum_d = std(err_accum_d, [], 1);

         % Final cumulative errors
         err_means_g(p1_ind, p2_ind) = avg_errsum_g(end);
         err_means_d(p1_ind, p2_ind) = avg_errsum_d(end);
      end
      
      % err_sds_g(p1_ind, p2_ind) = std_errsum_g(end);
      % err_sds_d(p1_ind, p2_ind) = std_errsum_d(end);

   end % inner param loop
   
end % outer param loop

if strcmp(ps.task,'ff') && lp.aggregate_depth
   avg_errsum_depth_g = squeeze(mean(err_accum_depth_g,2));
   avg_errsum_depth_d = squeeze(mean(err_accum_depth_d,2));
end
