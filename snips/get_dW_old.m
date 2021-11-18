function dW = get_dW(rule, ps, Wr, delta_r, in, hid, out, iter, tsk, task_num)

   % Gradient, i.e. Widrow-Hoff
   if strcmp(rule, 'gd')
      dW = ps.lr * Wr' * delta_r * in';
   end

   % Feed-forward noise
   if strcmp(rule, 'ff')
      if iter > ps.n_per_epoch * tsk.n_inputs
         
         y_tilde_g = (Wr'*delta_r);
         
         y_tilde_d = delta_r'*out * hid;
         
         if ~all(y_tilde_d == 0)
            y_tilde_d = y_tilde_d* sum(abs(y_tilde_g))/sum(abs(y_tilde_d));

         end
            %y_tilde = y_tilde_d.*y_tilde_g;
            %y_tilde = y_tilde*sum(y_tilde_g)/sum(y_tilde_d);
            
         if ~all(y_tilde_d == 0)
            y_tilde_d = y_tilde_d.*hid;
            y_tilde_d = y_tilde_d* sum(abs(y_tilde_g))/sum(abs(y_tilde_d));
         end

         y_tilde = y_tilde_d*ps.p_grade + y_tilde_g*(1-ps.p_grade);

      else
         y_tilde = (Wr'*delta_r);
      end
      dW = ps.lr* y_tilde *in';
   end

   % Projection based
   if strcmp(rule, 'project')

      % Gradient filter
      y_tilde_g = (Wr'*delta_r);

      % Rotation onto kernel intersection
      y_norm  = norm(y_tilde_g);
      
      y_tilde_d = tsk.Q_list{task_num}*y_tilde_g;

      y_tilde = ps.p_grade*y_tilde_d + (1-ps.p_grade)*y_tilde_g;
      y_tilde = normalize(y_tilde)* y_norm;

      dW = ps.lr*y_tilde*in';
   end
   
   % Pre-defined input and output filters
   if strcmp(rule, 'iofilts')

      dW = zeros(ps.dim_hid, ps.dim_in);

      y_raw      = Wr'*delta_r;
      y_tilde_g  = normalize(y_raw);
      mu_tilde_g = normalize(in);      
      
      for j = 1:ps.comp
         % Output filters
         y_tilde_d = normalize( tsk.Q_list{task_num,j}*y_raw);
         %y_tilde_d = tsk.Q_list{task_num,j}*y_raw;

         % Input filters
         mu_tilde_d = normalize(tsk.P_list{task_num,j}*in);
         %mu_tilde_d = tsk.P_list{task_num,j}*in;

         % Weight update
         dW = dW + y_tilde_d*mu_tilde_d' * norm(y_raw)* norm(in);
      end
      
      % Notes:
      %
      % Normalization for projection algorithm is on rank one updates.
      % Hence the max norm and L2 norm coincide. Here, we want to do the most
      % conservative thing, so we set the L2 norm to the same L2 norm as the
      % gradient update.
      
      ntype = 2;
      %ntype = 'fro';
      
      dWg = y_raw*mu_tilde_g';
      
      dW = dW *norm(dWg, ntype)/norm(dW, ntype);
      
      dW = ps.p_grade* dW + (1-ps.p_grade)* dWg;
      dW = ps.lr* dW;
         
   end
   
%    if strcmp(rule, 'adapt')
%       y_tilde = (Wr'*delta_r);
%       %dW = ps.lr* y_tilde *in';
%       
%       y_tilde_n = y_tilde./norm(y_tilde);
%       
%       dW = ps.lr* sigma * y_tilde_n;
%       
%       dsigma = y_tilde_n*y_tilde_n';
%    end
   
   %sigma = alpha*sigma + (1-alpha)*dsigma;

end


