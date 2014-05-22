
function f = gamma_pdf(coefs, x)
global sig
global C_scale
                % sig = sqrt(alpha) * beta
                % C = Cprime * C_scale

    C = coefs(1) * C_scale;
    a = coefs(2);
    b = sig/sqrt(a);

    f = C * 1/((b^a)*gamma(a)) * x.^(a-1).*exp(-x/b);

end
