function [] = plot_err_by_links(err_accum_d, err_accum_g)

data = mean(err_accum_d,1)./mean(err_accum_g,1);

% Linking number performance plot
figure()
plot(data(:,1),'-o', 'LineWidth', 2)
hold on
plot(data(:,8),'-o', 'LineWidth', 2)
grid on
title('Performance by Linking Number')
ylabel('Improvement')
xlabel('Linking Number')
legend('C = 2', 'C = 8')

end