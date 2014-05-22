

function [int] = confidence(data,alpha)

    % Description
    % CONFIDENCE        [int] = confidence(data,alpha)
    % Calculates confidence intervals on a given set of data
    % data = input data
    % alpha = 1-confidence interval (i.e. 0.05 = 95% confidence)
    %
    % Dave Stanley dastanley@ufl.edu 2013-03-19

    if nargin < 2
        alpha = 0.05;
    end


    x = norminv((2-alpha)/2,0,1);
    check = 1 - (normcdf(x,0,1) - normcdf(-x,0,1));     % Check area outside PDF is equal to alpha
    
    SEM = std(data) / sqrt(length(data));
    int = (SEM * x);   % Scale standard deviation of mean by x to get 95% confidence interval
    

end
