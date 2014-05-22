
function plotds_range (x, y, colour,ds,range)

    if nargin == 1
        plot(x(range));
    elseif nargin == 2
        plot(x(range),y(range));
    elseif nargin == 3
        plot(x(range),y(range),colour)
    else
        plot(downsample(x(range),ds),downsample(y(range),ds),colour);
    end
            

end