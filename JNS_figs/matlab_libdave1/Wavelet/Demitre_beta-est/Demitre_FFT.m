% Fast Fourier Transform Program
Y = fft(X,2048);
Z = Y.*conj(Y); 
m = length(X);
f = 10000*(0:ceil(m/2))./m; %multiply by sampling frequency
f=10000*(1:2048)./2048;
P = Z((1:2048),1);
% P = Z(1:(((length(Z))/2)+1),1);
figure; plot(f,P);  %Change this
figure; loglog(f,P);  %Change this

% Plotting figures

%-- Obs Background --
%subplot(2,2,1); loglog(f,P,'red'); hold on;
%subplot(2,2,2); loglog(f,P,'red'); hold on;
%subplot(2,2,3); loglog(f,P,'red'); hold on;
%subplot(2,2,4); loglog(f,P,'red'); hold on;

%-- Baseline Background --
%subplot(2,2,1); loglog(f,P,'black'); hold on;
%subplot(2,2,2); loglog(f,P,'black'); hold on;
%subplot(2,2,3); loglog(f,P,'black'); hold on;
%subplot(2,2,4); loglog(f,P,'black'); hold on;

%-- Individual traces --
%subplot(2,2,2); loglog(f,P,'green'); hold on; %synaptic-green, gap-blue
%subplot(2,2,3); loglog(f,P,'blue'); hold on; %synaptic-green, gap-blue
%subplot(2,2,4); loglog(f,P,'magenta'); hold on;
