function [W_diag_g, W_diag_d, W_off_g, W_off_d] = get_wgt_summaries(hist_d, hist_g)

% Compute differences between the weights under the different algorithms
diff = hist_d.W - hist_g.W;

W_diag_g  = zeros(length(diff),1,1);
W_diag_d  = zeros(length(diff),1,1);
for i = 1:4
   W_diag_g = W_diag_g + hist_g.W(:,i,i);
   W_diag_d = W_diag_d + hist_d.W(:,i,i);
end

W_off_g = zeros(length(diff),1,1);
W_off_d = zeros(length(diff),1,1);
for i = 1:4
   for j = 1:4
      if i ~= j
         W_off_g = W_off_g + hist_g.W(:,i,j);
         W_off_d = W_off_d + hist_d.W(:,i,j);
      end
   end
end

end