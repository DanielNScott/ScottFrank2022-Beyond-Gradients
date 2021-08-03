function rho = var_to_corr(sigma)

n = length(sigma);
for i = 1:n
   for j = i:n
      rho(i,j) = sigma(i,j)./sqrt( sigma(i,i)*sigma(j,j) );
      rho(j,i) = rho(i,j);
   end
end
end