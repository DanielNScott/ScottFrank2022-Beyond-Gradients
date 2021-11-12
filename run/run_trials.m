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

%
Ih = eye(ps.dim_hid);
Ii = eye(ps.dim_in);


% Stimulus presentation loop
iter = 0;
for i = tsk.stim_order'
   
   % Task meta-data
   tnum = tsk.tuples(i, 1);
   item = tsk.tuples(i, 2);

   % Task tuple
   in   = tsk.ins{ tnum, item};
   trg  = tsk.trgs{tnum, item};
   Wr   = tsk.Wrs{tnum};
   
   for trial = 1:ps.n_per_epoch

      % ---- Book keeping ---------------------------%
      iter = iter+1;
      
      % Calculate the errors & grads on every io_pair
      [err, gs] = get_errs(err, tsk, W, ps.save_grads);
      hist.err(:,iter)  = err;
      %hist.gs(:,:,iter) = gs;
      
      % Store the last 10 times the network has seen this item
      item_lin_ind = (tnum-1)*tsk.n_inputs + item;
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
      
      
      % ---- Dynamics using oracle --------%
      %
      % We calculate these for comparison even if
      % we don't actually use them for the updates.
      
      % Hidden and output responses
      hid = W*in;
      out = Wr*hid;

      % Target output error
      delta_r = trg - out;

      % Get weight change
      %if ~strcmp(rule, 'gd') && delta > 0.05
         %dW = get_dW(rule, ps, Wr, delta_r, in, hid, out, iter, tsk, tnum);
         [filts, dW] = get_filts(rule, ps, Wr, delta_r, in, hid, out, iter, tsk, tnum);

         % If we're not using an S-oracle, track gradients to project out.
         if ~ps.s_oracle && trial == 1 && iter < ps.n_per_epoch*ps.n_inputs
            yg  = filts.yg;
               
            % Overwrite the projection, coloring, & covar matrices
            for index = setdiff(1:ps.n_inputs, tnum)
               pg  = tsk.Qs{index}*yg;
               pgn = norm(pg);
               R   = (pg * pg')./(pgn^2);
            
               tsk.Qs{index} = tsk.Qs{index} - R;
               %tsk.Th{in} = eye(ps.dim_hid);
               %tsk.Sh{in} = eye(ps.dim_hid);
            end
         end
         %else
      %   dW = ps.lr *Wr' *delta_r *in';
      %end
      
      
      % ---- Dynamics using noise --------%
      if ~ps.g_oracle
         
         % Accumulate a weight update
         if strcmp('gd', rule)
            dWa = get_dW_acc(Wr, W, in, trg, Ih, Ih, ps);
            
         elseif strcmp('project', rule)
            dWa = get_dW_acc(Wr, W, in, trg, tsk.Th{tnum}, tsk.Sh{tnum}, ps);
            
         elseif strcmp(rule, 'iofilts')
            dWa = get_dW_acc_io(Wr, W, in, trg, tsk.Th(tnum,:), tsk.Ti(tnum,:), tsk.Sh(tnum,:), tsk.Si(tnum,:), ps);            
            
         end
         
         % Do separately so we can inspect
         dW  = dWa*norm(dW,2)/norm(dWa,2);
      end
      
      
      % ---- Update and save --------%
      
      % Apply update
      W = W + dW;

      % Save W
      hist.W(iter,:,:) = W;
         
   end
end

end

function [err, gs] = get_errs(err, tsk, W, save_grads)

   gs = [];
   % 
   for i = 1:tsk.n_tuples

      tnum = tsk.tuples(i, 1);
      item = tsk.tuples(i, 2);

      in  = tsk.ins{ tnum, item};
      trg = tsk.trgs{tnum, item};
      
      Wr  = tsk.Wrs{tnum};
      
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

