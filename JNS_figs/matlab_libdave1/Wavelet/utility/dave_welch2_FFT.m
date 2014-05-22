
function [f X] = dave_welch2_FFT (t_input, x_input, bin_duration)
% Bin duration, t_input in equivalent units (preferrably seconds for FFT output to
% make sense)



    tstep = t_input(2)-t_input(1);
    window = round (bin_duration/tstep);
    
%     [X f] = pwelch (x_input, window, 0, [],1/tstep,'twosided');
    [X f] = pwelch (x_input, window, [], [],1/tstep,'twosided');


    X = X.^(1/2);


end