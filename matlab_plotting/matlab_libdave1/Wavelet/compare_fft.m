
function compare_fft (s1, s2, minfreq, maxfreq)

format compact;

figure;



% Do it for s1

s = s1;

df = s.fft.f(2) - s.fft.f(1);
% Get Normalizing constant
start = find (s.fft.f>=minfreq,1);
stop = find (s.fft.f>=maxfreq,1);
cnorm = sum (abs(s.fft.fft_val(start:stop)).^2) * df;


% Plot FFT Spectrum
% temp = round(length(t1)/2);
temp = round(length(s.fft.f));
h1 = loglog ((s.fft.f(2:temp)), (abs(s.fft.fft_val(2:temp)).^2) / cnorm, 'b'); hold on;
hold on
%h1 = loglog ((s.fft.f(s.fft.fitlist)),(abs(s.fft.fft_val(s.fft.fitlist)).^2) / cnorm,'g:'); hold on;   %loglogs the region of the spectrum we're fitting to
% temp2 = round(length(s.noisetimes)/2);
% loglog (s.fftnoise.f(2:temp2), abs(s.fftnoise.fft_val(2:temp2)).^2, 'r');
%loglog starting at 2 to remove the zero term.
title('Power Spectrum');
xlabel ('freq (hz)')



%loglog linear best fit
fitlist = s.fft.fitlist;
p = [s.general_beta_est.beta_est s.general_beta_est.const_est];         %New format
% p = [s.general_beta_est, log10(mean(abs(s.fft.fft_val(2:temp).^2)))]; %Uncomment for old format
h2 = loglog((s.fft.f(min(fitlist):temp)), (10^p(2) * s.fft.f(min(fitlist):temp).^p(1)) / cnorm, 'r');
legend ([h1 h2], 'Fitting region',['Fit slope = ' num2str(p(1),'%1.2f')], 'location', 'NorthWest');

axis ([0 500 0 max(abs(s.fft.fft_val(2:temp)).^2)/cnorm]);


% Do it for s2
s = s2;
% Get Normalizing constant
start = find (s.fft.f>=minfreq,1);
stop = find (s.fft.f>=maxfreq,1);
cnorm = sum (abs(s.fft.fft_val(start:stop)).^2) * df;


% loglog FFT Spectrum
% temp = round(length(t1)/2);
temp = round(length(s.fft.f));
h1 = loglog ((s.fft.f(2:temp)), (abs(s.fft.fft_val(2:temp)).^2) / cnorm, 'r'); hold on;
%h1 = loglog ((s.fft.f(s.fft.fitlist)),(abs(s.fft.fft_val(s.fft.fitlist)).^2) / cnorm,'g:'); hold on;   %loglogs the region of the spectrum we're fitting to
% temp2 = round(length(s.noisetimes)/2);
% loglog (s.fftnoise.f(2:temp2), abs(s.fftnoise.fft_val(2:temp2)).^2, 'r');
%loglog starting at 2 to remove the zero term.
title('Power Spectrum');
xlabel ('freq (hz)')



%loglog linear best fit
fitlist = s.fft.fitlist;
p = [s.general_beta_est.beta_est s.general_beta_est.const_est];         %New format
% p = [s.general_beta_est, log10(mean(abs(s.fft.fft_val(2:temp).^2)))]; %Uncomment for old format
h2 = loglog((s.fft.f(min(fitlist):temp)), (10^p(2) * s.fft.f(min(fitlist):temp).^p(1)) / cnorm, 'm');
legend ([h1 h2], 'Fitting region',['Fit slope = ' num2str(p(1),'%1.2f')], 'location', 'NorthWest');

axis ([0 500 0 max(abs(s.fft.fft_val(2:temp)).^2)/cnorm]);


hold off                          

end




