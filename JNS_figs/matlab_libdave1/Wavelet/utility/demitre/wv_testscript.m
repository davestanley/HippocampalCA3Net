

%Generate time series
dt = 0.001;
t = 0:dt:120;

%Generate data series
f1 = 1000/2^10;
f2 = 1000/2^4;
x = sin(2*pi*f1*t) + cos (2*pi*f2*t);        %Superposition of 0.97Hz sin wave and 62Hz cos wave


[freq pow] = wvSpect(t,x);                  %This is the powerspectrum command - simply input the data time series
                                            %and it will output the power
                                            %spectrum
[freq2 val2] = daveFFT(t,x,1);
len2 = round(length(freq2)/2); freq2 = freq2(1:len2); val2 = val2(1:len2); pow2 = abs(val2).^2;


figure;
loglog(freq, pow, 'ro:');
hold on
loglog(freq2,pow2, 'b');

