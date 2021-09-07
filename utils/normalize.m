function x = normalize(x)

   if norm(x) > 0
      x = x./norm(x);
   else
      x = x;
   end
end