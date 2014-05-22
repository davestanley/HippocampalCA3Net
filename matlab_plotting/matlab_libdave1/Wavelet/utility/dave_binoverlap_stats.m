
function [output_mean output_sterr] = dave_binoverlap_stats (t_input, x_input, bin_duration, command)
% Bin duration, t_input in equivalent units (preferrably seconds)
% command should be the command string as a function of x and t

tstep = t_input(2)-t_input(1);

length_t = length(t_input);
length_bin = round(bin_duration/tstep);

if (length_bin > length_t)
    'Bin duration is longer than dataset. Decreasing bin size'
	length_bin = length_t;
    
end



t=t_input(1:length_bin); x=x_input(1:length_bin);
eval (['output_bin = ' command ';']);  % Get an estimate of the output size
output_mean = zeros(size(output_bin, 1),size(output_bin,2));
output_std = output_mean;

curr_index=1;
nbins = 0;
while (curr_index+length_bin-1 <= length(x_input))
    
    nbins = nbins + 1;
    x = x_input((curr_index):(curr_index+length_bin-1));
    t = (0:(length_bin-1))*tstep;
    eval (['output_bin = ' command ';']);
    
    output{nbins} = output_bin;

    curr_index = curr_index + round(length_bin/2);
end

% Get mean
for i = 1:length(output)
    output_mean = output_mean + output{i};
end
output_mean = output_mean / nbins;

% Get stdev
for i = 1:length(output)
    output_std = output_std + (output{i} - output_mean).^2;
end
output_std = (output_std / (nbins-1)).^(1/2);                  % For unbiased estimator
output_sterr = output_std / nbins;



fprintf ('Number of bins used to get stats: %d\n', nbins);

end


