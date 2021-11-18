function [] = plot_acc_err(dWag, dW)

figure()

subplot(2,2,1)
plot(dWag(:), dW(:),'o')
grid on
%axis square
axis equal

xs = xlim();
ys = ylim();

lo = min(xs(1),ys(1));
hi = max(xs(2),ys(2));

xlim([lo, hi]);
ylim([lo, hi]);

hold on; 
plot([lo,hi], [lo,hi], '--k')

xlabel('Accumulated')
ylabel('Analytic')
title('Sampled Update Fidelity')
legend({'Weights', 'Equality'}, 'Location', 'NorthWest')


subplot(2,2,2)

diff = dWag(:)-dW(:);

plot(dW(:), diff(:), 'o');
grid on

ylim(xlim());
title('Errors')
xlabel('True Value')
ylabel('Estimation Error')




% Get eigenvalues, eigenvecs
[v,d]     = eig(dW);
[vag,dag] = eig(dWag);

% Get evals, real parts
d   = diag(real(d  ));
dag = diag(real(dag));

% Make all eigenvalues positive
d(d<0)     = -d(d<0);
dag(dag<0) = -dag(dag<0);

% Sort
[d  , inds  ] = sort(d  , 'descend');
[dag, indsag] = sort(dag, 'descend');

% Re-index eigenvecs
v   = v(  :, inds  );
vag = vag(:, indsag);

% Try to align vecs
if sign(vag(1,1)) ~= 1
   vag(:,1) = -vag(:,1);
end
   
if sign(v(1,1)) ~= 1
   v(:,1) = -v(:,1);
end

% Plot stuff
subplot(2,2,3)
plot(d  , '-o'); hold on
plot(dag, '-o')
grid on
title('Eigenvalues')
legend({'True', 'Estimated'})

subplot(2,2,4)
plot(real(v(:,1))  , '-o'); hold on
plot(real(vag(:,1)), '-o')
grid on
title('Principal Eigenvectors')
legend({'True', 'Estimated'})

set(gcf, 'Position', [100   144   766   734])

end