function [] = plot_loop_heatmap(err_means_g, err_means_d, lp)

figure()
data = (err_means_g - err_means_d)./err_means_g;

imAlpha = ones(size(data));
imAlpha(isnan(data)) = 0;
imagesc(data, 'AlphaData', imAlpha);
%set(gca,'color',0*[1 1 1]);

title('Impact of Dimension')
ylabel('Network Dimension')
xlabel('Num. Inputs')

xticklabels(xticks() + 1)
yticklabels(xticks() + 2)

hold on
plot(3,3,'rx','LineWidth',2)

xlabel(lp.p2_desc, 'Interpreter', 'None')
ylabel(lp.p1_desc, 'Interpreter', 'None')

xticklabels(lp.p2_list)
yticklabels(lp.p1_list)

%xticklabels();

title('Relative Performance')
cb = colorbar();
ylabel(cb,'Improvement')
set(get(cb,'YLabel'),'Rotation',270)


end