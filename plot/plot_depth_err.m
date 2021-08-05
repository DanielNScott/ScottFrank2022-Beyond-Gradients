function [] = plot_depth_err(ps, tsk, hist)

   % Depth aggregation
   for depth = 1:(ps.depth+1)
      dinds{depth} = find(tsk.tuples(:,1) == depth); 
   end
   
   subplot(1,2,1)
   for i = 1:(ps.depth+1)
      plot(mean(hist.g.err(dinds{i},:))); hold on
   end
   ylims = ylim();
   grid on

   title('Gradient Based Interference Example')
   xlabel('Trial Number')
   ylabel('Squared Error')
   legend({'Task 1', 'Task 2', '...'})

   subplot(1,2,2)
   for i = 1:(ps.depth+1)
      plot(mean(hist.d.err(dinds{i},:))); hold on
   end
   grid on
   ylim(ylims);

   title('Projection Based Interference Example')
   xlabel('Trial Number')
   ylabel('Squared Error')
   legend({'Task 1', 'Task 2', '...'})
   
   set(gcf,'Position', [100         233        1533         728])

end
