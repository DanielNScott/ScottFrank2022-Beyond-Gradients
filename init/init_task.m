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
   
   % Frames for input and hidden reps
   A = getRandomFrame(ps.n_inputs);
   B = getRandomFrame(ps.n_inputs);
   
   % Save them for debugging algorithm
   tsk.A = A;
   tsk.B = B;
    
   % Template non-orthogonal basis vector
   in  = normalize([ones(ps.comp,1); zeros(ps.n_inputs - ps.comp,1)]);
   
   I = eye(ps.n_inputs);
   
   % 
   for i = 1:ps.n_inputs
         
      % Generate inputs and targets
      tsk.ins{i ,1} = A*circshift(in, i-1);
      tsk.trgs{i,1} = B*circshift(in, i-1);

      % Readout weights
      tsk.Wr_list{i} = I;
      
      % 
      tsk.n_per_task(i) = 1;
      
      for j = 1:ps.comp
         
         % Column for the present feature vec
         cnum = mod(i+j-2,10)+1;

         % Random permutation of other features to link
         rpi = randperm(ps.n_inputs);
         rpi = rpi(rpi ~= cnum);
         
         rpo = randperm(ps.n_inputs);
         rpo = rpo(rpo ~= cnum);
         
         links_in  = [cnum, rpi(1:(ps.link-1))];
         links_out = [cnum, rpo(1:(ps.link-1))];
         
         rem_in  = setdiff(1:ps.n_inputs, links_in);
         rem_out = setdiff(1:ps.n_inputs, links_in);

         % Other columns, to project out
         aux_in  = A*I(:,rem_in );
         aux_out = B*I(:,rem_out);

         % Input projectors
         tsk.P_list{i,j} = I - aux_in  *aux_in';
         
         % Output projectors
         tsk.Q_list{i,j} = I - aux_out *aux_out';
      end
      % Can verify that e.g.
      %    e1 = A'*tsk.P_list{1,2}*tsk.ins{1}
      %    e2 = A'*tsk.P_list{1,2}*tsk.ins{2}
      
   end
   
   tsk.n_tasks = ps.n_inputs;

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