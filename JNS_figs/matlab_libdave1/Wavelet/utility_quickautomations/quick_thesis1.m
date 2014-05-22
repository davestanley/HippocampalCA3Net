

% stats_suffix = '.general_beta_est.beta_est';

include_error = 1;

sf_temp = stats_suffix;
name_arr = {'ic1syngap'; 'ic2syngap'; 'ic3syngap'; 'ic4syngap'; 'ic5gapsyn'; 'ic6gapsyn'; 'ic7gapsyn'; 'ic9gapsyn'};
batch_avg;
icsyngap_avg = abs(avg);
% icsyngap_sterr = sterr;
icsyngap_sterr = max(sterr,avg_spread);

name_arr = {'ic5gap'; 'ic6gap'; 'ic7gap'; 'ic9gap'};
batch_avg;
ic_unblk_avg = abs(avg);
% ic_unblk_sterr = sterr;
ic_unblk_sterr = max(sterr,avg_spread);

if (invert_plot)
    sf_temp = [sf_temp '*-1']; 
end

figure;
% eval (['bar_set = [icsyngap_avg; fb0_onlyion' sf_temp '; ic_unblk_avg; fb1s_stoch' sf_temp '];'])
eval (['bar_set = [ic5gapsyn' sf_temp '; '...
                ' ic6gapsyn' sf_temp '; '...
                ' ic7gapsyn' sf_temp '; '...
                ' ic9gapsyn' sf_temp '; '...
                ' fb21_1_1' sf_temp '; '...
                ' ic5gap' sf_temp '; '...
                ' ic6gap' sf_temp '; '...
                ' ic7gap' sf_temp '; '...
                ' ic9gap' sf_temp '; '...
                ' fb1s_nml_stoch' sf_temp '];'])


bar (bar_set,'w');
hold on;


if (include_error)
    
    sf_temp = stats_suffix;
    sf_temp = [sf_temp 'err'];
    eval (['errorbar_set = [ic5gapsyn' sf_temp '; '...
                ' ic6gapsyn' sf_temp '; '...
                ' ic7gapsyn' sf_temp '; '...
                ' ic9gapsyn' sf_temp '; '...
                ' fb21_1_1' sf_temp '; '...
                ' ic5gap' sf_temp '; '...
                ' ic6gap' sf_temp '; '...
                ' ic7gap' sf_temp '; '...
                ' ic9gap' sf_temp '; '...
                ' fb1s_nml_stoch' sf_temp '];'])

    errorbar (bar_set,errorbar_set,'ko');
else
    errorbar (bar_set, [icsyngap_sterr; 0; ic_unblk_sterr;0;0;0;0;0;0] ,'ko');
end


xlabel_arr = {'ic5gapsyn';'ic6gapsyn';'ic7gapsyn';'ic9gapsyn';'fb21_1_1'; ...
    'ic5gap';'ic6gap';'ic7gap';'ic9gap'; ...
    'fb1s_nml_stoch'};
set(gca,'XTick',1:length(xlabel_arr))
set(gca,'XTickLabel',xlabel_arr, 'FontSize', 8)
title('Probability Density Function');