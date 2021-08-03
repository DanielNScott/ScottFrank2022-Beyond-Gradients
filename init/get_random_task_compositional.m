function [ins, trgs] = get_random_task_compositional(WrList, dim_in)

input_set = eye(dim_in); 
k = 0; 

for j = 1:length(WrList)
   for i = 1:dim_in
      
      k = k+1;
      l = mod(k-1, dim_in)+1;
      
      ins{j,i}  = input_set(:,l);
      trgs{j,i} = WrList{j}*ins{j,i};
   end
end


end