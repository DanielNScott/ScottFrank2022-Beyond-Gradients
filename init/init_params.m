function params = init_params(sim)

% ---- Aux. params ----
% Turns plotting on and off IN THE PARAMETER LOOP.
params.plot = 0;

if sim == 1
   % Simulation 1 is the inessential interference demonstration
   
   % ---- Simulation params ----
   params.dim_in   = 8;
   params.dim_hid  = 8;
   params.dim_out  = 8;
   params.n_inputs = 4;

   params.p_grade  = 0.8;

   params.n_per_epoch = 25;
   params.n_epochs = 10;

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
   params.dim_out  = 2;
   params.n_inputs = 18;

   params.p_grade  = 0.8;

   params.n_per_epoch = 250;
   params.n_epochs = 5;

   params.lr  = 0.001;

   params.rho = 0.5;

   params.w0_diag = 0;
   params.w0_std  = 0.0;
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
