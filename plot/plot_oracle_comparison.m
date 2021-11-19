figure()

%csum = cumsum(sorted);
%plot(csum./csum(end))

subplot(1,2,1)

ferr = (err_accum_g(:,end) - err_accum_go(:,end)) ./err_accum_g(:,end);
histogram(ferr, 'BinEdges', -0.03:0.002:0.03, 'Normalization', 'probability')
title('Sampling Error: g')
xlabel('Fraction of Oracle')
ylabel('Probability')
grid on

mu = mean(ferr);
se = 10*std(jackknife(@mean, ferr));

mstr = ['mean = ', num2str(mu*100), '%'];
sstr = ['se = '  , num2str(se*100), '%'];
text(-0.025, 0.1 ,{mstr, sstr})


subplot(1,2,2)

ferr = (err_accum_d(:,end) - err_accum_do(:,end)) ./err_accum_d(:,end);
histogram(ferr, 'BinEdges', -0.03:0.002:0.03, 'Normalization', 'probability')
title('Sampling Error: d')
xlabel('Fraction of Oracle')
ylabel('Probability')
grid on

mu = mean(ferr);
se = 10*std(jackknife(@mean, ferr));

mstr = ['mean = ', num2str(mu*100), '%'];
sstr = ['se = '  , num2str(se*100), '%'];
text(-0.025, 0.1 ,{mstr, sstr})

set(gcf,'Position', [100, 477, 1224, 467])