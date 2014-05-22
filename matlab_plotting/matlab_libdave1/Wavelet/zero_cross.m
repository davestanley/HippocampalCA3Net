
function s = zero_cross (s)

format compact;
dt = s.datatimes(2) - s.datatimes(1);


s.datafilt_nobase = remove_baseline_avg (s.datatimes, s.datafilt, 30);

s.datafilt_lowpass = s.datafilt_nobase; s.datatimes_lowpass = s.datatimes;
% s.datafilt_lowpass = qif (s.datatimes, s.datafilt_nobase, [150 5000]); s.datatimes_lowpass = s.datatimes;
[s.datatimes_lowpass s.datafilt_lowpass] = lowpass_avg (s.datatimes, s.datafilt_nobase, 150);

% s.data_diff = diff(s.datafilt_lowpass);
% s.datatimes_diff = s.datatimes (1:length(s.data)-1);

figure; hold on;
num = 1:length(s.data);
% plot (dt * num, s.data - mean(s.data), 'b'); hold on;
% plot (dt * wkeep(num, length(s.datafilt_nobase), 'c'), s.datafilt_nobase, 'g:');
plot (dt * wkeep(num, length(s.datafilt_lowpass), 'c'), s.datafilt_lowpass - mean(s.datafilt_lowpass), 'r');
plot (dt * num, 0 + zeros(1, length(num)), 'k');
legend('unfiltered', 'baseline removed', 'nobase+lowpass filter');




tr = 0.0:0.02:0.22; %threshold range
% mir = 0.01:0.01:0.02; %minimium interval range
% tr = 0.7;
mir = 0.001;

if length(mir) > 1
    dmir = mir(2) - mir(1);
    dtr = tr(2) - tr(1);
    amat = zeros(length(tr), length(mir));
end

for min_int = mir
    a = [];
    for thresh = tr
        thresh;
        ints = down_up_ints (s.datatimes_lowpass, s.datafilt_lowpass, thresh);
    %     ints = down_up_ints (s.datatimes_diff, s.data_diff, thresh);

    %     ints = gamrnd(2,2,1,50000);
        ints = ints(find(ints>min_int));

        % Histogram
        IQR = iqr(ints);
        len = length(ints);

    %     % Sturges' Formula
    %     nbins = log2(len) + 1;
    %     spacing = (max(ints) - min(ints)) / nbins;

    %      % Scott Rule
    %      spacing = 3.5*std(ints)*len^(-1/3);   % Estimate the appropriate number of bins
    %      nbins = ceil ((max(ints) - min(ints))/spacing); % using Freedman-Draconis ruls    

        %  Friedman Diaconis Rule
        spacing = 2*IQR*len^(-1/3);                       % Estimate the appropriate number of bins
        nbins = ceil ((max(ints) - min(ints))/spacing); % using Freedman-Draconis ruls

        sp = max(dt, spacing);
        sp

        [nhist binloc] = hist(ints, min(ints):sp:max(ints));


    %     binloc = min(ints):dt:max(ints);
    %     [nhist binloc] = hist(ints, binloc);
        thresh
        min_int
        [coefs resnorm] = fit_gamma2 (ints, binloc, nhist);

        figure; h1 = plot (binloc, nhist,'b.');
        hold on;
        h2 = plot (binloc, gamma_pdf2 ([coefs(1:2) coefs(6)], binloc), 'r');    
        h3 = plot (binloc, coefs(4) * gampdf (binloc, coefs(2), coefs(3)), 'g:');
        legend ([h1 h2], ['thresh=' num2str(thresh) ' mint=' num2str(min_int)] ,['a=' num2str(coefs(2)) ' b=' num2str(coefs(3)) ' max=' num2str(coefs(4)) ' err=' num2str(resnorm)]);

        % Make a array (old code, 1d)
        a = [a coefs(2)];
        
        % Make a matrix (2d)
        if length(mir) > 1
            miindex = round((min_int-min(mir))/dmir + 1);
            trindex = round((thresh-min(tr))/dtr + 1);
            amat(trindex, miindex) = coefs(2);
        end
    end

    s.alpha = coefs(1);
    s.ints = ints;
    
    if length(a) > 1
        figure; bar(tr, a);
        xdiff = max(tr) - min(tr);
        ydiff = max(a) - min(a);
        axis ([(min(tr)-0.25*xdiff) (max(tr)+0.25*xdiff) min(0.8, min(a)-0.25*ydiff) max(a)]);
    end
end

if length(mir)>1
    s.amat = amat;
    imagesc (mir, tr, amat);
end

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
