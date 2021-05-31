function x = bin2dec32(s)
    % bin2dec32:
    % MATLAB function that converts an 32 bit single precision float to
    % its decimal value
    % (c) Robert Moir 2018

    % ensure input in correct format
    assert(strlength(s) == 32,'Input must be an 32 bit string')
    for i=1:32
        if (~(contains(s(i:i),'0') || contains(s(i:i),'1')))
            error('Input string is not a binary string')
        end
    end

    x = 2; % initialize the output to two (leading bit of mantissa)
    sign = 1; % initialize sign of output to 1 (positive)
    
    % compute the sign
    ch = s(1:1);
    if (ch == '1')
        sign = -1;
    end
        
    % compute the exponent
    e = bin2int8(s(2:9));
    % need to fix this to check for 0
    if (e == -127)
        x = sign*0;        % incorrect behaviour for nonzero mantissa
        return
    elseif (e == 128)
        x = sign*Inf; % incorrect behaviour for nonzero mantissa
        return
    end
        
    % compute the result from the mantissa   
    x = x^e;
    m = s(10:32);
    for i=1:23
        ch = m(i:i);
        if (ch == '1')
            x = x + 2^(e-i);
        end
    end
    x = x*sign;
end
