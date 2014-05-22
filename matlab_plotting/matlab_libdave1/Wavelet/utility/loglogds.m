

function [xnew, ynew]=loglogds (x,y,total,colour)
% Plots a loglog graph downsampled so that
% there is an even density of points across the graph
% Total = desired total num of datapoints

if nargin < 4
    colour = 'b';
end

if nargin < 3
    total = 1000;
end


% minx = min(x);
% if minx == 0
%     x = x(2:end);
%     y = y(2:end);
%     minx = min(x);
% end 
% maxx = max(x);
% ds = (logmax-logmin)/(total-1);
% logmin = log10(minx);
% logmax = log10(maxx);
% index = [];
% for i = logmin:ds:logmax
%     index = [index find(x >= 10^i, 1,'first')];
% 
% 
% end
% xnew = x(index);
% ynew = y(index);
% loglog(xnew,ynew, colour);


if total < 1
    loglog(x,y,colour);
    xnew=x;ynew=y;
    return;
end

minx = 1;
maxx = length(x);
logmin = log10(minx);
logmax = log10(maxx);

ds = (logmax-logmin)/(total-1);
i=logmin:ds:logmax;
indexnew = 10.^i;
indexnew = round(indexnew);
xnew = x(indexnew);
ynew = y(indexnew);
loglog(x(indexnew), y(indexnew), colour);


end