function params = init_params()

   % ---- Simulation params ----
   params.dim_in   = 8;
   params.dim_hid  = 8;
   params.dim_out  = 1;
   params.n_inputs = 8;

   params.p_grade  = [0.8, 0.2];

   params.n_per_epoch = 25;
   params.n_epochs = 20;

   params.lr  = 0.01;

   params.rho = 0.5;
   params.depth = 3;

   params.w0_diag = 0;
   params.w0_std  = 0.0;

   params.task = 'compositional';

   % ---- Aux. params ----
   params.plot = 0;

   % Gradients and by-task-errors are computationally
   % expensive to save.
   params.save_grads    = 0;
   params.save_all_errs = 1;

   % Derived parameters
   params.io_dims = [params.dim_in, params.dim_out];

end
