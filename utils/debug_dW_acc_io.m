
niter = 200;

w     = zeros(10,10,niter);
phi_r = zeros(10,niter);
l_h   = zeros(10,niter);
l_i   = zeros(10,niter);

for i = 1:niter
   [w(:,:,i), phi_r(:,i), l_h(:,i), l_i(:,i)] = ...
      get_dW_acc_io(Wr, W, in, trg, tsk.Th(tnum,:), tsk.Ti(tnum,:), tsk.Sh(tnum,:), tsk.Si(tnum,:), ps);
end

figure()
subplot(2,2,1)
histogram(w(1 ,1 ,:)); hold on;
histogram(w(1 ,10,:));
histogram(w(10,1 ,:));
histogram(w(10,10,:));

subplot(2,2,2)
histogram(phi_r(1 ,:)); hold on;
histogram(phi_r(10,:));
title('\phi_r')

subplot(2,2,3)
histogram(l_h(1 ,:)); hold on;
histogram(l_h(10,:));
title('l_h')

subplot(2,2,4)
histogram(l_i(1 ,:)); hold on;
histogram(l_i(10,:));
title('l_i')
