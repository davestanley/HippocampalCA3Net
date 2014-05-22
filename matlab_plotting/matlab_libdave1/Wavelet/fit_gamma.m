function [coefs_out resnorm_out] = fit_gamma (data, binloc, nhist)
global sig
global C_scale
                % sig = sqrt(alpha) * beta
                % C = Cprime * C_scale



    sig = std(data);
            % Note: variance = alpha*beta^2, so we only need to fit 2
            % parameters
    a0 = 5;
    C0 = (binloc(2) - binloc(1)) * sum(nhist);   %Set the constant multiplier to be equal to the integrated area of our data
    Cprime0 = a0;
    
    C_scale = C0 / Cprime0;
    
    coefs_out0 = [Cprime0 a0];
    options = optimset ('MaxFunEvals', 5000, 'TolFun', 0.000001);
    [coefs_out resnorm_out] = lsqcurvefit(@gamma_pdf, coefs_out0, binloc, nhist, -Inf, Inf, options);
    
    a = coefs_out (2);
    b = sig/sqrt(a);    
    Cprime = coefs_out(1);
    C = Cprime * C_scale;

    
    coefs_out = [Cprime a b C C_scale];
    
end