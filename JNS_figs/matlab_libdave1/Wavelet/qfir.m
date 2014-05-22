
function data_filt = qfir(t, data, n, fHz)

ftype = 'high';

%Calculate appropriate window
dt = t(2) - t(1);
N = length(data);
df = 1/(N*dt);
% maxf = df*(N-1);      %Same as in daveFFT; however this is not needed
max_freq = df*N;

fHz = mod (fHz, max_freq);  %If specified freq lies outside desired range
                        %we shift it using periodicity of frequency
Wn = fHz / ((max_freq)/2);

b = fir1(n, Wn,ftype);



data_filt = filtfilt (b,1,data);

len = 2048;
figure; freqz(b,1,len);
figure;
[h w] = freqz(b,1,len);
subplot(211); hold on;
plot (w/pi, log10(abs(h)/1));
subplot(212); hold on;
plot (w/pi, (unwrap(angle(h)))*180/pi);
% figure; plot(b);
% windowSize = 500;


%Test the frequency response of the filter
t_test = 1:(len*2);
x_test = zeros(1,length(t_test));
x_test(1) = length(t_test);

% [f_test X_test] = daveFFT(t_test,x_test,1);
% %figure;
% subplot(211); hold on
% plot(f_test,(abs(X_test)/1),'-');
% subplot(212); hold on
% plot(f_test,unwrap(angle(X_test))*180/pi,'-');

x_test = filter (b,1,x_test);
% figure; plot(t_test,x_test);
[f_test X_test] = daveFFT(t_test,x_test,1);
len2 = round(length(f_test))/2;
f_test = f_test(1:len2);
X_test = X_test(1:len2);

figure;
subplot(211)
plot(f_test*2,log10(abs(X_test)/1),'r')
subplot(212)
plot(f_test*2,unwrap(angle(X_test))*180/pi,'r');



% %Test the frequency response of the filter
% 
% figure;
% hold on
% for w2 = w
%     t2 = 1:32;
%     x2 = exp(i*w2*t2);
%    
%     x2_filt = filter(b,1,x2);
%    
%     [f2 X2_filt] = daveFFT(t2,x2_filt,1);
% 
%     plot(f2,log10(abs(X2_filt)),'bo');
%    
% end





