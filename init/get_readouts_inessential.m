function [Wr, Qr, Ker, P] = get_readouts_inessential(m, n)
% Inputs:
% m - a vector of integers of length (n-1)
% n - the ambient dimension of the space
%
% Outputs:
% Wr  - a cell with sum(m) entries, each a matrix with m(k) dim kernel, of size (n-m(k) x n)
% Ker - a cell with the kernel for each Wr encoded as the rejection matrix of Wr's row space.

nKers   = sum(m);
counter = m;
kList   = find(m);

Wr  = {};
Ker = {};

i = 1;

% Kernel number?
for k = kList
   
   % 
   for l = 1:m(k)
      
      % Weight matrix
      W = [];
      W = [W; randn(1,n)];
      
      % Matrix of normalized rows
      Q = normRows(W);
      
      % Encode kernel as projection
      % Any vector y = K*x is in Ker(W)
      K = eye(n) - Q'*Q;
      
      % Save in lists
      Wr{i}  = W;
      Qr{i}  = Q;
      Ker{i} = K;
      
      counter(k) = counter(k) - 1;
      
      i = i+1;
   end
end

% Stack all unit vec rows from all weight matrices
M = [];
for i = 1:nKers
   M = [M; Qr{i}];
end

% P will be a projection matrix
P = {};

% Iterate over weight matrices
for i = 1:nKers
   
   % Get the index of every kernel except 
   % the one associated with the current matrix
   inds = setdiff(1:nKers,i);
   
   % Get an orthogonal basis for the union of row spaces
   % associated to every weight weight matrix exccept this one
   [q, ~] = qr(M(inds,:)');
   
   % Compute the projection onto the kernel of that row space
   P{i} = eye(n) - q(:,1:(nKers-1))*q(:,1:(nKers-1))';

end

end

% Function for normalizing every row of a matrix.
function W = normRows(W)

% Loop over rows
for i = 1:size(W,1)
   
   % Divide the row by the row norm (obviously).
   W(i,:) = W(i,:)./norm(W(i,:));
end

end