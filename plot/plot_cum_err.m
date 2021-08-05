function [] = plot_cum_err(ps, tsk, hist)

   figure();
   
   subplot(1,3,1)
   plot(cumsum(sum(hist.g.err,1)));
   hold on;
   plot(cumsum(sum(hist.d.err,1)))
   grid on
   
   
   subplot(1,3,2)
   err_g = cumsum(sum(hist.g.err,1));
   err_d = cumsum(sum(hist.d.err,1));
   
   err_f = (err_g - err_d)./err_g;
   plot(err_f)
   grid on
   
   
   subplot(1,3,3)
   % Depth aggregation
   for depth = 1:(ps.depth+1)
      dinds{depth} = find(tsk.tuples(:,1) == depth); 
   end
   
   for i = 1:(ps.depth+1)
      err_g = cumsum(sum(hist.g.err(dinds{i}, :),1));
      err_d = cumsum(sum(hist.d.err(dinds{i}, :),1));

      err_f = (err_g - err_d)./err_g;
      
      plot(err_f); hold on
   end
   grid on
   title('Relative Total Error by Depth')
   xlabel('Trial Number')
   ylabel('Fractional Improvement')
   legend({'Depth 1', 'Depth 2', '...'})
   
   set(gcf, 'Position', [95         524        1773         437])
   
end