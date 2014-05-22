
function s = zero_cross_gamfit (s)

format compact;
dt = s.datatimes(2) - s.datatimes(1);


s.datafilt_nobase = remove_baseline_avg (s.datatimes, s.data, 30);

s.datafilt_lowpass = s.datafilt_nobase; s.datatimes_lowpass = s.datatimes;
% s.datafilt_lowpass = qif (s.datatimes, s.datafilt_nobase, [150 5000]); s.datatimes_lowpass = s.datatimes;
% [s.datatimes_lowpass s.datafilt_lowpass] = lowpass_avg (s.datatimes, s.datafilt_nobase, 300);

% s.data_diff = diff(s.datafilt_lowpass);
% s.datatimes_diff = s.datatimes (1:length(s.data)-1);

figure;
num = 1:length(s.data);
plot (num, s.data - mean(s.data), 'b'); hold on;
plot (wkeep(num, length(s.datafilt_nobase), 'c'), s.datafilt_nobase, 'g:');
plot (wkeep(num, length(s.datafilt_lowpass), 'c'), s.datafilt_lowpass - mean(s.datafilt_lowpass), 'r');
plot (num, zeros(1, length(num)), 'k');



a = [];
for thresh = 1
    thresh
    ints = down_up_ints (s.datatimes_lowpass, s.datafilt_lowpass, thresh);
%     ints = down_up_ints (s.datatimes_diff, s.data_diff, thresh);

    % % Histogram
    % IQR = iqr(ints);
    % len = length(ints);
    % spacing = 2*IQR*len^(-1/3);   % Estimate the appropriate number of bins
    % nbins = ceil ((max(ints) - min(ints))/spacing); % using Freedman-Draconis ruls
    % [nhist binloc] = hist(ints, nbins);
    
%     ints = gamrnd ( 2.647, 0.00018, 122613, 1);

    ints = gamrnd(2,0.01,1,10000);
%     ints = ints(find(ints>0.02));

    binloc = min(ints):dt:max(ints);
    [nhist binloc] = hist(ints, binloc);
    numberofbins = length (nhist)
    [coefs3] = gamfit (ints);

    figure; plot (binloc, nhist/sum(nhist));
    hold on;
    temp = sum (gampdf (binloc, coefs3(1), coefs3(2)));
    h2 = plot (binloc, gampdf (binloc, coefs3(1), coefs3(2))/temp, 'r');
    legend (h2, ['a=' num2str(coefs3(1)) ' b=' num2str(coefs3(2))]);
%     figure; plot (ints)
    
    a = [a coefs3(1)];
    

end

s.alpha = coefs3(1);
s.ints = ints;

% figure; plot(a);

end


function data_nobase = remove_baseline_avg (datatimes, data, filt_freq)
    % Set constants
    filt_time = 1/filt_freq;
    dt = datatimes(2) - datatimes(1);
    len = length (data);
    
    % Design filter
    filt_size = round(filt_time / dt);
    filt_size = round(filt_size/2)*2 + 1;   %Make filter size an odd number
    filt = ones(1, filt_size) / filt_size;
    
    % Pad dataset
    to_pad = (filt_size - 1)/2;
    l_padded_value = mean(data(1:to_pad));
    r_padded_value = mean(data((len-to_pad+1):len));
    data_padded = [(l_padded_value*ones(1,to_pad)) data' (r_padded_value*ones(1,to_pad))]';
    
    baseline = conv (data_padded, filt);
    baseline = wkeep (baseline, len, 'c');
    data_nobase = data - baseline;
    
%     figure; plot (datatimes(1:length(data)), data - mean(data), 'b'); hold on;
%     plot (datatimes(1:length(data)), baseline - mean(data), 'r');
%     plot (datatimes(1:length(data)), data_nobase, ':g');
    

end

function [times lowpass] = lowpass_avg (datatimes, data, filt_freq)

    % Set constants
    filt_time = 1/filt_freq;
    dt = datatimes(2) - datatimes(1);
    len = length (data);
    
    % Design filter
    filt_size = round(filt_time / dt);
    filt = ones(1, filt_size) / filt_size;
    
    % Apply filter
    fout = conv (data, filt);
    lkeep = len - filt_size;
    lowpass = wkeep (fout, lkeep, 'c');
    times = (0:lkeep-1)*dt;

end


function ints = crossing_intervals (t, x, thresh)

    x = x - thresh;
    dt = t(2) - t(1);
    N = length(x);
    
    x_sign = ( x >= 0 ) - ( x < 0 );
    zc_list = (x_sign(1:N-1) - x_sign(2:N));
    zc_indices = find (zc_list ~= 0);
    ints = diff (zc_indices);
    ints = ints * dt;

end

function ints = down_up_ints (t, x, thresh)

    x = x - thresh;
    dt = t(2) - t(1);
    N = length(x);
    
    x_sign = ( x >= 0 ) - ( x < 0 );
    zc_list = (x_sign(1:N-1) - x_sign(2:N));
    downup_indicies = find (zc_list == -2);
    ints = diff (downup_indicies);
    ints = ints * dt;

end
