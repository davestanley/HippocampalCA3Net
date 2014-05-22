
function s = betas_dave(s,opt_strct)

use_wvlets = 1;

if nargin > 1
    if isfield (opt_strct, 'use_wvlets'); use_wvlets = opt_strct.use_wvlets; end
    
end


if use_wvlets
    plotting = 0;               %Turn on/off plotting
    display_power = 1;          %Turn on/off plotting power spect subplot
    display_wavelets = 0;       %Turn on/off displaying wavelet info
    clean_memory = 0;
    clean_filtered = 0;
    len = length (s.data);

    %Check if the work has already been done!
    if isfield (s,'betas.b') == 1
        already_calculated = 1;
    else
        already_calculated = 0;
    end
    already_calculated = 0        %Hard coding to force recalculation of values
                                  %Essential for debugging!

    if ~already_calculated
        numcoefs = round(log2(len)) - 2;    %default fudge factor = 4
        s.wvstruct = dwt_dave (s.datafilt, numcoefs, display_wavelets * plotting);


        s.betas.b = zeros(2, numcoefs);         %beta array: first row is the scale index (j)
        s.betas.b(1,:) = 2.^(1:numcoefs);            %the second row is the actual coefficient
        s.betas.b(1,1) = -1;                    %first is undefinied


        for i = 1:numcoefs
            s.betas.power.val(i) = davePower(s.wvstruct.dwt(i).coefs);  % Should not use variance since it subtracts the mean - we want that left in there
            s.betas.power.scale(i) = 2^i;
            s.betas.power.freq(i) = 1/(2^i * s.dt1);
        end


        for i = 2:numcoefs
            coefs2 = s.wvstruct.dwt(i).coefs;
            coefs1 = s.wvstruct.dwt(i-1).coefs;
            s.betas.b(2,i) = log2(davePower(coefs2)) - log2(davePower(coefs1));
        %     s.betas.b(2,i) = log2(var(coefs2)) - log2(var(coefs1));
        %     mean(coefs2)
        %     mean(coefs1)
        %     std(coefs1)
        %     std(coefs2) 
        end
    end

    if plotting == 1
        betas_plot (s, display_power)
    end
    
    
    if clean_memory == 1
        s = rmfield(s, 'data');
        s = rmfield(s, 'datatimes');
        s = rmfield(s, 'datafilt');    
        s = rmfield(s, 'datafilt2');
        s = rmfield(s, 'nfft');
    end

    if clean_filtered == 1
       s = rmfield(s, 'datafilt');
       s = rmfield(s, 'datafilt2');
    end
end

end


