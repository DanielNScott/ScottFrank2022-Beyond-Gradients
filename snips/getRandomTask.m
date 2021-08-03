function [W_star, in, out] = getRandomTask( n_inputs, io_dims, sigma_sqrt_in, sigma_sqrt_out)
% n_inputs - the number of network inputs defining the task
% io_dims  - list containing the network input width, followed by output width
% sigma    - correlation matrix for the inputs

size_in  = io_dims(1);
size_out = io_dims(2);

% Get some random input vectors
in = getRandomFrame(size_in);
in = in(:,1:n_inputs);

% Correlate them
in = in*sigma_sqrt_in;

% Get some random output vectors
out = getRandomFrame(size_out);
out = out(:,1:n_inputs);

% Correlate them
out = out*sigma_sqrt_out;

% W_star is a direct sum, with projection onto
% the row space defined by X given:
W_star_base = out*pinv(in);

% To Do: 
% Generate a random frame spanning the null-space of X'
% W_star_null = getRandomFrame(size_in);
% W_star_null = W_star_null(1:size_out,:);

W_star = W_star_base;

end

