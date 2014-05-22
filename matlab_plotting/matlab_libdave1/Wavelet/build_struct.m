
function s = build_struct (datapath, dataname, to_filter, datastart, opt_strct, noisename, noise_timestep)


% % % Defaults
ds2 = 1;
baseline_freq = 0.2; %Hz
max_freq_filt = 5000; %Hz


if exist('opt_strct','var')
    if isfield (opt_strct,'ds2'); ds2 = opt_strct.ds2; end
    if isfield (opt_strct,'baseline_freq'); baseline_freq = opt_strct.baseline_freq; end
    if isfield (opt_strct,'max_freq_filt'); max_freq_filt = opt_strct.max_freq_filt; end

end



    plot_filter_comparison = 0;     % Setting to 1 plots a graph comparing pre-filtered & post-filtered data
    enable_smart_data_downsampling = 0;     % Set this to zero unless you're working with my Genesis data sampled at 2.5e-5
                                            % This code is broken - do not
                                            % use. It should anti-alias the
                                            % signal first, but this is not
                                            % yet implemented.
    
    

    if (strcmp(datapath, '-1')) % If you have data stored in a variable and don't want to load it from scratch
        datafile = dataname;    % set datapath to '-1'
    else
        s.name.datapath = datapath;
        s.name.dataname = dataname;
        datafile = load ([datapath dataname]);
    end

    
    if exist('datastart','var') == 1
        s.data = datafile(datastart:end,2);
    else    
        s.data = datafile(1:end,2);
    end
    
    len = length(s.data);
    s.dt1 = datafile(end,1)-datafile(end-1,1);
    s.datatimes = (1:len)'*s.dt1;
    
    
    if exist('noisename', 'var') == 1
       s.name.noisename = noisename;
       s.noise = load ([noisename]);
       s.dt2 = noise_timestep;
       s.noisetimes = (0:(length(s.noise)-1))*s.dt2;
       data_min = min(s.datatimes);
       data_max = max(s.datatimes);
       noisestart = find(s.noisetimes >= data_min, 1,'first');
       noisestop = find(s.noisetimes <= data_max, 1, 'last');
       
       s.noise = s.noise(noisestart:noisestop);
       s.noisetimes = s.noisetimes(noisestart:noisestop);
    end
    
    if (enable_smart_data_downsampling == 1) && ((round(s.dt1*1e6) == 25) || ((round(s.dt1*1e7) == 25)))
        ds = round (1e-4 / s.dt1);
        s.datatimes = downsample (s.datatimes,ds);
        s.data = downsample (s.data, ds);
        s.dt1 = s.datatimes(end)-s.datatimes(end-1);
        fprintf ('Downsampling data to 1e-4 \n');
    end
    
    s.datatimes = downsample (s.datatimes, ds2);
    s.data = downsample (s.data,ds2);
    s.dt1 = s.datatimes(end)-s.datatimes(end-1);
    fprintf (['Downsampling by a factor of ' num2str(ds2) '\n']);
    
    
    if to_filter == 'y'
        
%         % Test
%         s.datatimes = (0:0.0001:1)';
%         s.data = sin (2*3.14159*30*s.datatimes);

        s.interval = smartfilter_interval (s.datatimes, s.data);

        s.interval2 = [0 baseline_freq; s.interval; max_freq_filt Inf]; %; 150 5000];  % Can add ;150 5000
        s.datafilt = qif(s.datatimes, s.data, s.interval);
        s.datafilt2 = qif(s.datatimes, s.data, s.interval2);
%         s.datafilt2 = remove_baseline_avg (s.datatimes, s.datafilt, 1/(baseline_freq*2));
                    % For baseline method, we need to crank up the frequency a bit for
                    % it to actually catch what we are looking for. Remember that
                    % baseline method simply "ignores" or leaves everything above the specified
                    % frequency alone, where as the qif method actually chops off the
                    % stuff below the baseline frequency.
                    
%       Chop off 3 secs from start and end of each dataset to eliminate
%       edge effects
        edgestart = find (s.datatimes >= (min(s.datatimes)+3),1,'first');
        edgestop = find(s.datatimes >= (max(s.datatimes)-3),1,'first');
        s.datatimes = s.datatimes(1:(edgestop-edgestart+1));    % Use beginning of time array for consistency
        s.data = s.data(edgestart:edgestop);
        s.datafilt = s.datafilt(edgestart:edgestop);
        s.datafilt2 = s.datafilt2(edgestart:edgestop);

        if (plot_filter_comparison)
            plot_comparison (s.datatimes, s.data, s.datafilt);
        end
        
        
% % % % % % %         OLD FILTER CODE
%         % s.data_nobase2 = remove_baseline_polyfit (s.datatimes, s.data);
%         s.data_nobase = remove_baseline_avg (s.datatimes, s.data, 1/30);        
%         s.interval = smartfilter_interval (s.datatimes, s.data_nobase);
%         
% %         s.interval2 = [0 10 ; s.interval];
%         s.datafilt = qif(s.datatimes, s.data, s.interval);
%         s.datafilt2 = qif(s.datatimes, s.data_nobase, s.interval);
% %         s.datafilt2 = qif(s.datatimes, s.data, s.interval2);
% 
%         if (plot_filter_comparison)
%             plot_comparison (s.datatimes, s.data_nobase, s.datafilt2);

    else
            s.datafilt = s.data - mean(s.data);
            s.datafilt2 = s.datafilt;
            if (plot_filter_comparison)
                plot_comparison (s.datatimes, s.data, s.datafilt);
            end
            s.interval = [0 0];
            s.interval2 = [0 0];

    end
end







% % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % Functions
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

function interval = smartfilter_interval (datatimes, data)

    raw_interval = [60 180 300 420 540 660 780 900 1500];    % Default electrical AC filtering


    %Use smart filtering to remove excess mechanical noise
    [f fft_val] = daveFFT(datatimes, data, 1);
    temp = round(length(f)/2); f = f(1:temp); fft_val = fft_val(1:temp);
    
    window_hertz = 60;  %Hz
    spike_threshold_multiplier = 10;
    start_freq = 100; %Hz --> Start searching at this frequency
    raw_interval = [raw_interval identify_fft_noise(f, fft_val, start_freq, window_hertz, spike_threshold_multiplier)];
    df = f(2) - f(1);

    
    interval = zeros(length(raw_interval), 2);
    for i = 1:length(raw_interval)
%        interval(i,:) =  [max((raw_interval(i) - 2*df), 0) (raw_interval(i) + 2*df)];   %no negative intervals
       interval(i,:) =  [max((raw_interval(i) - 0.1), 0) (raw_interval(i) + 0.1)];   %no negative intervals
    end
end

function plot_comparison (datatimes, data, datafiltered)
    [f fft_val] = daveFFT(datatimes, data, 1);
    temp = round(length(f)/2); f = f(1:temp); fft_val = fft_val(1:temp);
    
    [f2 fft_val2] = daveFFT(datatimes, datafiltered, 1);
    temp = round(length(f2)/2); f2 = f2(1:temp); fft_val2 = fft_val2(1:temp);
    
    ufiltered_power = davePower(data);
    filtered_power = davePower (datafiltered);
    percent_of_original = filtered_power / ufiltered_power * 100;
    
    figure; subplot(211)
    plot (datatimes, data - mean(data)); hold on
    plot (datatimes, datafiltered - mean(datafiltered),'r');
%     legend (['Unfiltered Power=' num2str(ufiltered_power, '%e')], ['Filtered Power=' num2str(filtered_power, '%e')]);   
    legend (['Unfiltered Power=' num2str(ufiltered_power, '%e')], ['Filtered Power is ' num2str(percent_of_original) '%']);
    
    subplot (212)
    plot (f, abs(fft_val).^2, 'r'); hold on;
    plot (f2, abs(fft_val2).^2, 'b');
%     axis ([min(f) max(f) 0 var(fft_val)]);
    
    legend ('Unfiltered FFT', 'Filtered FFT');
    xlabel ('Frequency (Hz)');
    
end

function data_nobase = remove_baseline_polyfit (datatimes, data)
    coefs_out0 = ones (1, 10);
    
%     [coefs_out resnorm_out] = lsqcurvefit(@power_ratio, coefs_out0, datatimes, data, -Inf, Inf);
    p = polyfit (datatimes, data, 18);
    baseline = polyval(p, datatimes);
    data_nobase = data - polyval(p,datatimes);
    
%     figure;
%     plot (datatimes, data); hold on;
%     plot (datatimes, baseline,'r');
%     plot (datatimes, data_nobase,'g');    
end


function data_nobase = remove_baseline_avg (datatimes, data, filt_time)
    % Set constants
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
    
    figure; plot (datatimes, data - mean(data), 'b'); hold on;
    plot (datatimes, baseline - mean(data), 'r');
    plot (datatimes, data_nobase, ':g');
    

end




