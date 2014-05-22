
function [xout, tout] = davexcorr (t,x,y,normalizeon,ploton)

    if nargin < 4
        ploton = 0;
        normalizeon = 0;
    elseif nargin < 5
        ploton = 0;
    end
    

    % t = (0:0.1:10)';
    % x = sin(2*pi/2*t);
    % y = sin(2*pi/2*t + pi);

    N = length(t);
    dt = t(end)-t(end-1);
    t = (0:(N-1)) * dt;

    t = t(:);
    x = x(:);
    y = y(:);
    
    if normalizeon
        x = x - mean(x);
        y = y - mean(y);
        delx = max(x) - min(x);
        dely = max(y) - min(y);
        x = x / delx;
        y = y / dely;
    end

    if ploton; figure; plot(t,[x,y],''); end

    xout = xcorr(x,y,'coef');
    tout = [-flipud(t); t(2:end)];

    if ploton; figure; plot (tout,xout); end


end
