function [sigma, sigma_sqrt] = getRandomSPD(ndims, scale, offs)
% ndims - number of dims in matrix
% scale - scale (linear) for random eigenvalue variation
% offs  - offset for random eigenvalues

% Uniform (over the sphere) random frame
f = getRandomFrame(ndims);

% Eigenvalues, to become variances along principal dims
evs = abs(offs + randn(ndims,1)*scale);

% SPD matrix and its (matrix) square root.
sigma      = f*     diag(evs) *f';
sigma_sqrt = f*sqrt(diag(evs))*f';

end