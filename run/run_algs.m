function [hist, tsk] = run_algs(ps)

% Initialize the task data
tsk = init_task(ps);

% Initialize data storage
hist.g = init_hist(ps, tsk);
hist.d = init_hist(ps, tsk);

% Learn the task with a gradient, sequentially
rule = 'gd';
hist.g = run_trials(ps, tsk, hist.g, rule);

% Learn the task with noise-projected gradients
hist.d = run_trials(ps, tsk, hist.d, ps.rule);

% Comparison w/ oracles for identical tasks
if ~ps.g_oracle && ps.g_both
   
   % Turn oracle on
   ps.g_oracle = 1;
   
   % Initialize data storage
   hist.go = init_hist(ps, tsk);
   hist.do = init_hist(ps, tsk);

   % Learn the task with a gradient, sequentially
   rule = 'gd';
   hist.go = run_trials(ps, tsk, hist.go, rule);

   % Learn the task with noise-projected gradients
   hist.do = run_trials(ps, tsk, hist.do, ps.rule);
end

end