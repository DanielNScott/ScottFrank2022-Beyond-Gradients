% Weight Trajectory Comparison
figure()
plot(mean(accum_w_diag_g(:,:,9),1), 'LineWidth', 2)
hold on
plot(mean(accum_w_diag_d(:,:,9),1), 'LineWidth', 2)
plot(mean(accum_w_off_g(:,:,9) ,1) , 'LineWidth', 2)
plot(mean(accum_w_off_d(:,:,9) ,1) , 'LineWidth', 2)
grid on
legend({'G, diag', 'D, diag', 'G, off', 'D, off'})
title('Weight Trajectory Comparison')
xlabel('Trial Number')
ylabel('Weight Sum')
%xlim([0,18000])