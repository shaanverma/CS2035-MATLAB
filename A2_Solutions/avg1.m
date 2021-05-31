function avg = avg1(x)

if size(x,1) == 1
    x = x.';
end
[m,n] = size(x);

for i=1:n
    avg(i) = 0;
    for j=1:m
        avg(i) = avg(i)+x(j,i);
    end
    avg(i) = avg(i)/m;
end
end