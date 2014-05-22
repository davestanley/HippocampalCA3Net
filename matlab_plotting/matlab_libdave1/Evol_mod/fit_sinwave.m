
function [A phi mse percent_error t y] = fit_sinwave(t, x, period)
    global per
    per = period;
    plot_on = 0;
    
    [temp maxind] = max(x);
    coefs0=[std(x), t(maxind)];
    %coefs0=[std(x), 0.5];
    ub = [Inf, period]; lb = [std(x)*0.001, 0];
%     options = optimset ('MaxFunEvals', 5000, 'TolFun', 0.0000000001);
    options = optimset('Display','off');
    [coefs resnorm] = lsqcurvefit(@cosine_dav,coefs0,t, x-mean(x), lb, ub,options);
    A=coefs(1);
    phi=coefs(2);            % Fix this - find a better way, maybe put bounds on curve fitting
    y = cosine_dav(coefs,t,mean(x));
    % resnorm2 = sum((x - y).^2);
    
    max_error = sum((x - mean(x)).^2);  % Maximum error is assumed to be the case when the estimator equals the mean of x.
    percent_error = resnorm / max_error * 100;

    if plot_on
        figure(55);clf;
        hold on; plot(t, x, 'bo--')
        plot(t, y,'g');
        title(['resnorm=' num2str(resnorm) '; percent_error = ' num2str(percent_error) '.']);
        legend('original','sin fit');
    end
    mse = resnorm;

end


function y = cosine_dav (coefs, t, yoffset )

    if nargin < 3
        yoffset = 0;
    end
    
    global per
    period = per;
    A=coefs(1);
    phi=coefs(2);
    y = A*cos(2*pi/period*(t-phi)) + yoffset;
end