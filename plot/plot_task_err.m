function [] = plot_task_err(tsk, hist)

   figure()
   subplot(1,2,1)
   for i = 1:tsk.n_tuples
      plot(hist.g.err(i,:)); hold on
   end
   ylims = ylim();
   grid on

   title('Gradient Based Interference Example')
   xlabel('Trial Number')
   ylabel('Squared Error')
   legend({'Task 1', 'Task 2', '...'})

   subplot(1,2,2)
   for i = 1:tsk.n_tuples
      plot(hist.d.err(i,:)); hold on
   end
   grid on
   ylim(ylims);

   title('Projection Based Interference Example')
   xlabel('Trial Number')
   ylabel('Squared Error')
   legend({'Task 1', 'Task 2', '...'})
   
   set(gcf,'Position', [100         233        1533         728])

end