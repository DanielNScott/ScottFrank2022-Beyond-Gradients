function [dW, phi_r, l_h, l_i] = get_dW_acc_io(Wr, W, in, trg, Th, Ti, Sh, Si, ps)

% Initialize grad accumulation
dW = zeros(ps.dim_hid, ps.dim_in);

% Variance of the output noise
% phi_var = trace(Wr'*Wr*Sh*ps.lsd*ps.lsd);

% Average hidden and output responses
hid_bar = W*in;
out_bar = Wr*hid_bar;
   
% Average target output error
delta_r = trg - out_bar;

% 

% Accumulation loop
for subtrial = 1:ps.g_acc_n
   
   l_h   = zeros(ps.dim_hid,1);
   l_i   = zeros(ps.dim_in ,1);
   %phi_r = zeros(ps.dim_hid,1);
   
   for i = 1:ps.comp
      % Noise terms
      gwn = randn(ps.dim_hid,1);

      % Hidden layer noise
      l_h = l_h + Th{i}*gwn*ps.lsd;

      % Input noise
      l_i = l_i + Ti{i}*(gwn.^2 - 1)*ps.lsd;
   end
   
   % Output noise
   phi_r = Wr*l_h;
      
   % Quadratic error
   rpe = 2*delta_r'*phi_r; % - phi_r'*phi_r + phi_var;

   % Gradient accumulation
   dW = dW + rpe*l_h*l_i';
end

% Normalize (we have ignored factor of 2 in the analytic calculations)
dW = ps.lr* 1/2 *dW /ps.g_acc_n /(ps.lsd^2);

end