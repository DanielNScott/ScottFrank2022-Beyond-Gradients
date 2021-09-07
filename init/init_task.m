function tsk = init_task(ps)

if strcmp(ps.task, 'basic')
   % Task setup
   tsk = struct();
   
   % Get readout weights with appropriate kernel overlap
   [tsk.Wr_list, ~, ~, tsk.P_list] = get_readouts_inessential([0,ps.n_inputs,0], ps.dim_in);

   % Get random task using these readouts
   [~, ins, ~, trgs, ~] = get_random_task_inessential(tsk.Wr_list, tsk.P_list, ps.dim_in, ps.n_inputs, ps.rho);
   
   tsk.n_tasks = length(tsk.Wr_list);
   
   tsk.n_per_task = ones(tsk.n_tasks, 1);
   
   for i = 1:tsk.n_tasks
      for j = 1:tsk.n_per_task
         tsk.ins{i,j}  = ins(:,i);
         tsk.trgs{i,j} = trgs(:,i);
      end
   end
   tsk.depth = 0;

elseif strcmp(ps.task, 'ff')
   % Compositional task
   tsk.depth = log2(ps.dim_in);
   [tsk.Wr_list, tsk.P_list] = get_readouts_compositional(tsk.depth);

   tsk.n_tasks = repmat(tsk.depth + 1, [tsks.n_tasks,1]);
   tsk.n_per_task = ps.dim_in;

   [tsk.ins, tsk.trgs] = get_random_task_compositional(tsk.Wr_list, ps.dim_in);

elseif strcmp(ps.task, 'feats')

   % Features task
   tsk.depth = 0;
   
   tsk.Wr_list{1} = [eye(2), zeros(2)];
   tsk.Wr_list{2} = [zeros(2), eye(2)];
   
   tsk.Q_list{1} = [eye(2)  , zeros(2); zeros(2,4)];
   tsk.Q_list{2} = [zeros(2,4); zeros(2),   eye(2)];
  
   tsk.P_list{1} = [zeros(2,7);  zeros(2), eye(2), zeros(2,3); zeros(3,7)];
   tsk.P_list{2} = [zeros(2,7);  zeros(2,7); zeros(2,4), eye(2), zeros(2,1); zeros(1,7)];
   
   tsk.n_per_task(1) = 18;
   tsk.n_per_task(2) = 18;

   [tsk.ins, tsk.trgs] = get_feats_task();
   
   tsk.n_tasks = 2;

end

% Misc task parameters
tsk.n_inputs = size(tsk.ins,2);

% Initialize weights
% tsk.W0 = eye(ps.dim_hid)*ps.w0_diag + randn(ps.dim_hid, ps.dim_in)* ps.w0_std;
tsk.W0 = zeros(ps.dim_hid, ps.dim_in);

% Task tuples define a task number and a set of stimulus numbers
% Weight readouts, inputs, and targets are indexed by (task, stim number) pair.
k = 0;
tuples = [];
for i = 1:tsk.n_tasks
   for j = 1:tsk.n_per_task(i)
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

% Number of trials in the task
tsk.n_trials = tsk.n_tuples * ps.n_per_epoch * ps.n_epochs;

end