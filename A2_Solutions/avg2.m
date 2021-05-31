function avg = avg2(x)

if size(x,1) == 1
    x = x.';
end
[m,n] = size(x);
avg = zeros(1,n);
i=0; j=0;
for i=1:n
    for j=1:m
        avg(i) = avg(i)+x(j,i);
    end
    avg(i) = avg(i)/m;
end
end