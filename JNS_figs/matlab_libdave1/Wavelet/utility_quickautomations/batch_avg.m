

% Inputs:
% -------
% name_arr:         string array containing the structure names
% stats_suffix:     string containing the desired statistic within the
%                       structure tree to average
% include error:    specify this if you want to calculate the error
%                       associated with the variables as well


% Outputs:
% --------
% avg:              average
% sterr:            standard deviation -- really, I am actually changing
%                       this to be standard errpr
% avg_spread        average spread of the data
% y_val:            array of stats




% % Example code
% name_arr = {'ic1syngap'; 'ic2syngap'; 'ic3syngap'};
% stats_suffix = '.statsdata.std';

plotting = 0;

y = [];         % Clear cell arrays
y_val = [];
y_err = [];

inp_arr = {};
for i = 1:length(name_arr)
    inp_arr {i} = [name_arr{i} stats_suffix];
end
command = 'y = [y x];';
batch_cmd;                  % Make an array of the chosen values
y_val = y;
avg = mean (y_val);
sterr = std (y_val) / length(y_val);        % Standard error in the mean due to cell-to-cell variation
% stdev = std (y_val);        % Uncomment to use standard deviation instead. This is the cell-to-cell variation



if (include_error)
    inp_arr = {};
    for i = 1:length(name_arr)
        inp_arr {i} = [name_arr{i} stats_suffix 'err'];
    end
    y = [];
    command = 'y = [y x];';
    batch_cmd;                  % Make an array of the chosen values
    y_err = y;
    avg_spread = sum((y_err).^2) / length(y_err);
                                    % This is the error in the mean due to the
                                    % average spread in the data amongst
                                    % individual cells.
                                    % If there is a low cell-to-cell
                                    % variation, we should use this quantity
                                    % instead.
end

if plotting
    figure;
    bar(y_val,'y');
    hold on;
    errorbar(y_val,y_err,'ko');
end

clear y inp_arr;

