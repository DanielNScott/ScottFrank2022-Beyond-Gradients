function lp = init_loop_params(loop_code)

lp.aggregate_depth = 0;

switch(loop_code)
      case(-1)
      % No changes in params, test (10 iters)
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
      
      lp.n_iters = 30;
   
   case(0)
      % No changes in params (1000 iters)
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
      % (Number of Inputs) x (Network Dimension)
      dim_min = 3;
      dim_max = 14;
      
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
      
      lp.p1_do_addnl = 'lp.p2_len = length(lp.p2_min:lp.p1_inc:p1);';
      lp.p2_do_addnl = '';
      lp.n_iters = 1000;


   case(2)
      % (Learning Rate) x (Epoch Trial Count)
      
      min_count = 5;
      max_count = 40;
      inc_count = 5;
      
      lp.p1_min = min_count;
      lp.p1_max = max_count;
      lp.p1_inc = inc_count;
      lp.p1_name = {'n_per_epoch'};
      lp.p1_desc = 'n_per_epoch';
      
      lp.p1_do_addnl = '';
      
      lp.p2_min  = 0.004;
      lp.p2_max  = 0.02;
      lp.p2_inc  = 0.002;
      lp.p2_name = {'lr'};
      lp.p2_desc = 'lr';
      
      lp.p2_do_addnl = 'ps.n_epochs = 30;';
      
      lp.n_iters = 200;


   case(3)
      % (Correlation Value)
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
      % (Signal) x (Noise)
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
      lp.p2_inc  = 0.1;
      lp.p2_name = {'p_grade'};
      lp.p2_desc = 'Mixing Parameter';

      lp.p2_do_addnl = '';

      lp.n_iters = 5;


   case(6)
      % Weight improvement by depth
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
      
   case(8)
      % Link number by overlap
      lp.p1_min = 1;
      lp.p1_max = 10;
      lp.p1_inc = 1;
      lp.p1_name = {'link'};
      lp.p1_desc = 'link';
       
      lp.p1_do_addnl = '';
       
      lp.p2_min  = 2;
      lp.p2_max  = 9;
      lp.p2_inc  = 7;
      lp.p2_name = {'comp'};
      lp.p2_desc = 'comp';
       
      lp.p2_do_addnl = '';
      
      lp.n_iters = 200;
      
      
   case(9)
      % (Noise)
      lp.p1_min = 0.0;
      lp.p1_max = 0.3;
      lp.p1_inc = 0.3;
      lp.p1_name = {'w0_diag'};
      lp.p1_desc = 'Signal';

      lp.p1_do_addnl = '';

      lp.p2_min  = 0.0;
      lp.p2_max  = 0.3;
      lp.p2_inc  = 0.3;
      lp.p2_name = {'w0_std'};
      lp.p2_desc = 'Noise';

      lp.p2_do_addnl = '';

      lp.n_iters = 500;
      
      
   case(10)
      % (Limited projection parameter)
      lp.p1_min = 0.1;
      lp.p1_max = 0.1;
      lp.p1_inc = 0.1;
      lp.p1_name = {'w0_std'};
      lp.p1_desc = 'Noise';

      lp.p1_do_addnl = '';

      lp.p2_min  = 0.0;
      lp.p2_max  = 0.95;
      lp.p2_inc  = 0.05;
      lp.p2_name = {'p_grade'};
      lp.p2_desc = 'Anisotropy';

      lp.p2_do_addnl = '';

      lp.n_iters = 500;
      
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