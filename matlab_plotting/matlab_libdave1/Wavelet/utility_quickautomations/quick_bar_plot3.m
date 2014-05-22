

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
                '; fb5sb_stoch_defaulttest' sf_temp ...
                '; fb5s_stoch_noAMPA' sf_temp ...
                '; fb2s_det' sf_temp ...
                '; fb3sonly_stoch' sf_temp ...
                '; fb4sonly_det' sf_temp ...
                '];'])
bar (bar_set,'w');
hold on;


if (include_error)
    
    sf_temp = stats_suffix;
    sf_temp = [sf_temp 'err'];

    eval (['errorbar_set = [icsyngap_std; fb0_onlyion' sf_temp '; ic_unblk_std; fb1s_stoch' sf_temp ...
                    '; fb5sb_stoch_defaulttest' sf_temp ...
                    '; fb5s_stoch_noAMPA' sf_temp ...
                    '; fb2s_det' sf_temp ...
                    '; fb3sonly_stoch' sf_temp ...
                    '; fb4sonly_det' sf_temp ...
                    '];'])

    errorbar (bar_set,errorbar_set,'ko');
else
    errorbar (bar_set, [icsyngap_std; 0; ic_unblk_std;0;0;0;0;0;0] ,'ko');
end


xlabel_arr = {'e syngap';'ms syngap';'e acsf';'ms acsf'; 'ms acsf2'; 'ms acsf noAMPA'; 'md acsf'; 'ms onlysyn'; 'md onlysyn'};
set(gca,'XTick',1:length(xlabel_arr))
set(gca,'XTickLabel',xlabel_arr, 'FontSize', 8)
title('Probability Density Function');