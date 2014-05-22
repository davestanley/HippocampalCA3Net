function stats_plot_fft_nonlog (s)
global sig
global baseline_compare

figure;
hold on


% Plot FFT Spectrum
% temp = round(length(t1)/2);
temp = round(length(s.fft.f));
plot ((s.fft.f(2:temp)), (abs(s.fft.fft_val(2:temp)).^2), 'b'); hold on;
h1 = plot ((s.fft.f(s.fft.fitlist)),(abs(s.fft.fft_val(s.fft.fitlist)).^2),'g:'); hold on;   %Plots the region of the spectrum we're fitting to
% temp2 = round(length(s.noisetimes)/2);
% plot (s.fftnoise.f(2:temp2), abs(s.fftnoise.fft_val(2:temp2)).^2, 'r');
%Plot starting at 2 to remove the zero term.
title('Power Spectrum');
xlabel ('freq (hz)')



%Plot linear best fit
fitlist = s.fft.fitlist;
p = [s.general_beta_est.beta_est s.general_beta_est.const_est];         %New format
% p = [s.general_beta_est, log10(mean(abs(s.fft.fft_val(2:temp).^2)))]; %Uncomment for old format
h2 = plot((s.fft.f(min(fitlist):temp)), (10^p(2) * s.fft.f(min(fitlist):temp).^p(1)), 'r');
legend ([h1 h2], 'Fitting region',['Fit slope = ' num2str(p(1),'%1.2f')], 'location', 'NorthWest');

axis ([0 500 0 max(abs(s.fft.fft_val(2:temp)).^2)]);

hold off

end