
function [f X] = dave_binoverlap_FFT (t_input, x_input, bin_duration)
% Bin duration, t_input in equivalent units (preferrably seconds for FFT output to
% make sense)
% Bins are 50% overlapping

use_hann = 1;       % If = 1, use hann window; otherwise, use rectangular windowing
t_input = t_input(:);
x_input = x_input(:);

tstep = t_input(2)-t_input(1);

length_t = length(t_input);
length_bin = round(bin_duration/tstep);

if (length_bin > length_t)
    fprintf('FFT bin duration is longer than dataset. Decreasing bin size \n');
	length_bin = length_t;
    
end

curr_index=1;
nbins = 0;
X = zeros(1,length_bin);
while (curr_index+length_bin-1 <= length(x_input))
    x_bin = x_input((curr_index):(curr_index+length_bin-1));
    x_bin = x_bin - mean(x_bin);
    t_bin = (0:(length_bin-1))*tstep;

    
    if use_hann == 1
        x_bin = x_bin .* hann(length(x_bin));
%         w = hann(length(x_bin));
%         figure; plot(x_bin);
%         hold on; plot(w,'r');
%         plot(x_bin.*w,'g')
    end
    [f_bin X_bin] = daveFFT (t_bin, x_bin, 1);
    curr_index = curr_index + round(length_bin/2);
    nbins = nbins + 1;
    X_bin = abs(X_bin).^2;
    X = X + X_bin;
end

X = X / nbins;  % Return the average power spectrum
X = X.^(1/2);
f = f_bin;
nbins;

end