function [W_diag_g, W_diag_d, W_off_g, W_off_d] = get_wgt_summaries(hist_d, hist_g, tsk, params)

% Compute differences between the weights under the different algorithms

W_diag_g  = zeros(tsk.n_trials,1,1);
W_diag_d  = zeros(tsk.n_trials,1,1);

W_off_g = zeros(tsk.n_trials,1,1);
W_off_d = zeros(tsk.n_trials,1,1);

if params.task == 'feats'
   % In this case we need to change bases
   % There's probably a way to do this with broadcasting, but w/e.
   for i = 1:tsk.n_trials
      w_g = tsk.B'*squeeze(hist_g.W(i,:,:))*tsk.A;
      w_d = tsk.B'*squeeze(hist_d.W(i,:,:))*tsk.A;

      W_diag_g(i) = sum(diag(w_g));
      W_diag_d(i) = sum(diag(w_d));

      W_off_g(i) = sum(sum(w_g)) - W_diag_g(i);
      W_off_d(i) = sum(sum(w_d)) - W_diag_d(i);
   end
else
   % We can do things faster if no basis change is needed.
   for i = 1:4
      for j = 1:4
         if i == j
            W_diag_g = W_diag_g + hist_g.W(:,i,i);
            W_diag_d = W_diag_d + hist_d.W(:,i,i);
         else
            W_off_g = W_off_g + hist_g.W(:,i,j);
            W_off_d = W_off_d + hist_d.W(:,i,j);
         end
      end
   end
end

end