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

end