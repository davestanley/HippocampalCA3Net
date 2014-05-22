
x = s1.data(5000:end);
figure; plot(x)


[T,V,P,R,cc] = dwtdec(x);
treethr = T(1);
psig = T(2);
prunethr = treethr;
plottree = 1;

[yR,yRR,S,R,indR,indRR,tr]=wavpackfilter(x,treethr,psig,prunethr,plottree);
%
%[yR,yRR,S,R,indR,indRR,T]=wavpackfilter(s,treethr,psig,prunethr,plottree);
%
%s: signal to be filtered
%treethr: threshold on interpeak interval variance for tree analysis
%(default = 0.005)
%psig: average signal power significance (default = 0.05)
%prunethr: threshold on interpeak interval variance for final pruning
%(default = treethr)
%plottree = 0 to turn off plot of wavelet packet tree during execution
%
%yR: filtered signal
%yRR: extracted signal (reconstructed from filtered components)
%S: synthesized signal with all nodes included
%R: matrix of terminal tree node reconstructions
%indR: index of terminal tree nodes used in constructing yR
%indRR: index of terminal tree nodes used in constructing yRR
%T: returned wavelet packet binary tree
%
%
%Osbert Zalay, August 2007

figure;
subplot (411); plot(x,'b');
subplot(412); plot(yR,'g');
subplot(413); plot (yRR,'r');
subplot(414); plot (S,'m');

figure;
nmax = 5;
for i = 1:nmax
    subplot(nmax,1,i);
    plot(R(i,:))
end

