
function f = cauchy_pdf(coefs, x)

    C = coefs(1);
    a = coefs(2);
    b = coefs(3);
    
    f = C * (a/pi) ./ ((abs(x)).^b + a^2);

end
