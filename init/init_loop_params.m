function lp = init_loop_params()

%% Dimension and input number sweep

% dim_min = 3;
% dim_max = 10;
% 
% lp.p1_min = dim_min;
% lp.p1_max = dim_max;
% lp.p1_inc = 1;
% lp.p1_name = {'dim_in', 'dim_hid'};
% lp.p1_desc = 'dim';
% 
% lp.p2_min  = 2;
% lp.p2_max  = 'p1';
% lp.p2_inc  = 1;
% lp.p2_name = {'n_inputs'};
% lp.p2_desc = 'n_inputs';
% 
% lp.p1_do_addnl = 'lp.p2_len = length(lp.p1_min:lp.p1_inc:p1);';
% lp.p2_do_addnl = '';
% lp.n_iters = 100;


%% Learning rate and epoch trial count
% 
% min_count = 50;
% max_count = 500;
% inc_count = 50;
% 
% lp.p1_min = min_count;
% lp.p1_max = max_count;
% lp.p1_inc = inc_count;
% lp.p1_name = {'n_per_epoch'};
% lp.p1_desc = 'n_per_epoch';
% 
% lp.p1_do_addnl = '';
% 
% lp.p2_min  = 0.0002;
% lp.p2_max  = 0.002;
% lp.p2_inc  = 0.0002;
% lp.p2_name = {'lr'};
% lp.p2_desc = 'lr';
% 
% lp.p2_do_addnl = 'params.n_epochs = ceil(250*4/p1 *0.001/p2)';
% 
% lp.n_iters = 100;


%% Correlation value only
% lp.p1_min = 250;
% lp.p1_max = 250;
% lp.p1_inc = 1;
% lp.p1_name = {'n_per_epoch'};
% lp.p1_desc = 'n_per_epoch';
%  
% lp.p1_do_addnl = '';
%  
% lp.p2_min  = 0.0;
% lp.p2_max  = 1.0;
% lp.p2_inc  = 0.05;
% lp.p2_name = {'rho'};
% lp.p2_desc = 'rho';
%  
% lp.p2_do_addnl = '';
% 
% lp.n_iters = 100;


%% No changes in params
% lp.p1_min = 250;
% lp.p1_max = 250;
% lp.p1_inc = 1;
% lp.p1_name = {'n_per_epoch'};
% lp.p1_desc = 'n_per_epoch';
%  
% lp.p1_do_addnl = '';
%  
% lp.p2_min  = 1.0;
% lp.p2_max  = 1.0;
% lp.p2_inc  = 0.05;
% lp.p2_name = {'rho'};
% lp.p2_desc = 'rho';
%  
% lp.p2_do_addnl = '';
% 
% lp.n_iters = 100;

%% Starting SNR vs S
lp.p1_min = 0.0;
lp.p1_max = 0.1;
lp.p1_inc = 0.1;
lp.p1_name = {'w0_diag'};
lp.p1_desc = 'w0_diag';
 
lp.p1_do_addnl = '';
 
lp.p2_min  = 0.0;
lp.p2_max  = 0.1;
lp.p2_inc  = 0.1;
lp.p2_name = {'w0_std'};
lp.p2_desc = 'w0_std';
 
lp.p2_do_addnl = '';

lp.n_iters = 2;

%% Derived loop parameters
lp.p1_list = lp.p1_min:lp.p1_inc:lp.p1_max;
lp.p1_len  = length(lp.p1_list);

% In some cases p2 should depend on p1
if strcmp(lp.p2_max, 'p1')
   lp.p2_list = lp.p2_min:lp.p2_inc:lp.p1_max;
else
   lp.p2_list = lp.p2_min:lp.p2_inc:lp.p2_max;
end
lp.p2_len  = length(lp.p2_list);


end