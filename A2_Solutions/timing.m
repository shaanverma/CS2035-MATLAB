m = 1000;
pow = 4;
points = pow+1;
n = logspace(0,pow,points);
runs = 40;
T = zeros(4,points);

for k=1:length(n)
    x = rand(m,n(k));
    for i=1:runs
        tic
        stderr1(x);
        elapsed(i) = toc;
    end
    T(1,k) = mean(elapsed);
    fprintf('stderr1 on %dx%d array: %f s\n',m,n(k),mean(elapsed));
    for i=1:runs
        tic
        stderr2(x);
        elapsed(i) = toc;
    end
    T(2,k) = mean(elapsed);
    fprintf('stderr2 on %dx%d array: %f s\n',m,n(k),mean(elapsed));
    for i=1:runs
        tic
        stderr3(x);
        elapsed(i) = toc;
    end
    T(3,k) = mean(elapsed);
    fprintf('stderr3 on %dx%d array: %f s\n',m,n(k),mean(elapsed));
    for i=1:runs
        tic
        std(x);
        elapsed(i) = toc;
    end
    T(4,k) = mean(elapsed);
    fprintf('std     on %dx%d array: %f s\n',m,n(k),mean(elapsed));
end

loglog(n,T)
legend('Variable Array Loops','JITC','Vectorized','MATLAB')
title('Runtime Comparison for Standard Error Algorithms')
xlabel('Number of Size 1000x1 Input Columns')
ylabel('runtime')
print 'stdevTiming.png' -dpng