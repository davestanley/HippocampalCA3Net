% 
% t = 0:0.01:0.99;
% f = cos(2*pi*4*t);
% [freq x] = daveFFT(t,f,1);
% plot(freq,x)



t = 0.1:0.1:1;
% t = 0:1;
f = cos(2*pi*3*t);
[freq x] = daveFFT(t,f,1);
% plot(freq,abs(x).^2)
plot(freq,real(x))
% 
