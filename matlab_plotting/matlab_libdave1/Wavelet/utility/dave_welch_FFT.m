
function [f X] = dave_welch_FFT (t_input, x_input, bin_duration)
% Bin duration, t_input in equivalent units (preferrably seconds for FFT output to
% make sense)



    tstep = t_input(2)-t_input(1);
    window = round (bin_duration/tstep);


    Fs = 1/tstep;
    h = spectrum.welch('Hann',window,50);
    hpsd = psd(h,x_input,'NFFT',[],'Fs',Fs);
    X = (hpsd.Data).^(1/2); 
    f = hpsd.Frequencies;

    X = [X; flipud(X)];
    f = [f; (f+max(f))];


end