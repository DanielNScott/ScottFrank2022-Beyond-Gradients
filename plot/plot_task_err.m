function [] = plot_task_err(tsk, hist)

   figure()
   subplot(1,2,1)
   for i = 1:tsk.n_tuples
      plot(hist.g.err(i,:), 'LineWidth', 2); hold on
   end
   ylims = ylim();
   ylims(1) = 0;
   grid on

   title('Gradient Algorithm')
   xlabel('Trial Number')
   ylabel('Squared Error')
   legend({'Task 1', 'Task 2', '...'})

   subplot(1,2,2)
   for i = 1:tsk.n_tuples
      plot(hist.d.err(i,:), 'LineWidth', 2); hold on
   end
   grid on
   ylim(ylims);

   title('Projection Algorithm')
   xlabel('Trial Number')
   ylabel('Squared Error')
   legend({'Task 1', 'Task 2', '...'})
   
   set(gcf,'Position', [100         476        1009         417])

end