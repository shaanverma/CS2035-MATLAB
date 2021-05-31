function [se, xbar] = stderr3(x)

if size(x,1) == 1
    x = x.';
end
n = size(x,1);
xbar = mean(x);
se = sqrt(sum((x-xbar).^2)/(n-1));