function lp = init_loop_params(loop_code)

lp.aggregate_depth = 0;

switch(loop_code)
   case(0)
      % No changes in params
      lp.p1_min = 25;
      lp.p1_max = 25;
      lp.p1_inc = 1;
      lp.p1_name = {'n_per_epoch'};
      lp.p1_desc = 'n_per_epoch';
       
      lp.p1_do_addnl = '';
       
      lp.p2_min  = 0.5;
      lp.p2_max  = 0.5;
      lp.p2_inc  = 0.05;
      lp.p2_name = {'rho'};
      lp.p2_desc = 'rho';
       
      lp.p2_do_addnl = '';
      
      lp.n_iters = 1000;

   case(1)
      % Dimension and input number sweep
      dim_min = 3;
      dim_max = 10;
      
      lp.p1_min = dim_min;
      lp.p1_max = dim_max;
      lp.p1_inc = 1;
      lp.p1_name = {'dim_in', 'dim_hid', 'dim_out'};
      lp.p1_desc = 'dim';
      
      lp.p2_min  = 2;
      lp.p2_max  = 'p1';
      lp.p2_inc  = 1;
      lp.p2_name = {'n_inputs'};
      lp.p2_desc = 'n_inputs';
      
      lp.p1_do_addnl = 'lp.p2_len = length(lp.p1_min:lp.p1_inc:p1);';
      lp.p2_do_addnl = '';
      lp.n_iters = 500;


   case(2)
      % Learning rate and epoch trial count
      
      min_count = 25;
      max_count = 250;
      inc_count = 25;
      
      lp.p1_min = min_count;
      lp.p1_max = max_count;
      lp.p1_inc = inc_count;
      lp.p1_name = {'n_per_epoch'};
      lp.p1_desc = 'n_per_epoch';
      
      lp.p1_do_addnl = '';
      
      lp.p2_min  = 0.005;
      lp.p2_max  = 0.015;
      lp.p2_inc  = 0.001;
      lp.p2_name = {'lr'};
      lp.p2_desc = 'lr';
      
      lp.p2_do_addnl = 'ps.n_epochs = 10*ceil(0.01/p2);';
      
      lp.n_iters = 10;


   case(3)
      % Correlation value only
      lp.p1_min = 25;
      lp.p1_max = 25;
      lp.p1_inc = 1;
      lp.p1_name = {'n_per_epoch'};
      lp.p1_desc = 'n_per_epoch';
       
      lp.p1_do_addnl = '';
       
      lp.p2_min  = 0.0;
      lp.p2_max  = 1.0;
      lp.p2_inc  = 0.05;
      lp.p2_name = {'rho'};
      lp.p2_desc = 'rho';
       
      lp.p2_do_addnl = '';
      
      lp.n_iters = 1000;


   case(4)
      % Starting SNR vs S
      lp.p1_min = 0.0;
      lp.p1_max = 0.3;
      lp.p1_inc = 0.05;
      lp.p1_name = {'w0_diag'};
      lp.p1_desc = 'Signal';

      lp.p1_do_addnl = '';

      lp.p2_min  = 0.0;
      lp.p2_max  = 0.3;
      lp.p2_inc  = 0.05;
      lp.p2_name = {'w0_std'};
      lp.p2_desc = 'Noise';

      lp.p2_do_addnl = '';

      lp.n_iters = 100;


   case(5)
      % Off-diagonal weights by p_grade
      lp.p1_min = 25;
      lp.p1_max = 25;
      lp.p1_inc = 1;
      lp.p1_name = {'n_per_epoch'};
      lp.p1_desc = 'Dummy-var';

      lp.p1_do_addnl = '';

      lp.p2_min  = 0.0;
      lp.p2_max  = 1.0;
      lp.p2_inc  = 0.2;
      lp.p2_name = {'p_grade'};
      lp.p2_desc = 'Mixing Parameter';

      lp.p2_do_addnl = '';

      lp.n_iters = 20;


   case(6)
      % Off-diagonal weights by p_grade
      lp.p1_min = 25;
      lp.p1_max = 25;
      lp.p1_inc = 1;
      lp.p1_name = {'n_per_epoch'};
      lp.p1_desc = 'Dummy-var';

      lp.p1_do_addnl = '';

      lp.p2_min  = 0.0;
      lp.p2_max  = 1.0;
      lp.p2_inc  = 0.2;
      lp.p2_name = {'dim_in'};
      lp.p2_desc = 'Category Depth';

      lp.p2_do_addnl = 'ps.dim_hid = p2; ps.n_inputs = p2;';

      lp.n_iters = 20;
      
      % OVERRIDE the increment settings:
      lp.p2_list = [4,8,16];

      
   case(7)
      % Projection parameter only
      lp.p1_min = 25;
      lp.p1_max = 25;
      lp.p1_inc = 1;
      lp.p1_name = {'n_per_epoch'};
      lp.p1_desc = 'n_per_epoch';
       
      lp.p1_do_addnl = '';
       
      lp.p2_min  = 0.00;
      lp.p2_max  = 1.00;
      lp.p2_inc  = 0.05;
      lp.p2_name = {'p_grade'};
      lp.p2_desc = 'p_grade';
       
      lp.p2_do_addnl = '';
      
      lp.n_iters = 1000;
end

%% Derived loop parameters
lp.p1_list = lp.p1_min:lp.p1_inc:lp.p1_max;
lp.p1_len  = length(lp.p1_list);

% In some cases we set p2_list explicitly and 
% in some cases p2 should depend on p1
if ~isfield(lp, 'p2_list')
   if strcmp(lp.p2_max, 'p1')
      lp.p2_list = lp.p2_min:lp.p2_inc:lp.p1_max;
   else
      lp.p2_list = lp.p2_min:lp.p2_inc:lp.p2_max;
   end
end
lp.p2_len  = length(lp.p2_list);


end