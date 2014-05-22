function stats_plot (s)
global sig
global baseline_compare


baseline_compare = 0;

figure;
hold on

subplot(111)  %%%Plot FFT

%Cheap hack for plotting baseline (optional)
if baseline_compare 
    if isfield(s.name, 'noisename') == 0        %A raw output recording
        basestruct = build_struct(s.name.datapath, '1-baseline.txt','y');
        %Take fft of data structure
        [basef baseF] = daveFFT(basestruct.datatimes, basestruct.datafilt, 1);
        baseP = abs(baseF).^2;
        temp = round(length(baseP)/2);
        loglog (basef(1:temp), baseP(1:temp),'k:'); hold on
    end
end


% Plot FFT Spectrum
% temp = round(length(t1)/2);
temp = round(length(s.fft.f));
loglog ((s.fft.f(2:temp)), (abs(s.fft.fft_val(2:temp)).^2), 'b'); hold on;
h1 = loglog ((s.fft.f(s.fft.fitlist)),(abs(s.fft.fft_val(s.fft.fitlist)).^2),'g:'); hold on;   %Plots the region of the spectrum we're fitting to
% temp2 = round(length(s.noisetimes)/2);
% plot (s.fftnoise.f(2:temp2), abs(s.fftnoise.fft_val(2:temp2)).^2, 'r');
%Plot starting at 2 to remove the zero term.
title('Power Spectrum');
xlabel ('freq (hz)')


%Plot linear best fit
fitlist = s.fft.fitlist;
p = [s.general_beta_est.beta_est s.general_beta_est.const_est];         %New format
% p = [s.general_beta_est, log10(mean(abs(s.fft.fft_val(2:temp).^2)))]; %Uncomment for old format
h2 = loglog((s.fft.f(min(fitlist):temp)), (10^p(2) * s.fft.f(min(fitlist):temp).^p(1)), 'r');
legend ([h1 h2], 'Fitting region',['Fit slope = ' num2str(p(1),'%1.2f')], 'location', 'NorthWest');



%Plot Wavelet Spectrum
loglog ((s.fft.wvf), (abs(s.fft.wvfft_val.^2)), 'b'); hold on;
h3 = loglog ((s.fft.wvf(s.fft.wvfitlist)),(abs(s.fft.wvfft_val(s.fft.wvfitlist)).^2),'g:'); hold on;   %Plots the region of the spectrum we're fitting to
title('Power Spectrum (datafilt)');
xlabel ('freq (hz)')

% Plot linear best fit
temp = length(s.fft.wvf);
wvfitlist = s.fft.wvfitlist;
p = [s.general_beta_est.wvbeta_est s.general_beta_est.wvconst_est];         %New format
% p = [s.general_beta_est, log10(mean(abs(s.fft.fft_val(2:temp).^2)))]; %Uncomment for old format
h4 = loglog((s.fft.wvf(min(wvfitlist):temp)), (10^p(2) * s.fft.wvf(min(wvfitlist):temp).^p(1)), 'm');
legend ([h1 h2 h4], 'Fitting region',['Fit slope = ' num2str(s.general_beta_est.beta_est,'%1.2f')],['Fit slope = ' num2str(p(1),'%1.2f')], 'location', 'NorthWest');





end