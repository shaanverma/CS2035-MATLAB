%% Average computation tests
X = rand(1000,6);
y = rand(1,1000);
disp('avg1:')
avg1(X)
avg1(y)
disp('avg2:')
avg2(X)
avg2(y)
disp('avg3:')
avg3(X)
avg3(y)
disp('mean:')
mean(X)
mean(y)

%% Standard error computation tests
disp('stderr1:')
stderr1(X)
stderr1(y)
disp('stderr3:')
stderr2(X)
stderr2(y)
disp('stderr3:')
stderr3(X)
stderr3(y)
disp('std:')
std(X)
std(y)