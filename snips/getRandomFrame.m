function [frame] = getRandomFrame(nDims)

frame = zeros(nDims,nDims);
for i = 1:nDims
   frame(:,i) = mvnrnd(zeros(nDims, 1), eye(nDims))';
   frame(:,i) = frame(:,i)/sqrt(frame(:,i)'*frame(:,i));
   
   for j = 1:(i-1)
      frame(:,i) = frame(:,i) - frame(:,i)'*frame(:,j)*frame(:,j);
   end
   frame(:,i) = frame(:,i)/sqrt(frame(:,i)'*frame(:,i));
end

end
