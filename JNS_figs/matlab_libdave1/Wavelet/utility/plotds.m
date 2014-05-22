
function plotds (x, y, colour,ds)

    if nargin == 1
        plot(x);
    elseif nargin == 2
        plot(x,y);
    elseif nargin == 3
        plot(x,y,colour)
    else
        plot(downsample(x,ds),downsample(y,ds),colour);
    end
            

end