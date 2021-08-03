function a_perp = reject(a, b)
% Compute the rejection of a from b, i.e. the component of a orthogonal to b.

b_unit = b./norm(b);
a_perp = a - a'*b_unit * b_unit; 

end