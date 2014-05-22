

% stats_suffix = '.general_beta_est.beta_est';

include_error = 1;
sf_temp = stats_suffix;
name_arr = {'p1syngap'; 'p2syngap'; 'p3syngap'; 'p4syngap'; 'p5gapsyn'; 'p6gapsyn'; 'p7gapsyn'; 'p8gapsyn'; 'p9gapsyn'};
batch_avg;
psyngap_avg = abs(avg);
% icsyngap_sterr = sterr;
psyngap_sterr = max(sterr,avg_spread);

if (invert_plot)
    sf_temp = [sf_temp '*-1']; 
end

figure;
% eval (['bar_set = [icsyngap_avg; fb0_onlyion' sf_temp '; ic_unblk_avg; fb1s_stoch' sf_temp '];'])
eval (['bar_set = [psyngap_avg;' ...
                ' pyr01f_K_AHP_det' sf_temp '; '...
                ' pyr01h_allmarkov_constCa' sf_temp '; '...
                ' pyr01g_allmarkov' sf_temp '];'])

bar (bar_set,'w');
hold on;


if (include_error)
    
    sf_temp = stats_suffix;
    sf_temp = [sf_temp 'err'];
    eval (['errorbar_set = [psyngap_sterr;' ...
                ' pyr01f_K_AHP_det' sf_temp '; '...
                ' pyr01h_allmarkov_constCa' sf_temp '; '...
                ' pyr01g_allmarkov' sf_temp '];'])

    errorbar (bar_set,errorbar_set,'ko');
else
    errorbar (bar_set, [icsyngap_sterr; 0; ic_unblk_sterr;0;0;0;0;0;0] ,'ko');
end


xlabel_arr = {'pyramidal';'K AHP';
    'CaClamp';'allmarkov'};

set(gca,'XTick',1:length(xlabel_arr))
set(gca,'XTickLabel',xlabel_arr, 'FontSize', 8)
title('Probability Density Function');