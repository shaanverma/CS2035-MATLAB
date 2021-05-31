m = 1000;
n = 1e3;
x = rand(m,n);
runs = 10;

tic
avg1(x);
elapsed = toc;
fprintf('avg1 on %dx%d array: %f s\n',m,n,mean(elapsed));

tic
avg2(x);
elapsed = toc;

fprintf('avg2 on %dx%d array: %f s\n',m,n,mean(elapsed));

tic
avg3(x);
elapsed = toc;

fprintf('avg3 on %dx%d array: %f s\n',m,n,mean(elapsed));

tic
mean(x);
elapsed = toc;

fprintf('mean on %dx%d array: %f s\n',m,n,mean(elapsed));