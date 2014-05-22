function [coefs_out resnorm_out] = fit_cauchy (data, binloc, nhist)

    % Passing binloc and nhist speeds up calculation
    if ~(exist('binloc') && exist ('nhist'))
            IQR = iqr(s.datafilt2);
            len = length(s.datafilt2);
            spacing = 2*IQR*len^(-1/3);   % Estimate the appropriate number of bins using Freedman-Draconis ruls
            nbins = ceil((max(s.datafilt2) - min(s.datafilt2))/spacing);

            [nhist binloc] = hist(data, nbins);
    end

    sig = std(data);
    coefs_out0 = [max(nhist) sig 2];

%     options = optimset ('MaxFunEvals', 5000, 'TolFun', 0.0000000000000001);
    [coefs_out resnorm_out] = lsqcurvefit(@cauchy_pdf, coefs_out0, binloc, nhist, -Inf, Inf);

end