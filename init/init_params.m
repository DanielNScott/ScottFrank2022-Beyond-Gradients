function params = init_params(sim)

% Turns plotting on and off IN THE PARAMETER LOOP.
params.plot = 0;

% Oracle vs adaptive
params.g_oracle = 0;      % Use oracle for gradients?
params.g_acc_n  = 2000;   % Number of accumulation steps
params.lsd      = 0.01;   % lambda standard deviation
params.g_stats  = 1;      % Compute the stats of g estimates
params.g_both   = 1;      % Rerun computations w/o oracle too.

params.s_oracle = 1;      % Use oracle for variances?

if sim == 1
   % Simulation 1 is the inessential interference demonstration
   
   % ---- Simulation params ----
   params.dim_in   = 10; % 8 for demo, 10 for loop
   params.dim_hid  = 10; % 8 for demo, 10 for loop
   params.dim_out  = 10; % 8 for demo, 10 for loop
   params.n_inputs = 8;  % 4 for demo,  8 for loop

   params.p_grade  = 0.8;

   params.n_per_epoch = 25;
   params.n_epochs    = 15; % 10 for demo, 15 for loop

   params.lr  = 0.01;

   params.rho = 0.5;

   params.w0_diag = 0;
   params.w0_std  = 0.0;
   params.w0_snr  = 0.0;

   % Options: basic, ff, or feats
   % These are simulations 1, 2, and 3 in the manuscript.
   params.task = 'basic';
   params.rule = 'project';

   % Gradients and by-task-errors are computationally
   % expensive to save.
   params.save_grads    = 0;
   params.save_all_errs = 1;

elseif sim == 2
   % Simulation 2 is the feed-forward noise demonstration
   
   % ---- Simulation params ----
   params.dim_in   = 4;
   params.dim_hid  = 4;
   params.dim_out  = 4;
   params.n_inputs = 12;

   params.p_grade  = 0.8;

   params.n_per_epoch = 25;
   params.n_epochs = 20;

   params.lr  = 0.01;

   params.rho = 0.5;

   params.w0_diag = 0.1;
   params.w0_std  = 0.1;
   params.w0_snr  = 0.0;

   % Options: basic, ff, or feats
   % These are simulations 1, 2, and 3 in the manuscript.
   params.task = 'ff';
   params.rule = 'ff';

   % Gradients and by-task-errors are computationally
   % expensive to save.
   params.save_grads    = 1;
   params.save_all_errs = 1;
   
elseif sim == 3
   % Simulation 3 is feature decomposition demonstration
   
   % ---- Simulation params ----
   params.dim_in   = 10;
   params.dim_hid  = 10;
   params.dim_out  = 10;
   params.n_inputs = 10;

   params.comp = 9;
   params.link = 10;
   
   params.p_grade  = 0.8;

   params.n_per_epoch = 25;
   params.n_epochs = 20;

   params.lr  = 0.01;

   params.rho = 0.5;

   params.w0_diag = 0;
   params.w0_std  = 0.0;
   params.w0_snr  = 0.0;

   % Options: basic, compositional, or feats
   % These are simulations 1, 2, and 3 in the manuscript.
   params.task = 'feats';
   params.rule = 'iofilts';

   % Gradients and by-task-errors are computationally
   % expensive to save.
   params.save_grads    = 0;
   params.save_all_errs = 1;
end
   
end
