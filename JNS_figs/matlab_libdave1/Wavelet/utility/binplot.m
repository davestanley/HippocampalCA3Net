
function binplot (t, x, binlength, vertshift, binstarts)

% Takes time series (t,x) and splits it into several mini-timeseries based a binlength. Then
% it plots these mini time series one on top of the other. (Shifted in the vertical axis)
% 
% t = time coords
% x = data points
% 
% binlength = size of each bin to plot
% vertshift = distince in the ordinate axis to shift each minibatch
% binstarts = 1xn array of n starting locations for the minibatches.
%                measured in terms of units of t

n = length(binstarts);

for i = 1:n
    
    srt = binstarts(i); stp = srt+binlength;
    start = find (t >= srt, 1); stop = find(t >= stp, 1);
    plot(t(1:(stop-start+1)),x(start:stop) - mean(x(start:stop)) + (i-1)*vertshift,'b');
    hold on;
    
end
