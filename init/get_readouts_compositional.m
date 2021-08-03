function [WrList, PList] = get_readouts_compositional(depth)


strides = flip(2.^(0:depth));

for i = 1:(depth+1)
   stride = strides(i);
   nrows  = 2^depth / strides(i);
   WrList{i} = zeros(nrows, 2^depth);
   
   template = [ones(1, stride), zeros(1, 2^depth - stride)];
   
   for j = 1:nrows
      WrList{i}(j,:) = circshift(template, (j-1)*stride);
   end
end

PList = {};

end