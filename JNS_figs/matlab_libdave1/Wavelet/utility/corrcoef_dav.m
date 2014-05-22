



function CC = corrcoef_dav (x,y)



    option = 'unbiased';
    x=x-mean(x);
    y=y-mean(y);
    
%     Cxx = xcorr(x,x,option);
    Cxy = xcorr(x,y,option);
%     Cyy = xcorr(y,y,option);
    
    CC = Cxy ./ (std(x).*std(y));

end




