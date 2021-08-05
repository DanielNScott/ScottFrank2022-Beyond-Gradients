function [] = plot_int_micro(M)

% This is for 4x4 matrices
[X,Y] = meshgrid(0.5:1:4.5, 0.5:1:4.5);


figure()
subplot(4,1,1)
for i = 500:500:4000
   surface(ones(5)*i,X,Y, 'FaceColor', 'texturemap', 'CData', squeeze(M(i,:,:)));
end
colorbar()
ylim([0.5,4.5])
zlim([0.5,4.5])
title('W_h Over Learning')
xlabel('Trial')
set(gca, 'CameraPosition', [2.7480e+03 -30.8130 11.8154])

end