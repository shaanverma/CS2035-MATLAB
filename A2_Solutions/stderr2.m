function [se, xbar] = stderr2(x)

if size(x,1) == 1
    x = x.';
end
[m,n] = size(x);
xbar = mean(x);
se = zeros(1,n);
i=0; 
j=0;
for i=1:n
    se(i) = 0;
    for j=1:m
        se(i) = se(i) + (x(j,i)-xbar(i))^2;
    end
    se(i) = sqrt(se(i)/(m-1));
end
end