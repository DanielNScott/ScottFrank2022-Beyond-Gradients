function [upper] = get_upper(mat, varargin)

   %mat = squeeze(mat);
   mat(mat == 0) = NaN;
   upper_mat = triu(mat, 1);
   upper = mat(upper_mat ~= 0);

   
   if nargin == 2
      upper(isnan(upper)) = 0;
   end
   
end