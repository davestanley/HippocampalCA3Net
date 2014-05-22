
function f = gendist_pdf(coefs, x)

    c = coefs(1);
    pseudo_sig = coefs(2);
    a = coefs(3);
    b = coefs(4);

    f = c * abs(x).^(-abs(a)) .* exp(-abs(x).^b / (b*pseudo_sig^b) );


end
