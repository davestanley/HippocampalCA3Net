
function [f X] = dave_bin_FFT (t_input, x_input, bin_duration)
% Bin duration, t_input in equivalent units (preferrably seconds for FFT output to
% make sense)

tstep = t_input(2)-t_input(1);

length_t = length(t_input);
length_bin = round(bin_duration/tstep);

if (length_bin > length_t)
    'FFT bin duration is longer than dataset. Decreasing bin size'
	length_bin = length_t;
    
end

nbins = floor(length_t/length_bin)

X = zeros(1,length_bin);
for i=1:nbins
    t_bin = (0:(length_bin-1))*tstep;
    x_bin = x_input( ((i-1)*(length_bin) + 1):(i*length_bin) );
    x_bin = x_bin - mean(x_bin);
    
    [f_bin X_bin] = daveFFT (t_bin, x_bin, 1);
    X = X + X_bin;
end

X = X / nbins;  % Return the average power spectrum
f = f_bin;

end