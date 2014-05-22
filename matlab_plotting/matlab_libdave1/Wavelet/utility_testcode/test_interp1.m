


% test_moving average
dt=0.001
t=0:dt:3;
x=10*sin(2*pi*1*t);
x = x + rand(1,length(x));

% figure;plot(t,x);

t2 = t+1.3333;
x2 = x+10;
x3 = [x(:); x2(:)];
t3 = [t(:); t2(:)];

figure; plot(t3,x3);






% tuniq = unique(t3);
% nelements = histc(t3,tuniq);
% figure; plot(tuniq,nelements,'o');

% x = -2.9:0.1:2.9;
% y = randn(10000,1);
% n_elements = histc(y,x);
% figure(2),bar(x,n_elements);