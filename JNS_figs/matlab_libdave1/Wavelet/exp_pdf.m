function f = exp_pdf(coefs, x)
global sig;

    a = coefs(1);
    b = coefs(2);

    f = a*exp(-abs(x).^b/(b*sig^b));

end
