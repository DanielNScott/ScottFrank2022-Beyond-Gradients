function M = get_int_micro(nTrials, n_inputs, dim_in, grads)
% Get microscopic interference matrices for each time point


b = permute(grads(:,:,:,:),[1,3,4,2]);
c = reshape(b,[nTrials, dim_in^2, n_inputs]);

for t = 1:nTrials
   M(t,:,:) = corr(squeeze(c(t,:,:)));
end

end