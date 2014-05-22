
function f = cauchy_gengaus_pdf(coefs, x)

    C = coefs(1);
    a = coefs(2);
    b = coefs(3);
    sig = coefs(4);
    
    f = C * (1/a^2) ./ ((x).^2 + 1/a^2) .* exp(-abs(x).^b/(b*sig^b));

end
