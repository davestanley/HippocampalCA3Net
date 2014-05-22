
function s = stats_dave (s)

format compact;
global sig;         %This will be used later in the curve fitting
global baseline_compare
clean_memory = 0;
clean_filtered = 0;
plotting = 0;       %Turn plotting on/off
baseline_compare = 0;    % Controls whether the baseline is plotted against 
                                % the current frequency spectrum


if isfield (s,'statsdata') == 1
    if s.statsdata.mean == mean(s.data)
        already_calculated = 1;
    else
        already_calculated = 0;
    end
end

already_calculated = 0;       %Hard coding to force recalculation of values
                              %Essential for debugging!

if ~already_calculated
    bin_duration = 5; %seconds
    s.statsdata.mean = mean(s.data);
    [s.statsdata.std s.statsdata.stderr] = dave_binoverlap_stats(s.datatimes, s.datafilt2,bin_duration,'std(x)');
    [s.statsdata.var s.statsdata.varerr] = dave_binoverlap_stats(s.datatimes, s.datafilt2,bin_duration,'var(x)');
    [s.statsdata.skew s.statsdata.skewerr] = dave_binoverlap_stats(s.datatimes, s.datafilt2,bin_duration,'skewness(x,0)');       %Setting flag to zero makes an unbiased estimator
    [s.statsdata.kurt s.statsdata.kurterr] = dave_binoverlap_stats(s.datatimes, s.datafilt2,bin_duration,'kurtosis(x,0)');


    % Histogram
    IQR = iqr(s.datafilt2);
    len = length(s.datafilt2);
    spacing = 2*IQR*len^(-1/3);   % Estimate the appropriate number of bins using Freedman-Draconis ruls
    nbins = ceil((max(s.datafilt2) - min(s.datafilt2))/spacing);
    if nbins == Inf
        nbins = 3;
    end
    [s.statsdata.nhist s.statsdata.binloc] = hist(s.datafilt2, nbins);

    % Wavelet & FFT
    [wvf wvf_val] = wvSpect(s.datatimes, s.data);
    wvf_val = sqrt(wvf_val);
    s.fft.wvf = fliplr(wvf);
    s.fft.wvfft_val = fliplr(wvf_val);
    [s.fft.f s.fft.fft_val] = dave_binoverlap_FFT(s.datatimes, s.data, 5.0);   % Taken from.... Me!!!
%     [s.fft.f s.fft.fft_val] = daveFFT(s.datatimes, s.data, 1);   % Taken from Steinmitz/Koch
    s.fft.fft_h = s.fft.fft_val(1:round(end/2));
    s.fft.f_h = s.fft.f(1:round(end/2));
    temp = round(length(s.fft.f)/2); s.fft.f = s.fft.f(1:temp); s.fft.fft_val = s.fft.fft_val(1:temp);

    
    %   Power statistics
        lowfreq_min = 0.2;
        lowfreq_max = 5;
            lowrange = find( (lowfreq_min <= s.fft.f) .* (s.fft.f < lowfreq_max) );
        midfreq_min = lowfreq_max;
        midfreq_max = 20;
            midrange = find( (midfreq_min <= s.fft.f) .* (s.fft.f < midfreq_max) );
        highfreq_min = 50;
        highfreq_max = 100;
            highrange = find( (highfreq_min <= s.fft.f) .* (s.fft.f < highfreq_max) );
        s.specstd.low = sum( abs(s.fft.fft_val(lowrange)).^2 ).^(1/2);
        s.specstd.mid = sum( abs(s.fft.fft_val(midrange)).^2 ).^(1/2);
        s.specstd.high = sum( abs(s.fft.fft_val(highrange)).^2 ).^(1/2);
        s.specstd.lowerr = 0;
        s.specstd.miderr = 0;
        s.specstd.higherr = 0;
        
%         original frequencies
%         lowfreq_min = 0.2;
%         lowfreq_max = 10;
%             lowrange = find( (lowfreq_min <= s.fft.f) .* (s.fft.f < lowfreq_max) );
%         midfreq_min = lowfreq_max;
%         midfreq_max = 100;
%             midrange = find( (midfreq_min <= s.fft.f) .* (s.fft.f < midfreq_max) );
%         highfreq_min = 1000;
%         highfreq_max = 5000;
%             highrange = find( (highfreq_min <= s.fft.f) .* (s.fft.f < highfreq_max) );
%         s.specstd.low = sum( abs(s.fft.fft_val(lowrange)).^2 ).^(1/2);
%         s.specstd.mid = sum( abs(s.fft.fft_val(midrange)).^2 ).^(1/2);
%         s.specstd.high = sum( abs(s.fft.fft_val(highrange)).^2 ).^(1/2);
%         s.specstd.lowerr = 0;
%         s.specstd.miderr = 0;
%         s.specstd.higherr = 0;



%         Jacobson Power stats
        lowfreq_min = 0.2;
        lowfreq_max = 2;
            jlowrange = find( (lowfreq_min <= s.fft.f) .* (s.fft.f < lowfreq_max) );
        midfreq_min = 5;
        midfreq_max = 100;
%         midfreq_min = 15;
%         midfreq_max = 35;
            jmidrange = find( (midfreq_min <= s.fft.f) .* (s.fft.f < midfreq_max) );
        s.specstd.jlow = sum( abs(s.fft.fft_val(jlowrange)).^2 ).^(1/2);
        s.specstd.jmid = sum( abs(s.fft.fft_val(jmidrange)).^2 ).^(1/2);
        s.specstd.jlowerr = 0;
        s.specstd.jmiderr = 0;
            

    %   Wavelt Power statistics
        lowfreq_min = 0.2;
        lowfreq_max = 10;
            lowrange = find( (lowfreq_min <= s.fft.wvf) .* (s.fft.wvf < lowfreq_max) );
        midfreq_min = lowfreq_max;
        midfreq_max = 100;
            midrange = find( (midfreq_min <= s.fft.wvf) .* (s.fft.wvf < midfreq_max) );
        highfreq_min = 1000;
        highfreq_max = 5000;
            highrange = find( (highfreq_min <= s.fft.wvf) .* (s.fft.wvf < highfreq_max) );
        s.wvstd.low = sum( abs(s.fft.wvfft_val(lowrange)) );
        s.wvstd.mid = sum( abs(s.fft.wvfft_val(midrange)) );
        s.wvstd.high = sum( abs(s.fft.wvfft_val(highrange)) );
        s.wvstd.lowerr = 0;
        s.wvstd.miderr = 0;
        s.wvstd.higherr = 0;


    %//////////////
    %Normalize the power/amplitude of the white noise to that of the
    %original signal (optional)
    % noise = noise / std(noise) * std(s.statsdata.data); %normalize power
    %noise = (noise / sum(abs(noise))) * sum(abs(s.statsdata.data));    %normalize amplitude
    %///////////////////// (end optional)

    if isfield (s,'noise')
        s.statsnoise.mean = mean(s.noise);
        s.statsnoise.std = std(s.noise);
        s.statsnoise.var = var(s.noise);
        s.statsnoise.skew = skewness (s.noise, 0);        %Setting flag to zero makes an unbiased estimator
        s.statsnoise.kurt = kurtosis (s.noise, 0);
        [s.statsnoise.nhist s.statsnoise.binloc] = hist(s.noise, nbins);
        [s.fftnoise.f s.fftnoise.fft_val] = dave_binoverlap_FFT(s.noisetimes, s.noise, 10);

        %Normalize histogram so that it reports approx the same # of data points
        s.statsnoise.nhist = (s.statsnoise.nhist / sum(s.statsnoise.nhist)) * sum(s.statsdata.nhist);
    end



    % Curve fitting to log-log
    intlist = sortrows (s.interval);
%     if length(s.data) > 200000      %Includes only RO cases
%         max_freq = 5000;
%     else                            %Includes baseline and PI cases
%         max_freq = max(s.fft.f);
%     end

    min_freq = 1;
    max_freq = 100;
    
    %Fit FFT
    intlist = [0 min_freq; s.interval; max_freq Inf];
    %[const_est beta_est fitlist] = fit_betastandard_scaling (s.fft.f, s.fft.fft_val, intlist);
    [const_est beta_est fitlist] = fit_betalog (s.fft.f, s.fft.fft_val, intlist);
    
    
    s.general_beta_est.beta_est = beta_est;
    s.general_beta_est.beta_esterr = 0;
    s.general_beta_est.const_est = const_est;
    s.fft.fitlist = fitlist;
    
    %Fit Wavelet
    intlist = [0 min_freq; max_freq Inf];
    [const_est beta_est fitlist] = fit_betalog (s.fft.wvf, s.fft.wvfft_val, intlist);
    %[const_est beta_est fitlist] = fit_betastandard (s.fft.wvf, s.fft.wvfft_val, intlist);
    
    s.general_beta_est.wvbeta_est = beta_est;
    s.general_beta_est.wvbeta_esterr = 0;
    s.general_beta_est.wvconst_est = const_est;
    s.fft.wvfitlist = fitlist;



    % Fitting PDF
    [coefs_out resnorm_out] = fit_hist (s.datafilt2,  s.statsdata.binloc, s.statsdata.nhist);
%     [mu sig] = normfit (s.datafilt2);
%     [coefs3] = gamfit (abs(s.datafilt2));
%     [coefs4] = wblfit (abs(s.datafilt2));
    [coefs_out5 resnorm_out5] = fit_gendist (s.datafilt2,  s.statsdata.binloc, s.statsdata.nhist);
%     [coefs_out6 resnorm_out6] = fit_cauchy (s.datafilt2,  s.statsdata.binloc, s.statsdata.nhist);    
%     [coefs_out7 resnorm_out7] = fit_cauchy_gengaus (s.datafilt2,  s.statsdata.binloc, s.statsdata.nhist);    
    coefs_out7 = [6.6472e+03 0.1564 1.7534 0.5327];        % fit_cauchy_gengaus crashes sometimes, so i hardcode this instead

    
    s.statsdata.pdfcoefs = coefs_out;
%     s.statsdata.pdfcoefs2 = [mu sig];
%     s.statsdata.pdfcoefs3 = coefs3;
%     s.statsdata.pdfcoefs4 = coefs4;
    s.statsdata.pdfcoefs5 = coefs_out5;
%     s.statsdata.pdfcoefs6 = coefs_out6;
    s.statsdata.pdfcoefs7 = coefs_out7;
    
    s.statsdata.gauspdf = coefs_out(2);
    s.statsdata.gauspdferr = 0;
    
    coefs_out(2);
    resnorm_out;

    if isfield (s,'noise')
            [coefs_in resnorm_in] = fit_hist (s.noise,  s.statsnoise.binloc, s.statsnoise.nhist);            
            s.statsnoise.pdfcoefs = coefs_in;
            coefs_in(2);
            resnorm_in;
    end
    
%     echo on
%     data = s.data(:);
%     Demitre_psd_scaling(data)
%     echo off

    s.statsdata.stdspread = 0;
    s.statsdata.skewspread = 0;
    s.statsdata.kurtspread = 0;
    s.statsdata.pdfcoefsspread = 0;
    s.statsdata.general_beta_est.beta_estspread = 0;
    s.statsdata.general_beta_est.wvbeta_estspread = 0;
    s.specstd.lowspread = 0;
    s.specstd.midspread = 0;
    s.specstd.higherr = 0;
    s.specstd.jlowspread = 0;
    s.specstd.jmidspread = 0;    

end


if plotting == 1
    stats_plot (s);
	%stats_plot_loglog (s);    
end

clear global baseline_compare


if clean_memory == 1
   s.fft = rmfield (s.fft, 'f');
   s.fft = rmfield (s.fft, 'fft_val');
   s.fft = rmfield (s.fft, 'fitlist'); 
   s.fft = rmfield (s.fft, 'f_h');
   s.fft = rmfield (s.fft, 'fft_h');
end


if clean_filtered == 1
   s = rmfield(s, 'datafilt');
   s = rmfield(s, 'datafilt2');
end

end




