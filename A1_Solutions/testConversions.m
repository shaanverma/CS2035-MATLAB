%% CS2035B Assignment 1: Testing Integer and Floating Point Conversions

%% Identification
% Robert Moir:
% 12345467890

%% Binary to Integer to Binary Conversions
format compact

s = ['11111111'; '10101010'; '10000000'; '00000000'];
for i=1:size(s,1)
    disp(['Testing: ' s(i,:)])
    val = int2bin8(bin2int8(s(i,:)))
    if (strcmp(s(i,:),val))
        disp('Pass')
    else
        disp('Fail')
    end
end

%% Integer to Binary to Integer Conversions
x = [28, -72, 128, -127];
for i=1:length(x)
    disp(['Testing: ' num2str(x(i))])
    val = bin2int8(int2bin8(x(i)))
    if (x(i) == val)
        disp('Pass')
    else
        disp('Fail')
    end
end

%% Decimal to Float to Decimal Conversions
% In this case, I have implemented special tests to test "corner cases",
% i.e., cases that are not the main case the algorithm deals with. The
% special tests are followed by a generic test for generic input.
zero = '00000000000000000000000000000000';
posinf = '01111111100000000000000000000000';
neginf = '11111111100000000000000000000000';
s = ['01111111110000000000000000000000';
     '11111111110000000000000000000000';
     '00000000010101010101010101010101';
     '10000000110000000000000000000000'];
s(end+1,:) = dec2bin32(Inf);
s(end+1,:) = dec2bin32(10*pi);
s(end+1,:) = dec2bin32(10*pi+0.000002);
% Testing on number larger than Inf, should output Inf:
disp(['Testing: ' s(1,:)])
val = dec2bin32(bin2dec32(s(1,:)));
if (strcmp(val,posinf))
    disp('Pass')
else
    disp('Fail')
end
% Testing on number smaller than -Inf, should output -Inf:
disp(['Testing: ' s(2,:)])
val = dec2bin32(bin2dec32(s(2,:)));
if (strcmp(val,neginf))
    disp('Pass')
else
    disp('Fail')
end
% Testing a subnormal number, should output 0:
disp(['Testing: ' s(3,:)])
val = dec2bin32(bin2dec32(s(3,:)));
if (strcmp(val,zero))
    disp('Pass')
else
    disp('Fail')
end
% Generic test
for i=4:size(s,1)
    disp(['Testing: ' s(i,:)])
    val = dec2bin32(bin2dec32(s(i,:)))
    if (strcmp(s(i,:),val))
        disp('Pass')
    else
        disp('Fail')
    end
end

%% Float to Decimal to Float Conversions
% In this case I have allowed the corner cases to produce failed tests and
% then explained why the result we obtain is expected in a comment at the
% end.
format long
x = [2^128, 2^127, 2^-127, 2^-126, 10*pi, 31.415927, 31.415928];
% Convert input to single precision numbers
single(x)
for i=1:length(x)
    disp(['Testing: ' num2str(x(i))])
    val = single(bin2dec32(dec2bin32(x(i))))
    if (single(x(i)) == single(val))
        disp('Pass')
    else
        disp('Fail')
    end
end

% Comment on two failed tests:
% We expect 2^-127=5.8775e-39 to fail because this is a subnormal number,
% which is set to zero by our algorithm, so the output behaviour is
% correct
% We also expect 31.415927 to fail because the closest single precision
% number is larger, but our algorithm does not implement correct rounding,
% instead it rounds the number down to the next smallest single precision
% number. Hence the single precision number we return is smaller than the
% correct representation of 31.415927 in single precision.
% In contrast, 31.415928 is larger than the nearest single precision
% number, so we get this one right because our algorithm rounds down, which
% is correct in this case.