
function [freq pow] = wvSpect(t, x)



dt1 = t(2) - t(1);
len = length (x);
numcoefs = round(log2(len)) - 4;
wvstruct = dwt_dave (x', numcoefs, 0);


for i = 1:numcoefs
    val(i) = davePower(wvstruct.dwt(i).coefs);
    scale(i) = 2^i;
    freq(i) = 1/(2^i * dt1);
end

pow = val.^2;


end


function y = davePower (x)     %Take 2nd (non-central) moment

N = length(x);
y = sum(x.^2) / N;


end