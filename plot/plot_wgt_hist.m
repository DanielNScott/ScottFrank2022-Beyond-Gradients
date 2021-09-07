function [] = plot_wgt_hist(tsk, hist)

   figure(); 
   subplot(1,2,1); 
   hold on; 
   for i = 1:4
      for j = 1:4
         plot(squeeze(hist.g.W(:,i,j))); 
      end
   end
   grid on
   title('Weights Under GD')
   xlabel('Trial Number')
   ylabel('Weight Value')

   subplot(1,2,2); 
   hold on; 
   for i = 1:4
      for j = 1:4
         plot(squeeze(hist.d.W(:,i,j)));
      end
   end
   grid on
   title('Weights Under Projective')
   xlabel('Trial Number')
   ylabel('Weight Value')
   
   
   set(gcf, 'Position', [100         476        1009         417])
end