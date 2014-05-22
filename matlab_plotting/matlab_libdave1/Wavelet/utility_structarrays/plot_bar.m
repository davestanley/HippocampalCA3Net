


function handles = plot_bar (bar_set, errorbar_set, xlabel_arr, leg_arr)

    colormap summer
    colormap (flipud(wkeep(gray(20),[10 3])));
%     colormap gray
%     bar (bar_set,'FaceColor',[0.9529 0.8706 0.7333]);
    handles.bars = bar (bar_set);
    
    hold on;


    if exist('errorbar_set','var')
        if size(errorbar_set,1) == 1
            errorbar (bar_set,errorbar_set,'k', 'linestyle', 'none', 'linewidth', 1);
        else
            numbars = size(errorbar_set, 2);
            for i = 1:numbars
                x =get(get(handles.bars(i),'children'), 'xdata');
                x = mean(x([1 3],:));
                handles.errors(i) = errorbar(x, bar_set(:,i), errorbar_set(:,i), 'k', 'linestyle', 'none', 'linewidth', 1);
            end
        end
    end
    
%     % Plot erros
% 	for i = 1:numbars
% 		x =get(get(handles.bars(i),'children'), 'xdata');
% 		x = mean(x([1 3],:));
% 		handles.errors(i) = errorbar(x, barvalues(:,i), errors(:,i), 'k', 'linestyle', 'none', 'linewidth', outline_width);
% 		ymax = max([ymax; barvalues(:,i)+errors(:,i)]);
% 	end
%     
    
    if exist('leg_arr','var');
        legend (leg_arr);
    end

    % xlabel_arr = {'Ca','Na','K_DR','K_A','K_C','K_AHP','K_Cdet','K_AHPdet','K_Ccc','K_AHPcc'};

    set(gca,'XTick',1:length(xlabel_arr))
    set(gca,'XTickLabel',xlabel_arr, 'FontSize', 10)

end






% % stats_suffix = '.general_beta_est.beta_est';
% 
% include_error = 1;
% % 
% % sf_temp = stats_suffix;
% % name_arr = {'ic1syngap'; 'ic2syngap'; 'ic3syngap'; 'ic4syngap'; 'ic5gapsyn'; 'ic6gapsyn'; 'ic7gapsyn'; 'ic9gapsyn'};
% % batch_avg;
% % icsyngap_avg = abs(avg);
% % % icsyngap_sterr = sterr;
% % icsyngap_sterr = max(sterr,avg_spread);
% % 
% % name_arr = {'ic5gap'; 'ic6gap'; 'ic7gap'; 'ic9gap'};
% % batch_avg;
% % ic_unblk_avg = abs(avg);
% % % ic_unblk_sterr = sterr;
% % ic_unblk_sterr = max(sterr,avg_spread);
% 
% if (invert_plot)
%     sf_temp = [sf_temp '*-1']; 
% end
% 
% 
% figure;
% sf_temp = stats_suffix;
% eval (['bar_set = [pyrIC04g_allmarkov_Ca' sf_temp '; '...
%                 ' pyrIC04g_allmarkov_Na' sf_temp '; '...
%                 ' pyrIC04g_allmarkov_K_DR' sf_temp '; '...
%                 ' pyrIC04g_allmarkov_K_A' sf_temp '; '...
%                 ' pyrIC04g_allmarkov_K_C' sf_temp '; '...
%                 ' pyrIC04g_allmarkov_K_AHP' sf_temp '; '...
%                 ' pyrIC04e_K_C_det_I' sf_temp '; '...
%                 ' pyrIC04f_K_AHP_det_I' sf_temp '; '...
%                 ' pyrIC04h_allmarkov_CaClamp_K_C' sf_temp '; '...
%                 ' pyrIC04h_allmarkov_CaClamp_K_AHP' sf_temp '];']);
%             
% colormap summer
% bar (bar_set);
% hold on;
% 
% 
% if (include_error)
%     
%     sf_temp = stats_suffix;
%     sf_temp = [sf_temp 'err'];
%     eval (['errorbar_set = [pyrIC04g_allmarkov_Ca' sf_temp '; '...
%                 ' pyrIC04g_allmarkov_Na' sf_temp '; '...
%                 ' pyrIC04g_allmarkov_K_DR' sf_temp '; '...
%                 ' pyrIC04g_allmarkov_K_A' sf_temp '; '...
%                 ' pyrIC04g_allmarkov_K_C' sf_temp '; '...
%                 ' pyrIC04g_allmarkov_K_AHP' sf_temp '; '...
%                 ' pyrIC04e_K_C_det_I' sf_temp '; '...
%                 ' pyrIC04f_K_AHP_det_I' sf_temp '; '...
%                 ' pyrIC04h_allmarkov_CaClamp_K_C' sf_temp '; '...
%                 ' pyrIC04h_allmarkov_CaClamp_K_AHP' sf_temp '];']);
% 
%     errorbar (bar_set,errorbar_set,'ko');
% else
%     errorbar (bar_set, [icsyngap_sterr; 0; ic_unblk_sterr;0;0;0;0;0;0] ,'ko');
% end
% 
% 
% xlabel_arr = {'Ca','Na','K_DR','K_A','K_C','K_AHP','K_Cdet','K_AHPdet','K_Ccc','K_AHPcc'};
% 
% set(gca,'XTick',1:length(xlabel_arr))
% set(gca,'XTickLabel',xlabel_arr, 'FontSize', 10)
% title('Probability Density Function');