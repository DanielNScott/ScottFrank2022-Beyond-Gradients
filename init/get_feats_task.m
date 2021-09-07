function [ins, targs] = get_feats_task()

A = unique(perms([1,1,0,0]), 'rows')';
B = unique(perms([1,1,0])  , 'rows')';

ncolsA = size(A,2);
ncolsB = size(B,2);

k = 1;
for i = 1:ncolsA
   for j = 1:ncolsB
      % Inputs are the same for both tasks
      inputs(:,k) = [A(:,i); B(:,j)];

      % Populate targets for task 1
      targets_t1(:,k) = A(3:4, i);

      % Populate targets for task 1
      targets_t2(:,k) = B(1:2, j);
      k = k + 1;
   end
end

for k = 1:size(inputs,2)
   ins{1,k} = inputs(:,k);
   ins{2,k} = inputs(:,k);

   targs{1,k} = targets_t1(:,k);
   targs{2,k} = targets_t2(:,k);
end

end