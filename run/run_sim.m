function [params, tsk, hist] = run_sim(sim)

% Close existing figures
close all

% Parameters for simulation 1
params = init_params(sim);

% Run network simulations for sim. 1
[hist, tsk] = run_algs(params);

% Plot things
plot_all(params, tsk, hist);

end