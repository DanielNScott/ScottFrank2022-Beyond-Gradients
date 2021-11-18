function [dW, y] = get_dW_acc(Wr, W, in, trg, Th, Sh, ps)

% Initialize grad accumulation
dW = zeros(ps.dim_hid, ps.dim_in);

% Variance of the output noise
phi_var = trace(Wr'*Wr*Sh*ps.lsd*ps.lsd);

% Average hidden and output responses
hid_bar = W*in;
out_bar = Wr*hid_bar;
   
% Average target output error
delta_r = trg - out_bar;

% Output filter to accumulate for diagnostics
y = zeros(ps.dim_hid,1);

% Accumulation loop
for subtrial = 1:ps.g_acc_n
   
   % Noise terms
   gwn = randn(ps.dim_hid,1);
      
   % Hidden layer noise
   l_h = Th*gwn*ps.lsd;
   
   % Output noise
   phi_r = Wr*l_h;

   % Quadratic error
   rpe = 2*delta_r'*phi_r - phi_r'*phi_r + phi_var;

   % Gradient accumulation
   dW = dW + rpe*l_h*in';
   
   % Accumulate the output filter specifically, for comparison
   y  = y + rpe*l_h;
end

% Normalize (we have ignored factor of 2 in the analytic calculations)
dW = ps.lr* 1/2 *dW /ps.g_acc_n /(ps.lsd^2);
y  = y/norm(y);

end