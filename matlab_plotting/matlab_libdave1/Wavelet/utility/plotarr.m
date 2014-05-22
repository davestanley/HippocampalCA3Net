
function plotarr (s, colour)

    if nargin == 1
        plot (s(:,1),s(:,2));
    elseif nargin == 2
        plot (s(:,1),s(:,2),colour);
    else
        fprintf('invalid entry');
    end
            

end