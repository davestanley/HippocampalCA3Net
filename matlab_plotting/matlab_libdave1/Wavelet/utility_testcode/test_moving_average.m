


% test_moving average
dt=0.001
t=0:dt:3;
x=10*sin(2*pi*1*t);
x = x + rand(1,length(x));

figure;plot(t,x);


[t2 x2] = daveMVAVG2(t,x,round(0.1/dt), 0.00);
[t3 x3] = daveMVAVG2(t,x,round(0.1/dt));
hold on; plot(t2, x2,'ro');
hold on; plot(t3,x3,'g');
hold on; plot(downsample(t3,round(0.1/dt/2)),downsample(x3,round(0.1/dt/2))+1,'ko-');
