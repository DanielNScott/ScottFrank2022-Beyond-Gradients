function [filts, dW] = get_filts(rule, ps, Wr, delta_r, in, hid, out, iter, tsk, task_num)

   % Gradient, i.e. Widrow-Hoff
   yg = Wr' * delta_r;
   xg = in;
      
   yd = [];
   xd = [];
   
   x  = xg;
   y  = yg;
   
   dW = ps.lr * y * x';

   % Feed-forward noise
   if strcmp(rule, 'ff')
      if iter > ps.n_per_epoch * tsk.n_inputs
         
         yg = (Wr'*delta_r);
         
         yd = delta_r'*out * hid;
         
         if ~all(yd == 0)
            yd = yd* sum(abs(yg))/sum(abs(yd));

         end
            %y_tilde = y_tilde_d.*y_tilde_g;
            %y_tilde = y_tilde*sum(y_tilde_g)/sum(y_tilde_d);
            
         if ~all(yd == 0)
            yd = yd.*hid;
            yd = yd* sum(abs(yg))/sum(abs(yd));
         end

         y = yd*ps.p_grade + yg*(1-ps.p_grade);
         x = xg;
      else
         y = yg;
      end
      dW = ps.lr* y *x';
   end

   % Projection based
   if strcmp(rule, 'project')

      % Gradient filter
      yg = Wr'*delta_r;

      % Rotation onto kernel intersection
      yg_norm = norm(yg);
      
      yd = tsk.Qs{task_num}*yg;

      % Filter combination and norming:
      y = ps.p_grade*yd + (1-ps.p_grade)*yg;
      y = normalize(y)* yg_norm;

      x = xg;
      
      dW = ps.lr*y*x';
   end
   
   % Pre-defined input and output filters
   if strcmp(rule, 'iofilts')

      dW = zeros(ps.dim_hid, ps.dim_in);

      y_raw      = Wr'*delta_r;
      yg  = normalize(y_raw);
      mu_tilde_g = normalize(in);      
      
      for j = 1:ps.comp
         % Output filters
         yd = normalize( tsk.Qs{task_num,j}*y_raw);
         %y_tilde_d = tsk.Qs{task_num,j}*y_raw;

         % Input filters
         mu_tilde_d = normalize(tsk.Ps{task_num,j}*in);
         %mu_tilde_d = tsk.Ps{task_num,j}*in;

         % Weight update
         dW = dW + yd*mu_tilde_d' * norm(y_raw)* norm(in);
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
   
   filts.x  = x;
   filts.xg = xg;
   filts.xd = xd;

   filts.y  = y;
   filts.yd = yd;
   filts.yg = yg;

end


