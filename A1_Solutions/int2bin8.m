function out = int2bin8(num)
	% int2bin8:
	% MATLAB function that converts an integer x with -127 <= x <= 128
	% into an encoding as an 8 bit binary string
	% (c) Robert Moir 2018

    % ensure input in correct range
    assert(-127 <= num <= 128,...
        'Input must be an integer between -127 and 128 inclusive') 

    out = ''; % set out to be the empty string
    num = num + 127; % input shifted by 
    for (i=7:-1:0)
        rem = mod(num,2^i);
        if (num == rem)
            out = strcat(out,'0');
        else
            out = strcat(out,'1');
            num = rem;
        end
    end
end
