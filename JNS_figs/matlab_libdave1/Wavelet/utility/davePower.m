function y = davePower (x)     %Take 2nd (non-central) moment

N = length(x);
y = sum(x.^2) / N;


end