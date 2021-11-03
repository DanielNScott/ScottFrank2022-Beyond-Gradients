
figure()

relerr_1 = (err_means_d(1,:) - err_means_g(1,:)) ./ err_means_g(1,:);
relerr_2 = (err_means_d(2,:) - err_means_g(2,:)) ./ err_means_g(2,:);

relerr_1_std  = (err_means_d(1,:) + err_stds_d(1,:) - err_means_g(1,:)) ./ err_means_g(1,:);
relerr_1_std_ = (err_means_d(1,:) - err_stds_d(1,:) - err_means_g(1,:)) ./ err_means_g(1,:);

relerr_2_std  = (err_means_d(2,:) + err_stds_d(2,:) - err_means_g(2,:)) ./ err_means_g(2,:);
relerr_2_std_ = (err_means_d(2,:) - err_stds_d(2,:) - err_means_g(2,:)) ./ err_means_g(2,:);


plot(lp.p2_list, relerr_1,'-o', 'LineWidth', 2); hold on
plot(lp.p2_list, relerr_2,'-o', 'LineWidth', 2)

%plot(relerr_1_std , '--k')
%plot(relerr_1_std_, '--k')

%plot(relerr_2_std , '--k')
%plot(relerr_2_std_, '--k')

xlim([lp.p2_list(1), lp.p2_list(end)])
grid on
xlabel('Noise Amplitude')
ylabel('')