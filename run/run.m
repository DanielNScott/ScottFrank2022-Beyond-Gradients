function [err_g, err_d, hist_g, hist_d] = run(params)

%% Script settings
dim_in   = params.dim_in;
dim_hid  = params.dim_hid;
dim_out  = params.dim_out;
n_inputs = params.n_inputs;
rho      = params.rho;

p_grade  = params.p_grade;

n_per_epoch = params.n_per_epoch;
n_epochs = params.n_epochs;

lr  = params.lr;

%% Task setup
io_dims  = [dim_in, dim_out];

% Get readout weights with appropriate kernel overlap
% [WrList, ~, ~, PList] = getReadoutsInessential([0,n_inputs,0], dim_in);

% Get random task using these readouts
% [WhStar, ins, xh, trgs, as] = getRandomTaskInessential(WrList, PList, dim_in, n_inputs, rho);

depth = 2;
[WrList, PList] = getReadoutsCompositional(depth);

n_tasks = depth + 1;
n_per_task = dim_in;

[ins, trgs] = getRandomTaskCompositional(WrList, dim_in);

n_inputs = size(ins,2);

% Initialize weights and gradient censoring matrix
%W0    = zeros(dim_hid, dim_in);
W0    = eye(dim_hid)*params.w0s + randn(dim_hid, dim_in)* params.w0n;
%W0    = randn(dim_hid, dim_in)*params.w0std;
c_mat = ones(dim_hid, dim_in);

%input_list = ones(n_per_epoch,1)*(repmat(1:n_inputs, [1,n_epochs]));
%input_list = input_list(:);

%nTrials = length(input_list);

k = 0;
tuples = [];
for i = 1:n_tasks
   for j = 1:n_per_task
      k = k+1; 
      tuples(k,:) = [i,j];
   end
end

n_tuples   = size(tuples,1);
stim_order = repmat(n_tuples:-1:1, 1, n_epochs)';

perm = randperm(length(stim_order(5:end)));
perm = [1:4, 4+perm];
stim_order = stim_order(perm);

%% Learn the task with a gradient, sequentially
rule = 'gd';
[grads_g, W_g, hist_g, err_g] = run_trials(ins, trgs, W0, tuples, stim_order, n_epochs, n_per_epoch, lr, rule, WrList, PList, p_grade);

%% Learn the task with noise-projected gradients
% Reset W
rule = 'ff';
[grads_d, W_d, hist_d, err_d] = run_trials(ins, trgs, W0, tuples, stim_order, n_epochs, n_per_epoch, lr, rule, WrList, PList, p_grade);


%% Plots
if params.plot
   plot_all;
end

end