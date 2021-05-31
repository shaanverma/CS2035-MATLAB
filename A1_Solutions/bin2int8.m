function out = bin2int8(s)
    % bin82int:
    % MATLAB function that converts an 8 bit integer encoded in binary to
    % a decimal integer x in the range -127 <= x <= 128
    % (c) Robert Moir 2018

    % ensure input in correct format
    assert(strlength(s) == 8,'Input must be an 8 bit string') 
    for i=1:8
        if (~(contains(s(i:i),'0') || contains(s(i:i),'1')))
            error('Input string is not a binary string')
        end
    end

    out = 0; % initialize the output to zero
    for (i=1:1:8)
        ch = s(i:i);
        if (ch == '1')
            out = out + 2^(8-i);
        end
    end
    out = out - 127;
end
