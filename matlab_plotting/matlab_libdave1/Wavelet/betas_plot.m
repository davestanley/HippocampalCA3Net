
function betas_plot(s, display_power)

len = length (s.data);
numcoefs = length (s.wvstruct.dwt);


figure
%Plot a comparison fft and the betas power spectra
if display_power == 1
    subplot(211);

    %Plot Wavelet Spectrum
    loglog ((s.fft.wvf), (abs(s.fft.wvfft_val.^2)), 'b'); hold on;
    h3 = loglog ((s.fft.wvf(s.fft.wvfitlist)),(abs(s.fft.wvfft_val(s.fft.wvfitlist)).^2),'g:'); hold on;   %Plots the region of the spectrum we're fitting to
    title('Power Spectrum (datafilt)');
    xlabel ('freq (hz)')

    % Plot linear best fit
    temp = length(s.fft.wvf);
    wvfitlist = s.fft.wvfitlist;
    p = [s.general_beta_est.wvbeta_est s.general_beta_est.wvconst_est];         %New format
    h4 = loglog((s.fft.wvf(min(wvfitlist):temp)), (10^p(2) * s.fft.wvf(min(wvfitlist):temp).^p(1)), 'm');
    legend ([h3 h4], ['Wavelet Spectrum'],['Fit slope = ' num2str(p(1),'%1.2f')], 'location', 'NorthWest');

    subplot(212);
end

%Plot the betas
bar (fliplr(s.betas.b(2,2:size(s.betas.b,2))));

%Add text and axis labels
for i = 2:numcoefs
    %Calculate frequencies and store in array to be placed along x-axis
    %xlabel_arr(i-1) = {[num2str(1/(2^(i-1))/s.dt1,'%1.1f') '-' num2str(1/(2^i)/s.dt1,'%1.1f')]};
    xlabel_arr(i-1) = {[num2str(1/(2^i)/s.dt1,'%1.1f')]};

    %Also draw in the scales
    ypos = max(s.betas.b(2,2:size(s.betas.b,2))) * 1;
    %text(numcoefs-(i-1)-.5, ypos, ['Scl' num2str(2^(i-1)) '-' num2str(2^i)],'FontSize',8);
    text(numcoefs-(i-1)-.5, ypos, ['Scl' num2str(2^(i-1))],'FontSize',8);
end

xlabel_arr = fliplr (xlabel_arr);
set(gca,'XTick',1:numcoefs-1)
set(gca,'XTickLabel',xlabel_arr, 'FontSize', 8)
title('Multiscale Exponents (data)');
xlabel ('Hz');


end
