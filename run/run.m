function [hist, tsk] = run(ps)

% Initialize the task data
tsk = init_task(ps);

% Learn the task with a gradient, sequentially
rule = 'gd';
hist.g = run_trials(ps, tsk, rule);

% Learn the task with noise-projected gradients
rule = 'ff';
hist.d = run_trials(ps, tsk, rule);

% Plots
%if ps.plot
%   plot_all(ps, tsk, hist);
%end

end