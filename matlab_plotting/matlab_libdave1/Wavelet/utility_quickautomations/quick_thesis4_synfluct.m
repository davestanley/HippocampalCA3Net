

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

% figure;
% eval (['bar_set = [icsyngap_avg; fb0_onlyion' sf_temp '; ic_unblk_avg; fb1s_stoch' sf_temp '];'])
eval (['bar_set = [ic_unblk_avg,' ...
                ' 0;' ...
                ' fb1s_nml_stoch' sf_temp ', '...
                ' fb1s_nml_det' sf_temp '; '...
                ' fb2sonly_nml_stoch' sf_temp ', '...
                ' fb2sonly_nml_det' sf_temp '; '...
                ' fb3s_slow_stoch' sf_temp ', '...
                ' fb3s_slow_det' sf_temp '; '...
                ' fb4sonly_slow_stoch' sf_temp ', '...
                ' fb4sonly_slow_det' sf_temp '];']);

% expplot = [1 3];
% modplot = [2 4];
% bar (expplot,bar_set(expplot));
% bar (modplot,bar_set(modplot));

colormap summer
bar (bar_set)
hold on;
clear expplot
clear modplot


if (include_error)
    
    sf_temp = stats_suffix;
    sf_temp = [sf_temp 'err'];
    eval (['errorbar_set = [ic_unblk_sterr,' ...
                ' 0;' ...
                ' fb1s_nml_stoch' sf_temp ', '...
                ' fb1s_nml_det' sf_temp '; '...
                ' fb2sonly_nml_stoch' sf_temp ', '...
                ' fb2sonly_nml_det' sf_temp '; '...
                ' fb3s_slow_stoch' sf_temp ', '...
                ' fb3s_slow_det' sf_temp '; '...
                ' fb4sonly_slow_stoch' sf_temp ', '...
                ' fb4sonly_slow_det' sf_temp '];']);

    errorbar ([0.85, 1.15; 1.85, 2.15; 2.85, 3.15; 3.85, 4.15; 4.85, 5.15], bar_set,errorbar_set,'ko');
else
    errorbar ([0.85, 1.15; 1.85, 2.15; 2.85, 3.15; 3.85, 4.15], bar_set, [icsyngap_sterr; 0; ic_unblk_sterr;0;0;0;0;0;0] ,'ko');
end


xlabel_arr = {'exp', 'nml', 'nml det ion', 'slow', 'slow det ion'};
set(gca,'XTick',1:length(xlabel_arr))
set(gca,'XTickLabel',xlabel_arr, 'FontSize', 20)
title('Probability Density Function','FontSize', 20);
legend ('stoch synapses','det synapses');