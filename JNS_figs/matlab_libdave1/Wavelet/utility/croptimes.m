
function [tout xout] = croptimes (t,x,tstart, tend)
    if nargin < 4
        tend = max(t);
    end

	sind = find(t >= tstart,1,'first');
    eind = find(t>= tend, 1, 'first');
    
    tout=t(sind:eind);
    
    [nrow ncol] = size(x);
    if nrow == length(t)
        xout = x(sind:eind,:);
    elseif ncol == length(t)
        xout = x(:,sind:eind);
    else
        fprintf('Time vector t does not match dimensionality of x vector\n');
    end


end