function [] = plot_err_by_mix(err_accum_d, err_accum_g)

% Relative error improvement by mixture
figure()
cmap = cool(10);

data = mean(err_accum_d,1)./mean(err_accum_g,1);

%plot(data(:,:,1), 'k', 'LineWidth', 2)
hold on;
for i = 2:10
   plot(data(:,:,i), 'LineWidth', 2, 'Color', cmap(i,:))
   %plot(err_accum_d(i,:)./err_accum_g(i,:), 'LineWidth', 2, 'Color', cmap(i,:))
end
grid on
xlabel('Trial Number')
ylabel('Relative Error')
title('Performance by Mixture')
%legend({'P = 0.2', 'P = 0.4', 'P = 0.6', 'P = 0.8', 'P = 1.0'})
legend({'P = 0.1','P = 0.2', '....'})

end