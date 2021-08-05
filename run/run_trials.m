function hist = run_trials(ps, tsk, rule)

%%
W = tsk.W0;

tsk.n_tuples = size(tsk.tuples,1);
tsk.n_trials = tsk.n_tuples * ps.n_per_epoch * ps.n_epochs;

if ps.save_all_errs
   err = zeros(tsk.n_tuples,1);
   hist.err = zeros(tsk.n_tuples, tsk.n_trials);
else
   err = zeros(1,1);
   hist.err = zeros(tsk.n_trials, 1);
end

% Maximum cache efficiency: outermost loop over data is rightmost index.
hist.grads = zeros(ps.dim_hid, ps.dim_in, tsk.n_tuples, tsk.n_trials);

hist.W = zeros(tsk.n_trials, ps.dim_hid, ps.dim_in);

last_seen = zeros(tsk.n_tuples, 10);
counter   = zeros(tsk.n_tuples, 1);

% Pre allocations
%ys        = NaN([tsk.n_trials, tsk.n_tuples, ps.dim_hid]);
%ys_cur    = NaN(ps.dim_hid, tsk.n_tuples);
%grads_cur = NaN(ps.dim_hid, ps.dim_in);

%for input_num = 1:n_ios
%   set_diff_prealloc(input_num,:) = setdiff(1:n_ios, input_num);
%end

% 
iter = 0;
for i = tsk.stim_order'
   
   task = tsk.tuples(i, 1);
   item = tsk.tuples(i, 2);

   in  = tsk.ins{ task, item};
   trg = tsk.trgs{task, item};
      
   for trial = 1:ps.n_per_epoch

      iter = iter+1;
      
      % Current readout
      Wr = tsk.Wr_list{task};
      
      % Hidden and output responses
      hid = W*in;
      out = Wr*hid;
      
      % Target output error
      delta_r = trg - out;
      
       % Calculate the errors & grads on every io_pair
      if ps.save_all_errs
         err = get_errs(err, tsk, W, ps.save_grads);
         hist.err(:,iter) = err;
      else
         hist.err(iter) = sqrt(delta_r'*delta_r);
      end
      
      % Store the last 10 times the network has seen this item
      item_lin_ind = (task-1)*tsk.n_inputs + item;
      last_seen(item_lin_ind, :) = [last_seen(item_lin_ind, 2:end), iter];
      counter(item_lin_ind) = counter(item_lin_ind) +1;
      
      if counter(item_lin_ind) > 10
         delta = diff(hist.err(item_lin_ind, last_seen(item_lin_ind,[10,1])));
      else
         delta = 1;
      end
      
      % Get weight change
      if ~strcmp(rule, 'gd') && delta > 0.05
         dW = get_dW(rule, ps, Wr, delta_r, in, hid, out, iter);
      else
         dW = ps.lr *Wr' *delta_r *in';
      end

      % Apply update
      W = W + dW;
      
      % Save W
      hist.W(iter,:,:) = W;

   end
end

end

function err = get_errs(err, tsk, W, save_grads)

   % 
   for i = 1:tsk.n_tuples

      task = tsk.tuples(i, 1);
      item = tsk.tuples(i, 2);

      in  = tsk.ins{ task, item};
      trg = tsk.trgs{task, item};
      
      Wr  = tsk.Wr_list{task};
      
      hid = W*in;
      out = Wr*hid;
      
      delta_r = trg - out;
      
      err(i) = sqrt(delta_r'*delta_r);

      % This is expensive and should be off if not required.
      if save_grads
         
         % Don't compute y_g unless needed
         y_g = Wr'*delta_r;
         
         % Maximum cache efficiency indexing
         % grads(:,:,i,iter) = y_g*in';
      end
   end

end


function dW = get_dW(rule, ps, Wr, delta_r, in, hid, out, iter)

   % Gradient, i.e. Woodrow-Hoff
   if strcmp(rule, 'gd')
      y_tilde = (Wr'*delta_r);
      dW = ps.lr* y_tilde *in';
   end

   % Feed-forward noise
   if strcmp(rule, 'ff')
      if iter > ps.n_per_epoch * ps.n_inputs
         
         y_tilde_g = (Wr'*delta_r);
         
         y_tilde_d = delta_r'*out * hid;
         
         if ~all(y_tilde_d == 0)
            y_tilde_d = y_tilde_d* sum(abs(y_tilde_g))/sum(abs(y_tilde_d));

         end
            %y_tilde = y_tilde_d.*y_tilde_g;
            %y_tilde = y_tilde*sum(y_tilde_g)/sum(y_tilde_d);
            
         if ~all(y_tilde_d == 0)
            y_tilde_d = y_tilde_d.*hid;
            y_tilde_d = y_tilde_d* sum(abs(y_tilde_g))/sum(abs(y_tilde_d));
         end

         y_tilde = y_tilde_d*ps.p_grade(1) + y_tilde_g*ps.p_grade(2);

      else
         y_tilde = (Wr'*delta_r);
      end
      dW = ps.lr* y_tilde *in';
   end

   % Projection based
   if strcmp(rule, 'project')

      % Gradient filter
      y_tilde_grad = (Wr'*delta_r);

      net_int = sum(y_tilde_grad'*ys_cur(:,set_diff_prealloc(input_num, :)));

      if net_int < 0
         % Rotation onto kernel intersection
         y_norm  = norm(y_tilde_grad);

         y_tilde = ps.p_grade(1)*tsk.P_list{input_num}*y_tilde_grad + ps.p_grade(2)*y_tilde_grad;
         y_tilde = y_tilde*y_norm/norm(y_tilde);
      else
         y_tilde = y_tilde_grad;
      end

      dW = ps.lr*y_tilde*in';
   end

end