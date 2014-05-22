function [coefs_out resnorm_out] = fit_gamma2 (data, binloc, nhist)
global sig
global C_scale
global b_scale
                % sig = sqrt(alpha) * beta
                % C = Cprime * C_scale



    sig = std(data);
            % Note: variance = alpha*beta^2, so we only need to fit 2
            % parameters
    a0 = 4;
    C0 = (binloc(2) - binloc(1)) * sum(nhist);   %Set the constant multiplier to be equal to the integrated area of our data
    b0 = sig;
    Cprime0 = a0;
    bprime = a0;
    
    C_scale = C0 / Cprime0;
    b_scale = b0 / bprime;
    
    coefs_out0 = [Cprime0 a0 bprime];
    options = optimset ('MaxFunEvals', 5000, 'TolFun', 0.000001);
    [coefs_out resnorm_out] = lsqcurvefit(@gamma_pdf2, coefs_out0, binloc, nhist, -Inf, Inf, options);
    
    a = coefs_out (2);
    bprime = coefs_out(3);
    b = bprime * b_scale;
    Cprime = coefs_out(1);
    C = Cprime * C_scale;

    coefs_out = [Cprime a b C C_scale bprime b_scale];
    
end