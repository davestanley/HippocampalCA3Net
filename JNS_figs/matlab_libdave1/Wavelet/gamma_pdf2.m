
function f = gamma_pdf2(coefs, x)
global sig
global C_scale
global b_scale
                % sig = sqrt(alpha) * beta
                % C = Cprime * C_scale

    C = coefs(1) * C_scale;
    a = coefs(2);
    b = coefs(3) * b_scale;
%     b = sig/sqrt(a);
    

    f = C * 1/((b^a)*gamma(a)) * x.^(a-1).*exp(-x/b);

end
