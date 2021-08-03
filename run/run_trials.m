function [grads, W, hist, err] = run_trials(ins, trgs, W, tuples, stim_order, n_epochs, n_per_epoch, lr, rule, WrList, PList, Pgrade)


dim_in   = size(W, 2);
dim_hid  = size(W, 1);

n_tuples = size(tuples,1);
n_trials = n_tuples * n_per_epoch * n_epochs;

err   = zeros(n_trials, n_tuples);
grads = zeros(n_trials, n_tuples, dim_hid, dim_in);

hist.W = zeros(n_trials, dim_hid, dim_in);

% Saving all the gradients takes a long time
save_grads = 0;

% Pre allocations
%ys        = NaN([n_trials, n_tuples, dim_hid]);
%ys_cur    = NaN(dim_hid, n_tuples);
%grads_cur = NaN(dim_hid, dim_in);

%for input_num = 1:n_ios
%   set_diff_prealloc(input_num,:) = setdiff(1:n_ios, input_num);
%end


% 
iter = 0;
for i = stim_order'
   
   task = tuples(i, 1);
   item = tuples(i, 2);

   in  = ins{ task, item};
   trg = trgs{task, item};
      
   for trial = 1:n_per_epoch

      iter = iter+1;
      
      % Calculate the errors & grads on every io_pair
      [err, grads] = get_errs(err, iter, tuples, n_tuples, ins, trgs, W, WrList, grads);
      
      % Current readout
      Wr = WrList{task};
      
      % Hidden and output responses
      hid = W*in;
      out = Wr*hid;
      
      % Target output error
      delta_r = trg - out;
      
      % Get weight change
      
      if ~strcmp(rule, 'gd')
         dW = get_dW(rule, lr, Wr, delta_r, in, hid, out, iter, Pgrade);
      else
         dW = lr*squeeze(grads(iter,i,:,:));
      end

      % Apply update
      W = W + dW;
      
      % Save W
      hist.W(iter,:,:) = W;

   end
end

end

function [err, grads] = get_errs(err, iter, tuples, n_tuples, ins, trgs, W, WrList, grads)

   % 
   for i = 1:n_tuples

      task = tuples(i, 1);
      item = tuples(i, 2);

      in  = ins{ task, item};
      trg = trgs{task, item};
      
      hid = W*in;
      out = WrList{task}*hid;
      
      delta_r = trg - out;
      y_g = WrList{task}'*delta_r;
      
      err(iter, i) = sqrt(delta_r'*delta_r);

      grads(iter,i,:,:) = y_g*in';
   end

end


function dW = get_dW(rule, lr, Wr, delta_r, in, hid, out, iter, p_grade)

   % Gradient, i.e. Woodrow-Hoff
   if strcmp(rule, 'gd')
      y_tilde = (Wr'*delta_r);
      dW = lr* y_tilde *in';
   end

   % Feed-forward noise
   if strcmp(rule, 'ff')
      if iter > 1000
         y_tilde_g = (Wr'*delta_r);

         
         y_tilde_d = delta_r'*out * hid;
         y_tilde_d = y_tilde_d*norm(y_tilde_g,1)/norm(y_tilde_d,1);
         
         
         %y_tilde = y_tilde_d.*y_tilde_g;
         %y_tilde = y_tilde*sum(y_tilde_g)/sum(y_tilde_d);
         
         y_tilde_d = y_tilde_g.*hid;
         y_tilde_d = y_tilde_d*sum(y_tilde_g)/sum(y_tilde_d);

         y_tilde = y_tilde_d*p_grade(1) + y_tilde_g*p_grade(2);

      else
         y_tilde = (Wr'*delta_r);
      end
      dW = lr* y_tilde *in';
   end

   % Projection based
   if strcmp(rule, 'project')

      % Gradient filter
      y_tilde_grad = (Wr'*delta_r);

      net_int = sum(y_tilde_grad'*ys_cur(:,set_diff_prealloc(input_num, :)));

      if net_int < 0
         % Rotation onto kernel intersection
         y_norm  = norm(y_tilde_grad);

         y_tilde = p_grade(1)*PList{input_num}*y_tilde_grad + p_grade(2)*y_tilde_grad;
         y_tilde = y_tilde*y_norm/norm(y_tilde);
      else
         y_tilde = y_tilde_grad;
      end

      dW = lr*y_tilde*in';
   end

end