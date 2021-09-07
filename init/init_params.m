function params = init_params(sim)

% ---- Aux. params ----
% Turns plotting on and off IN THE PARAMETER LOOP.
params.plot = 0;

if sim == 1
   % ---- Simulation params ----
   params.dim_in   = 10;
   params.dim_hid  = 10;
   params.dim_out  = 10;
   params.n_inputs = 8;

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

   % Gradients and by-task-errors are computationally
   % expensive to save.
   params.save_grads    = 0;
   params.save_all_errs = 1;

elseif sim == 2
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

   % Gradients and by-task-errors are computationally
   % expensive to save.
   params.save_grads    = 1;
   params.save_all_errs = 1;
   
elseif sim == 3
      % ---- Simulation params ----
   params.dim_in   = 7;
   params.dim_hid  = 4;
   params.dim_out  = 2;
   params.n_inputs = 18;

   params.p_grade  = 1.0;

   params.n_per_epoch = 250;
   params.n_epochs = 5;

   params.lr  = 0.001;

   params.rho = 0.5;

   params.w0_diag = 0;
   params.w0_std  = 0.0;
   params.w0_snr  = 0.0;

   % Options: basic, compositional, or feats
   % These are simulations 1, 2, and 3 in the manuscript.
   params.task = 'feats';

   % Gradients and by-task-errors are computationally
   % expensive to save.
   params.save_grads    = 1;
   params.save_all_errs = 1;
end
   
end
