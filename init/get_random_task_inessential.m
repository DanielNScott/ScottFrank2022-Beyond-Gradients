function [Wh, xi, xh, xr, a] = get_random_task_inessential(Wr, P, dim_in, n_inputs, rho)

Wh = zeros(dim_in);

sigma = eye(dim_in) + rho*(ones(dim_in) - eye(dim_in));

for i = 1:n_inputs
   xi(:,i) = normalize(mvnrnd(ones(dim_in,1),sigma));
   
   %xi(:,i) = normalize(randn(dim_in,1));
   
   %a(:,i)  = normalize(P{i}*randn(dim_in,1));
   a(:,i)  = normalize(P{i}*randn(dim_in,1));

   Wh = Wh + a(:,i)*xi(:,i)';
end

for i = 1:n_inputs
   xh(:,i) = Wh*xi(:,i);
   xr(:,i) = Wr{i}*Wh*xi(:,i);
end

end