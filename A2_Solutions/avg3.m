function avg = avg3(x)

if size(x,1) == 1
    x = x.';
end
n = size(x,1);
avg = sum(x)/n;
end