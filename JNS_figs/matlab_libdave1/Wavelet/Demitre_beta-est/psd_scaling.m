% Obtains an estimate of the scaling exponent from the time series using
% the power spectrum.
%
% Useage:
% [beta, ps] = psd_scaling(x)
% Inputs
%    x          - Input signal
%
% Outputs:
%    beta       - Estimated scaling exponent
%    r2         - r^2 goodness of fit estimate
%    se         - Standard error of scaling exponent estimate
%    ps         - Power spectrum
%
% (c) 2008 Max Little.

function [beta, r2, se, ps] = psd_scaling(x)

x = x(:);
N = length(x);
N2 = floor(N/2);

ps = abs(fft(x)).^2;
ps = ps(1:N2);
ps = ps(:);

fitx = log10(1:N2)';
fity = log10(ps(1:N2));

ssxx = N2*var(fitx);
ssyy = N2*var(fity);
ssxy = N2*cov(fitx,fity);
ssxy = ssxy(1,2);

r2 = ssxy^2/(ssxx*ssyy);
s  = sqrt((ssyy-(ssxy^2/ssxx))/(N2-2));
se = s/sqrt(ssxx);
beta = -ssxy/ssxx;