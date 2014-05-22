
function plotds2 (x, y, ds, colour)


    if nargin == 4
       plot(downsample(x,ds),downsample(y,ds),colour); 
    end
    
    if nargin == 3
        plot(downsample(x,ds),downsample(y,ds));
    end
    
    if nargin == 2
        plot(x,y);
    end
    
    if nargin == 1
        plot(y);
    end
            

end