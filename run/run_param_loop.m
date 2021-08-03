
% Workspace cleanup
clear; close all;

% Define parameters
init_params;

% Make sure plotting is off. 
% This can crash some computers if not!
params.plot = 0;

%% Params

% Dimension and input number sweep
%
% dim_min = 3;
% dim_max = 10;
% 
% p1_min = dim_min;
% p1_max = dim_max;
% p1_inc = 1;
% p1_name = {'dim_in', 'dim_hid'};
% p1_desc = 'dim';
% 
% p2_min  = 2;
% p2_max  = 'p1';
% p2_inc  = 1;
% p2_name = {'n_inputs'};
% p2_desc = 'n_inputs';
%
% p1_do_addnl = '';
% n_iters = 100;


%% Learning rate and epoch trial count
% 
% min_count = 50;
% max_count = 500;
% inc_count = 50;
% 
% p1_min = min_count;
% p1_max = max_count;
% p1_inc = inc_count;
% p1_name = {'n_per_epoch'};
% p1_desc = 'n_per_epoch';
% 
% p1_do_addnl = '';
% 
% p2_min  = 0.0002;
% p2_max  = 0.002;
% p2_inc  = 0.0002;
% p2_name = {'lr'};
% p2_desc = 'lr';
% 
% p2_do_addnl = 'params.n_epochs = ceil(250*4/p1 *0.001/p2)';
% 
% n_iters = 100;


%% Correlation value only
% p1_min = 250;
% p1_max = 250;
% p1_inc = 1;
% p1_name = {'n_per_epoch'};
% p1_desc = 'n_per_epoch';
%  
% p1_do_addnl = '';
%  
% p2_min  = 0.0;
% p2_max  = 1.0;
% p2_inc  = 0.05;
% p2_name = {'rho'};
% p2_desc = 'rho';
%  
% p2_do_addnl = '';
% 
% n_iters = 100;


%% No chnages in params
% p1_min = 250;
% p1_max = 250;
% p1_inc = 1;
% p1_name = {'n_per_epoch'};
% p1_desc = 'n_per_epoch';
%  
% p1_do_addnl = '';
%  
% p2_min  = 1.0;
% p2_max  = 1.0;
% p2_inc  = 0.05;
% p2_name = {'rho'};
% p2_desc = 'rho';
%  
% p2_do_addnl = '';
% 
% n_iters = 100;

%% Starting SNR vs S
p1_min = 0.0;
p1_max = 0.5;
p1_inc = 0.05;
p1_name = {'w0s'};
p1_desc = 'w0s';
 
p1_do_addnl = '';
 
p2_min  = 0.0;
p2_max  = 0.5;
p2_inc  = 0.05;
p2_name = {'w0n'};
p2_desc = 'w0n';
 
p2_do_addnl = '';

n_iters = 100;


%% Initialization
p1_list = p1_min:p1_inc:p1_max;
p1_len  = length(p1_list);

% Hack, this will break when p2 depends on p1
p2_list = p2_min:p2_inc:p2_max;
p2_len  = length(p2_list);

err_means_g = zeros(p1_len, p2_len);
err_means_d = zeros(p1_len, p2_len);

err_stds_g = zeros(p1_len, p2_len);
err_stds_d = zeros(p1_len, p2_len);

% for dim = dim_min:dim_max
for p1_ind = 1:p1_len
   p1 = p1_list(p1_ind);
   
   % Set params dictated by p1
   for i = 1:length(p1_name)
      params.(p1_name{i}) = p1;
   end
   
   % params.dim_in  = p1;
   % params.dim_hid = p1;
   eval(p1_do_addnl);

   for p2_ind = 1:p2_len
      p2 = p2_list(p2_ind);

      % Set params dictated by p2
      for i = 1:length(p2_name)
         params.(p2_name{i}) = p2;
      end
      
      % params.n_inputs = n_inputs;
      eval(p2_do_addnl);
      
      err_accum_g = [];
      err_accum_d = [];
      for iter = 1:n_iters
         
         clc
         disp(['(', p1_desc, ', ' p2_desc, ', iter): (', num2str(p1), ',', num2str(p2), ',' num2str(iter), ')'])
         
         [err_g, err_d, hist_g, hist_d] = run(params);
         
         [W_diag_g, W_diag_d, W_off_g, W_off_d] = get_wgt_summaries(hist_d, hist_g);
         
         err_accum_d(iter,:) = cumsum(sum(err_d,2)); 
         err_accum_g(iter,:) = cumsum(sum(err_g,2));

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

imagesc((err_means_g - err_means_d)./err_means_g)
xlabel('Trials per Epoch')
ylabel('Learning Rate')
%xticklabels()

title('Projective Algorithm Performance')
cb = colorbar();
ylabel(cb,'\bf{Improvement Relative to Gradient Descent}')
set(get(cb,'YLabel'),'Rotation',270)

% Error improvement
% figure(); 
% plot((avg_errsum_g - avg_errsum_d) ./ avg_errsum_g)
% grid on
% title('Cumulative Error Improvement by Time')
% ylabel('Fraction of Cumulative Gradient Error')
% xlabel('Trial Number')
% xlim([0,18000])

% Weight Trajectory Comparison
% figure()
% plot(mean(accum_w_diag_g,1))
% hold on
% plot(mean(accum_w_diag_d,1))
% plot(mean(accum_w_off_g,1))
% plot(mean(accum_w_off_d,1))
% grid on
% legend({'Diag. Wgts under G', 'Diag. Wgts Under D', 'Off-Diag Wgts under G', 'Off-Diag Wgts under D'})
% title('Weight Trajectory Comparison')
% xlabel('Trial Number')
% ylabel('Weight Sum')
% xlim([0,18000])
