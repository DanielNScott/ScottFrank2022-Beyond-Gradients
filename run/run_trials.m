function hist = run_trials(ps, tsk, hist, rule)

% Initialize weights
W = tsk.W0;

% Local vars for tracking how many times stims have been seen
last_seen = zeros(tsk.n_tuples, 10);
counter   = zeros(tsk.n_tuples, 1);

% Local pre allocations
hist.gs = NaN(ps.dim_out, tsk.n_tuples, tsk.n_trials);

% Amortized set differences for task indexing 
%for input_num = 1:n_ios
%   set_diff_prealloc(input_num,:) = setdiff(1:n_ios, input_num);
%end

% Init most-recent-error data
err = zeros(size(hist.err,1),1);

% Adaptive noise covariance matrix (for some algs)
sigma  = eye(ps.dim_hid);

% Stimulus presentation loop
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
      [err, gs] = get_errs(err, tsk, W, ps.save_grads, iter);
      hist.err(:,iter)  = err;
      %hist.gs(:,:,iter) = gs;
      
      % Store the last 10 times the network has seen this item
      item_lin_ind = (task-1)*tsk.n_inputs + item;
      last_seen(item_lin_ind, :) = [last_seen(item_lin_ind, 2:end), iter];
      counter(item_lin_ind) = counter(item_lin_ind) +1;
      
      if strcmp(ps.task, 'ff')
         if counter(item_lin_ind) > 10
            delta = diff(hist.err(item_lin_ind, last_seen(item_lin_ind,[10,1])));
         else
            delta = 1;
         end
      else
         delta = 1;
      end
      
      % Get weight change
      if ~strcmp(rule, 'gd') && delta > 0.05
         [dW, sigma] = get_dW(rule, ps, Wr, delta_r, in, hid, out, iter, sigma, tsk, task);
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

function [err, gs] = get_errs(err, tsk, W, save_grads, iter)

   gs = [];
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
         gs(:,i) = y_g;
      end
   end

end


function [dW, sigma] = get_dW(rule, ps, Wr, delta_r, in, hid, out, iter, sigma, tsk, task_num)

   alpha = 0.999;

   % Gradient, i.e. Widrow-Hoff
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

         y_tilde = y_tilde_d*ps.p_grade + y_tilde_g*(1-ps.p_grade);

      else
         y_tilde = (Wr'*delta_r);
      end
      dW = ps.lr* y_tilde *in';
   end

   % Projection based
   if strcmp(rule, 'project')

      % Gradient filter
      y_tilde_g = (Wr'*delta_r);

      % Rotation onto kernel intersection
      y_norm  = norm(y_tilde_g);
      
      y_tilde_d = tsk.P_list{task_num}*y_tilde_g;

      y_tilde = ps.p_grade*y_tilde_d + (1-ps.p_grade)*y_tilde_g;
      y_tilde = normalize(y_tilde)* y_norm;

      dW = ps.lr*y_tilde*in';
   end
   
   % Pre-defined input and output filters
   if strcmp(rule, 'iofilts')

      % Output filters
      y_tilde_g = normalize( Wr'*delta_r );
      y_tilde_d = normalize( tsk.Q_list{task_num}*y_tilde_g);
      
      % Input filters
      mu_tilde_g = normalize(in);      
      mu_tilde_d = normalize(tsk.P_list{task_num}*in);
      
      % Weight update
      dW = ps.lr* (ps.p_grade* y_tilde_d*mu_tilde_d' + (1-ps.p_grade)* y_tilde_g*mu_tilde_g');
      
   end
   
   if strcmp(rule, 'adapt')
      y_tilde = (Wr'*delta_r);
      %dW = ps.lr* y_tilde *in';
      
      y_tilde_n = y_tilde./norm(y_tilde);
      
      dW = ps.lr* sigma * y_tilde_n;
      
      dsigma = y_tilde_n*y_tilde_n';
   end
   
   %sigma = alpha*sigma + (1-alpha)*dsigma;

end