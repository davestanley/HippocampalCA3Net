function stats_plot (s)
global sig
global baseline_compare

figure;
subplot(3,2,1)  %%%Plot data
hold on
plotds(s.datatimes, s.datafilt2, 'b', 10) 
if isfield (s,'noise')
    plotds (s.noisetimes, s.noise + 10, ':r', 10);
end
% plotds(s.datatimes, s.data - mean(s.data) - 10, 'g', 10);
hold off
title ('Original Signal(s)');
xlabel('time(s)');

subplot(3,2,2)  %%%Plot stats
if isfield (s,'noise')
    bar ([0 0; s.statsdata.var s.statsnoise.var; s.statsdata.skew s.statsnoise.skew; s.statsdata.kurt s.statsnoise.kurt]);
    legend ('Signal', 'Injected Noise');    
else
    bar ([0; s.statsdata.var; s.statsdata.skew; s.statsdata.kurt]);
end
xlabel_arr(1) = {'mean'};
xlabel_arr(2) = {'var'};
xlabel_arr(3) = {'skew'};
xlabel_arr(4) = {'kurt'};
set(gca,'XTick',[1 2 3 4])
set(gca,'XTickLabel',xlabel_arr)

subplot(3,2,[3 4])  %%%Plot FFT

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




subplot(3,2,[5 6])  %Plot histogram
temp = max(s.statsdata.nhist);
plot (s.statsdata.binloc,s.statsdata.nhist/temp,'b')
if isfield (s,'noise')  %Plot noise histogram
    temp = max(s.statsnoise.nhist);
    hold on; plot (s.statsnoise.binloc,s.statsnoise.nhist/temp,'r'); hold off
end
xlabel ('Normalized Histogram (datafilt2)');


sig = sqrt (s.statsdata.var);
hold on;    %Plot histogram data best fit

% Plot variable beta est
temp = max (exp_pdf(s.statsdata.pdfcoefs, s.statsdata.binloc));
h1 = plot (s.statsdata.binloc, exp_pdf(s.statsdata.pdfcoefs, s.statsdata.binloc)/temp,'g:');

% % Plot gaussian fit
% temp = max(normpdf(s.statsdata.binloc, s.statsdata.pdfcoefs2(1), s.statsdata.pdfcoefs2(2)));
% plot (s.statsdata.binloc, normpdf(s.statsdata.binloc, s.statsdata.pdfcoefs2(1), s.statsdata.pdfcoefs2(2))/temp, 'r:');
% 
% % Plot Gamma fit
% temp = max(gampdf(abs(s.statsdata.binloc), s.statsdata.pdfcoefs3(1), s.statsdata.pdfcoefs3(2)));
% plot (s.statsdata.binloc, gampdf(abs(s.statsdata.binloc), s.statsdata.pdfcoefs3(1), s.statsdata.pdfcoefs3(2))/temp, 'c:');

% % Plot Weibull Fit
% temp = max(wblpdf(abs(s.statsdata.binloc), s.statsdata.pdfcoefs4(1), s.statsdata.pdfcoefs4(2)));
% plot (s.statsdata.binloc, wblpdf(abs(s.statsdata.binloc), s.statsdata.pdfcoefs4(1), s.statsdata.pdfcoefs4(2))/temp, 'm:');

% Plot generalized gaussian & power law distribution
temp = max (gendist_pdf(s.statsdata.pdfcoefs5, s.statsdata.binloc));
hdat5 = plot (s.statsdata.binloc, gendist_pdf(s.statsdata.pdfcoefs5, s.statsdata.binloc)/temp,'k:');
% 
% % Plot cauchy distribution
% temp = max(cauchy_pdf(s.statsdata.pdfcoefs6, s.statsdata.binloc));
% hdat6 = plot (s.statsdata.binloc, cauchy_pdf(s.statsdata.pdfcoefs6, s.statsdata.binloc)/temp, 'r:');

% Plot Cauchy/GeneralizedGaussian Distribution
temp = max(cauchy_gengaus_pdf(s.statsdata.pdfcoefs7, s.statsdata.binloc));
hdat7 = plot (s.statsdata.binloc, cauchy_gengaus_pdf(s.statsdata.pdfcoefs7, s.statsdata.binloc)/temp, 'r:');


hold off;



if isfield (s,'noise')  %Plot histogramnoise best fit
    sig = sqrt (s.statsnoise.var);
    hold on
    temp = max(exp_pdf(s.statsnoise.pdfcoefs, s.statsnoise.binloc));
    h2 = plot (s.statsnoise.binloc, exp_pdf(s.statsnoise.pdfcoefs, s.statsnoise.binloc)/temp,'yo');
    hold off
    legend ([h1; h2], ['PDF ' num2str(s.statsdata.pdfcoefs(2),'%1.2f')], ['PDF ' num2str(s.statsnoise.pdfcoefs(2),'%1.2f')]);
else
%     legend (h1, ['PDF ' num2str(ss.statsdata.pdfcoefs(2),'%1.2f')]);
%     legend ([h1; hdat5], ['PDF ' num2str(s.statsdata.pdfcoefs(2),'%1.4f')], ['a=' num2str(s.statsdata.pdfcoefs5(3)) ' b=' num2str(s.statsdata.pdfcoefs5(4))]);
    legend ([h1; hdat5; hdat7], ['PDF ' num2str(s.statsdata.pdfcoefs(2),'%1.4f')], ['a=' num2str(s.statsdata.pdfcoefs5(3)) ' b=' num2str(s.statsdata.pdfcoefs5(4))], ['a=' num2str(s.statsdata.pdfcoefs7(2)) ' b=' num2str(s.statsdata.pdfcoefs7(3))]);

    
end


end