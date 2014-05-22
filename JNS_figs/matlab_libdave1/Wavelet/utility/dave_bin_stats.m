
function [output] = dave_bin_stats (t_input, x_input, bin_duration, command)

tstep = t_input(2)-t_input(1);

length_t = length(t_input);
length_bin = round(bin_duration/tstep);

if (length_bin > length_t)
    'Bin duration is longer than dataset. Decreasing bin size'
	length_bin = length_t;
    
end

nbins = floor(length_t/length_bin)

t=t_input(1:length_bin); x=x_input(1:length_bin);
eval (['output_bin = ' command ';']);  % Get an estimate of the size
output = zeros(size(output_bin, 1),size(output_bin,2));

for i=1:nbins
    t = (0:(length_bin-1))*tstep;
    x = x_input( ((i-1)*(length_bin) + 1):(i*length_bin) );
    
    eval (['output_bin = ' command ';']);
    output = output + output_bin;

end

output = output / nbins;

end