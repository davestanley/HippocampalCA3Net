

function [y] = daveMVAVG (x,N)


    usenewscheme = 1;


    if usenewscheme

        N = floor(N); % Make sure N is an integer
        N = 2*ceil(N/2)-1; % Make N odd
        Nhalf = floor(N / 2);
        x = x(:)';
        lenx = length(x);
        extendo = ones(1,Nhalf);
        extendo = extendo * mean(x);
        x = [extendo x extendo];

        a = 1;
        b = ones(1,N)/N;
    %     b = zeros(1,N); b(3) = 1; % Testing

        y = filter(b,a,x);
        y = wkeep(y, lenx, 'r');

    %     y = y(floor(N/2)+1:(end-floor(N/2)-1));

    else

    % % % %  OLD CODE! % % % 
        N = floor(N); % Make sure N is an integer
        N = 2*ceil(N/2)-1; % Make N odd
        x = x(:)';
        extendo = ones(1,N);
        extendo = extendo * mean(x);
        x = [x extendo];

        a = 1;
        b = ones(1,N)/N;
    %     b = zeros(1,N); b(3) = 1; % Testing

        y = filter(b,a,x);

        y = y(floor(N/2)+1:(end-floor(N/2)-1));


    end
    
end