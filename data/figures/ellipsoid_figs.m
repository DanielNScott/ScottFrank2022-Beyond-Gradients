function [] = ellipsoid_figs()

% [x, y, z] = ellipsoid(0,0,0,5.9,3.25,3.25,30);
% figure
% surf(x, y, z)
% axis equal

figure()

subplot(1,3,1)
plot_ellipsoid(1, 1)
title('Isotropic')

subplot(1,3,2)
plot_ellipsoid(0.5, 1)
title('Interpolating')

subplot(1,3,3)
plot_ellipsoid(0, 1)
title('Projective')


text(0.7, 0.5, 'PC1')
text(0.2, -0.75, 'PC2')

end

function [] = plot_ellipsoid(xlen, ylen)

   quiver([0,0], [0,0], [1/sqrt(2), 1/sqrt(2)], [1/sqrt(2), -1/sqrt(2)], 'LineWidth', 2)

   hold on

   incr = pi/180;
   angles = 0:incr:(2*pi);

   x = 0.6* cos(angles)* xlen;
   y = 0.6* sin(angles)* ylen;

   M = [cos(-pi/4), -sin(-pi/4); sin(-pi/4), cos(-pi/4)];
   pts = [x;y]'*M';
   plot(pts(:,1),pts(:,2), 'LineWidth', 2)
   
   axis equal
   xlim([-1,1])
   ylim([-1,1])

   grid on

   text(0.7, 0.5, 'PC1')
   text(0.2, -0.75, 'PC2')
   legend({'PCs', 'Covariance'}, 'Location', 'NorthWest')

end