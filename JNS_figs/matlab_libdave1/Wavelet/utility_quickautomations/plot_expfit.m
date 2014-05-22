
function [tfitted xfitted tplot xplot tau] = plot_expfit (t,x,fitstart, fitend, plotstart, plotend, ploton)

    if nargin < 7; ploton=0; end
    if nargin < 6; plotend = max(t); end
    if nargin < 5; plotstart = 1; end
    if nargin < 4; fitend = max(t); end
    if nargin < 3; fitstart = 1; end
    
%     ploton = 1;

    plotstart_i=find(t >= plotstart, 1, 'first');
    plotend_i=find(t >= plotend, 1, 'first');
    fitstart_i=find(t >= fitstart, 1, 'first');
    fitend_i=find(t >= fitend, 1, 'first');
    tplot=t(plotstart_i:plotend_i); xplot=x(plotstart_i:plotend_i);
    tfit=t(fitstart_i:fitend_i); xfit=x(fitstart_i:fitend_i);
    [p] = polyfit(tfit,log(xfit),1); tau = -1/p(1); C = p(2);
    
    tfitted = t(fitstart_i:plotend_i);
    xfitted = exp(-tfitted/tau+C);
    if ploton
        plot(tplot,xplot,'b'); 
        hold on; plot(tfitted,xfitted,'r','LineWidth',2);
    end
    
    
end