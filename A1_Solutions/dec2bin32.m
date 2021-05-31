function s = dec2bin32(x)
    % dec2bin32:
    % MATLAB function that converts a decimal number to a 32 bit
    % single precision float
    % (c) Robert Moir 2018
    
    % cover special cases
    num = abs(x);
    if (num < 2^-126)
        s = '00000000000000000000000000000000';
        return
    elseif (num >= 2^128)
        if (sign(x) == 1)
            s = '01111111100000000000000000000000';
            return
        else
            s = '11111111100000000000000000000000';
            return
        end
    end
    
    s = '';
    % set the sign bit
    if (x < 0)
        s = strcat(s,'1');
    else
        s = strcat(s,'0');
    end
    
    % compute the exponent
    e = floor(log2(abs(x)));
    s = strcat(s,int2bin8(e));
    
    % remove component corresponding to 'hidden bit'
    num = mod(num,2^e);
        
    % compute the mantissa  
    for i=1:23
    rem = mod(num,2^(e-i));
    if (num == rem)
        s = strcat(s,'0');
    else
        s = strcat(s,'1');
        num = rem;
    end
end
