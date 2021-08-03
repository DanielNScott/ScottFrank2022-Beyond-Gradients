function [] = check_readouts()

b = [];
for i = 1:100
   a = Ker{2}*randn(3,1);
   a = a./norm(a);
   b = [b; a'];
end
scatter3(b(:,1), b(:,2), b(:,3))
hold on

a = Ker{1}*randn(3,1);
a = a./norm(a);
quiver3(0,0,0, a(1), a(2), a(3), 'k')
a = Ker{2}*a;
quiver3(0,0,0, a(1), a(2), a(3), 'm')

end