

function powerarr (s, binsize, colour)

    if nargin == 1
        binsize = 5.0; colour = 'b';
    elseif nargin == 2
        colour = 'b';
    end
    
    if binsize < 0
        fprintf ('Invalid bin size');
    end


    [f pow] = dave_bin_FFT(s(:,1), s(:,2), binsize);   % Taken from Steinmitz/Koch
    pow = abs(pow).^2;
    
    len = round(length(f));
    
    loglog (f(1:len), pow(1:len), colour)
    
    
    
end