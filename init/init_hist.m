function hist = init_hist(ps, tsk)

% Initialize storage if we're saving all the errors
if ps.save_all_errs
   hist.err = zeros(tsk.n_tuples, tsk.n_trials);
else
   hist.err = zeros(1, tsk.n_trials);
end

% Initialize storage if we're saving all the gradients
if ps.save_grads
   % Max cache efficiency: outermost loop over data is rightmost index.
   hist.grads = zeros(ps.dim_hid, ps.dim_in, tsk.n_tuples, tsk.n_trials);
end

if ps.g_stats && ~ps.g_oracle
   hist.corrs = zeros(tsk.n_trials, 1);
   hist.mags  = zeros(tsk.n_trials, 1);
end

% 
hist.W = zeros(tsk.n_trials, ps.dim_hid, ps.dim_in);

end