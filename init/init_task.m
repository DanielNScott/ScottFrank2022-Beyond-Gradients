function tsk = init_task(ps)

if strcmp(ps.task, 'basic')
   % Task setup

   % Get readout weights with appropriate kernel overlap
   % [Wr_list, ~, ~, P_list] = get_readouts_innessential([0,tsk.n_inputs,0], ps.dim_in);

   % Get random task using these readouts
   % [WhStar, ins, xh, trgs, as] = get_random_task_inessential(Wr_list, P_list, ps.dim_in, tsk.n_inputs, ps.rho);

   elseif strcmp(ps.task, 'compositional')
   % Compositional task
   depth = log2(ps.dim_in);
   [tsk.Wr_list, tsk.P_list] = get_readouts_compositional(depth);

   tsk.n_tasks = depth + 1;
   tsk.n_per_task = ps.dim_in;

   [tsk.ins, tsk.trgs] = get_random_task_compositional(tsk.Wr_list, ps.dim_in);

end

% Misc task parameters
tsk.n_inputs = size(tsk.ins,2);

% Initialize weights
tsk.W0 = eye(ps.dim_hid)*ps.w0_diag + randn(ps.dim_hid, ps.dim_in)* ps.w0_std;

% Task tuples define a task number and a set of stimulus numbers
% Weight readouts, inputs, and targets are indexed by (task, stim number) pair.
k = 0;
tuples = [];
for i = 1:tsk.n_tasks
   for j = 1:tsk.n_per_task
      k = k+1; 
      tuples(k,:) = [i,j];
   end
end
tsk.tuples = tuples;

tsk.n_tuples   = size(tuples,1);
tsk.stim_order = repmat(tsk.n_tuples:-1:1, 1, ps.n_epochs)';

% Shuffle stimulus order
perm = randperm(length(tsk.stim_order((ps.dim_in+1):end)));
perm = [1:ps.dim_in, ps.dim_in+perm];
tsk.stim_order = tsk.stim_order(perm);

end