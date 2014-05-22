

% stats_suffix = '.general_beta_est.beta_est';

include_error = 1;

sf_temp = stats_suffix;
name_arr = {'ic1syngap'; 'ic2syngap'; 'ic3syngap'; 'ic4syngap'; 'ic5gapsyn'; 'ic6gapsyn'; 'ic7gapsyn'; 'ic8gapsyn'; 'ic9gapsyn'};
batch_avg;
icsyngap_avg = abs(avg); icsyngap_std = stdev;
% icsyngap_std = max(stdev,avg_spread);

name_arr = {'ic5gap'; 'ic6gap'; 'ic7gap'; 'ic8gap'; 'ic9gap'};
batch_avg;
ic_unblk_avg = abs(avg); ic_unblk_std = stdev;
% ic_unblk_std = max(stdev,avg_spread);

if (invert_plot)
    sf_temp = [sf_temp '*-1']; 
end

figure;
% eval (['bar_set = [icsyngap_avg; fb0_onlyion' sf_temp '; ic_unblk_avg; fb1s_stoch' sf_temp '];'])
eval (['bar_set = [icsyngap_avg; fb0_onlyion' sf_temp '; ic_unblk_avg; fb1s_stoch' sf_temp ...
                '; fb0_onlyion1x' sf_temp ...
                '; fb0_onlyion2x' sf_temp ...
                '; fb0_onlyion4x' sf_temp ...
                '; fb0_onlyion_slowCa' sf_temp ...
                '; fb0_onlyion_skinner' sf_temp ...
                '];'])
bar (bar_set,'w');
hold on;


if (include_error)
    
    sf_temp = stats_suffix;
    sf_temp = [sf_temp 'err'];

    eval (['errorbar_set = [icsyngap_std; fb0_onlyion' sf_temp '; ic_unblk_std; fb1s_stoch' sf_temp ...
                    '; fb0_onlyion1x' sf_temp ...
                    '; fb0_onlyion2x' sf_temp ...
                    '; fb0_onlyion4x' sf_temp ...
                    '; fb0_onlyion_slowCa' sf_temp ...
                    '; fb0_onlyion_skinner' sf_temp ...
                    '];'])

    errorbar (bar_set,errorbar_set,'ko');
else
    errorbar (bar_set, [icsyngap_std; 0; ic_unblk_std;0;0;0;0;0;0] ,'ko');
end


xlabel_arr = {'e syngap';'ms syngap';'e acsf';'ms acsf'; '1z'; '2x'; '4x'; 'slowCa'; 'Skinner'};
set(gca,'XTick',1:length(xlabel_arr))
set(gca,'XTickLabel',xlabel_arr, 'FontSize', 8)
title('Probability Density Function');