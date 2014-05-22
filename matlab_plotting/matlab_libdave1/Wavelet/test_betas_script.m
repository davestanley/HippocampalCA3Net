
clear;

desired_freq = 2^10; %hz
dt = 1/desired_freq;
len = 2^16;
t = (1:len)*dt;

% testing
% dt = 0.1;
% t = 0.1:0.1:1;
% len = length(t);

df = 1/(len*dt);
fdav2 = (0:(len-1))*df;


fdav = fdav2(1:(len/2+1));
fftdav = (fdav.^(-1)) .* exp((1i)*rand(1,length(fdav)));    %power law decay + rand phase
fftdav(1) = 0;

% fdav = fdav2(1:(len/2+1));
% fftdav = zeros(1,length(fdav));
% fftdav(3) = 1;

temp = length(fftdav);
fftdav2 = [fftdav conj(fliplr(fftdav(2:(temp-1))))];

dav = length(fftdav2)*ifft(fftdav2);

[f3 x3] = daveFFT(t,dav,1);
figure
plot(fdav2,abs(fftdav2))
hold on
plot(f3,abs(x3),'r*');
hold off

figure
plot(t,dav);

data = real(dav)';
dt1 = dt;
