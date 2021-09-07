function [] = plot_cum_err(ps, tsk, hist)

   figure();
   
   subplot(1,3,1)
   plot(cumsum(sum(hist.g.err,1)));
   hold on;
   plot(cumsum(sum(hist.d.err,1)))
   grid on
   title('Cumulative Total Error')
   xlabel('Trial')
   ylabel('Error [a.u.]')
   
   
   subplot(1,3,2)
   err_g = cumsum(sum(hist.g.err,1));
   err_d = cumsum(sum(hist.d.err,1));
   
   err_f = err_d./err_g;
   plot(err_f)
   grid on
   title('Relative Error')
   ylabel('Trials')
   xlabel('Fraction Grad. Descent')
   
   
   if strcmp(ps.task, 'ff')
      subplot(1,3,3)
      % Depth aggregation
      for depth = 1:(tsk.depth+1)
         dinds{depth} = find(tsk.tuples(:,1) == depth); 
      end

      for i = 1:(tsk.depth+1)
         err_g = cumsum(sum(hist.g.err(dinds{i}, :),1));
         err_d = cumsum(sum(hist.d.err(dinds{i}, :),1));

         err_f = err_d./err_g;

         plot(err_f, 'LineWidth', 2); hold on
      end
      grid on
      title('Relative Total Error by Depth')
      xlabel('Trial Number')
      ylabel('Fractional Improvement')

      if tsk.depth > 0
         legend({'Depth 1', 'Depth 2', '...'})
      end
   end
   
   set(gcf, 'Position', [95         524        1773         437])
   
end