
% This is the code used to generate model figures for J Neurophys paper %


% % % % % % % % % % % % % % % % % Preliminary figures for nature paper % % % % % % %
% clear; load wrkspc.mat

addpath(genpath(fullfile('..','matlab_libdave1')))
addpath(fullfile('.','funcs_supporting'));

reload = 0; % % % % Reload .mat files
plot_phases = 0;
    screen_phases=1;    % If error in curve fitting too high, or amplitude too low, do not count.
    
    
plot_daynight_shift = 1;    % Shifts x-axis on Fig1 and 2 to be from -6h to 18h; inserts black bar showing LD
linear_interp = 1;
if linear_interp            % Use linear interpolation for sensitivity plot
    linear_or_nearest='linear';
    fiterr_thresh=33;
    amperr_thresh=0.03;
else                        % Use nearest neighbour interpolation for sensplot
    linear_or_nearest='nearest';
    fiterr_thresh=10;
    amperr_thresh=0.05;
end

fig_default=1;
fig0=1; % Raw traces
fig1=1; % Firing rates all3 phase shift
fig2=1; % Singles
fig2b=1; % Singles merged
fig3=1; % Sensitivity
fig4_suppl=1; % Supplementary senstitivity analysis
fig9=1;


fig_default=0;
fig0=0; % Raw traces. (Uses sim0; path_raw)
% fig1=0; % Used in J Neurophys paper for modeling figure. (Uses sim1; path_cutfimbria)
fig2=0; % Used for J Neurophys paper - Singles. (sim2; path_singles)
fig2b=0; % Singles merged; basket cells only I presume. Not used in J NEurophys, but maybe used in Conference paper?
fig3=0; % (Uses sim3 and sim4. Mainly sim4. Sim3 is sensitivity analysis, methinks. Sim4 corresponds to path_senschop.)
fig4_suppl=0;
fig9=0;

if (fig4_suppl); fig3=1; end

% Paper_figs.m
path_raw = '../output_paperdata'; % Default
name_raw = 'wrkspc_mode3_trimmed.mat';
% path_raw = '../../Tamas_CA1/04_saguaro/03_Schaffersyn/S3i_longsingle';
% name_raw = 'wrkspc_redo.mat';
path_cutfimbria = path_raw;
name_cutfimbria = 'wrkspc_mode3.mat';
% path_singles = '../../Tamas_CA1/04_saguaro/03_Schaffersyn/S3i_longsingle';
% name_singles = 'wrkspc_redo.mat';
path_singles = path_raw;
name_singles = 'wrkspc_mode5.mat';

% path_sens_m2b='../Tamas_CA1//04_saguaro/03_Schaffersyn/S3hsens_205';
% name_sens_m2b='wrkspc_full_clean';
path_senschop=path_raw;
name_senschop='wrkspc_mode4';

if ~(reload)
    curr_dir = pwd;
    cd (path_raw);
    if ~exist('sim0','var');
        load(name_raw); 
        sim0 = sim_crop;
    end
    cd (curr_dir);

    curr_dir = pwd;
    cd (path_cutfimbria);
    if ~exist('sim1','var'); load(name_cutfimbria); sim1 = sim_clean; end
    cd (curr_dir);

    curr_dir = pwd;
    cd (path_singles);
    if ~exist('sim2','var'); load(name_singles); sim2 = sim_clean; end
    cd (curr_dir);
    
%     curr_dir = pwd;
%     cd (path_sens_m2b);
%     if ~exist('sim3','var'); load(name_sens_m2b); sim3 = sim_clean; end
%     cd (curr_dir);
    
    curr_dir = pwd;
    cd (path_senschop);
    if ~exist('sim4','var'); load(name_senschop); sim4 = sim_clean; end
    cd (curr_dir);
end


font_scaling_def = 0.5;
linewidth_def=2;
markersize_def=10;
FS_axislabels_def=30;
FS_axis_def=30;


if fig_default

end

set_values_multi=0;

if fig0
    font_scaling=0.5;
    linewidth=linewidth_def;
    markersize=markersize_def;
    FS_axislabels=FS_axislabels_def*font_scaling;
    FS_axis=FS_axis_def*font_scaling;

    curr_dir = pwd;
    cd (path_raw);
    if reload; load (name_raw); else sim=sim0;end
    cd (curr_dir);
    

    figure1 = figure;
    set (figure1, 'Position',[524 339 560*3/3 420*4/3]*font_scaling,'Color','w');
    h4 = gca;

%     set(h4,'OuterPosition',[0.1 0.0 0.9 1.0]);
%     set(h4,'Position',[0.570340909090909 0.075185492801772 0.334659090909091 0.439]);
%     leg1=legend('bc','msg','olm','pyr'); legend('boxoff'); set(leg1,'Position',[0.7244 0.6628 0.1252 0.264]);
%     annotation(figure1,'textbox',[0.01 0.67 0.05455 0.08571],'String',{'bc'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels);
%     annotation(figure1,'textbox',[0.01 0.52 0.05455 0.08571],'String',{'msg'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels);
%     annotation(figure1,'textbox',[0.01 0.33 0.05455 0.08571],'String',{'olm'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels);
%     annotation(figure1,'textbox',[0.01 0.17 0.05455 0.08571],'String',{'pyr'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels);
%     annotation(figure1,'textbox',[0.4895 0.3129 0.05455 0.08571],'String',{'bc'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels);
%     annotation(figure1,'textbox',[0.4895 0.2533 0.05455 0.08571],'String',{'msg'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels);
%     annotation(figure1,'textbox',[0.4895 0.1776 0.05455 0.08571],'String',{'olm'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels);
%     annotation(figure1,'textbox',[0.4895 0.1152 0.05455 0.08571],'String',{'pyr'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels);
%     set(h2,'OuterPosition',[0.385 0 0.63 1.0]);
    
    
    set_values=0
    
    
    sim_num=1;
    sim_num=sim_num+1;
    cell_range=1:4;
    time_range = (1:length(sim{sim_num}.time));

    plot_on=0;
    plot_traces = 1;
    plot_inputs = 0;
        
    plot_stats = ~plot_traces;
        plot_error = 1;
        plot_efield = 0;
        if plot_efield; cell_range = 1:11; end
        

    if plot_traces
       cell_range=[1:4];
       time_range=5;
       dat_fieldname_sing='column.hist.ct';
       datfield_t='column.hist.t';
       dat_fieldname_sing='column.sptr.ct';
       datfield_t='';
       %%%%%% TO DO: Fix KAPPA - It gives non-intuitive values for pyr
        %%% Are initial values biasing? Should I be chopping off some of the
        %%% initial data points?
        %%% Might also need to adjust bin size used by KAPPA.
    end
    cells_to_consider=[1]; % Number of cells of a given type to consider
%    sim_num=1; sim_num=sim_num+1;       % Varying SCN amp only; time=5 so everything is default
    sim_num=1; sim_num=sim_num+1;       % "Healthy case," time=5 (v close to default except EC input slightly off)
    time_range=5;
    plot_struct;
    plotmat_arr=[];
    plotmat_t_arr=[];
    
    for i = 1:length(plotmat)
        plotmat_arr = [plotmat_arr plotmat{i}(:,cells_to_consider)];
        plotmat_t_arr = [plotmat_t_arr plotmat_t{i}(:)];
        
    end
    cell_types = [1 2 3 4];   % Types of cells to consider - we want only pyr, OLM, and msGABA
    plotmat_arr = plotmat_arr(:,cell_types);
    plotmat_t_arr = plotmat_t_arr(:,cell_types);
    opt_struct.shift = -0.05;
    for i = 1:size(plotmat_arr, 2); plotmat_arr(:,i) = plotmat_arr(:,i) + (i-1)*opt_struct.shift; end % Shift data upwards
    
%     axes2 = axes('Parent',figure1,'Position',[0.4068 0.2286 0.2871 0.1857],...
%     'FontSize',12);
    axes(h4); 
    opt_struct.shift = -0.1;
%     plot_matrix(plotmat_t_arr, plotmat_arr,opt_struct,[],[],linewidth);
    plot(plotmat_t_arr, plotmat_arr*1e3,'k','LineWidth',1);
    xlabel('Time (sec)', 'FontSize',12);
    ylabel('Vm (V)', 'FontSize',12);
    set(gca, 'FontSize',12);
    axis([0 3 -250 25])

    ox=0.1; oy=-240; lenx=0.5; leny=20;     % x is 0.50sec=500msec; y is 20 mV
    plot_scale([(ox+lenx/2) oy], [1], [lenx],'k','sec','h')
    plot_scale([ox (oy+leny/2)], [1], [leny],'k','mV','v')
    set(h4,'Box','off');
    set(h4,'Visible','off');

end




if fig1
    font_scaling=font_scaling_def;
    linewidth=linewidth_def;
    markersize=markersize_def;
    FS_axislabels=FS_axislabels_def*font_scaling;
    FS_axis=FS_axis_def*font_scaling;

    curr_dir = pwd;
    cd (path_cutfimbria);
    if reload; load(name_cutfimbria); else sim=sim1;end
    cd (curr_dir);

    
    set_values=0
    
    sim_num=1;
    sim_num=sim_num+1;
    cell_range=1:4;
    time_range = (1:length(sim{sim_num}.time));

    plot_on=0;
    plot_traces = 0;
    plot_inputs = 0;
        
    plot_stats = ~plot_traces;
        plot_error = 1;
        plot_efield = 0;
        if plot_efield; cell_range = 1:11; end
        

    if plot_traces
       cell_range=[4];
       time_range=8;
       %%%%%% TO DO: Fix KAPPA - It gives non-intuitive values for pyr
        %%% Are initial values biasing? Should I be chopping off some of the
        %%% initial data points?
        %%% Might also need to adjust bin size used by KAPPA.
    end
    
    
    cells_to_consider=[1 2 3 4];
    sim_num=1; sim_num=sim_num+1;
    plot_struct; pm1=plotmat_arr(:,cells_to_consider); pmz1=plotmat_zeitgeber_arr(:,cells_to_consider); pm_err1=plotmat_ste_arr(:,cells_to_consider);
    sim_num=2; sim_num=sim_num+1;
    plot_struct; pm2=plotmat_arr(:,cells_to_consider); pmz2=plotmat_zeitgeber_arr(:,cells_to_consider); pm_err2=plotmat_ste_arr(:,cells_to_consider);
%     pm1(:,1) = pm1(:,1) * 25; pm1(:,2) = pm1(:,2) * 25; pm1(:,3) = pm1(:,3) * 25; pm1(:,4) = pm1(:,4) * 200;
%     pm2(:,1) = pm2(:,1) * 25; pm2(:,2) = pm2(:,2) * 25; pm2(:,3) = pm2(:,3) * 25; pm2(:,4) = pm2(:,4) * 200;
    
    % Plot both on a single graph
%     figure;
%     errorbar([pmz1 pmz2], [pm1 pm2], [pm_err1 pm_err2],':');
%     hold on;errorbar([pmz1], [pm1], [pm_err1]);

    
    pmz1 = [[pmz1-24];pmz1; [pmz1+24]];
    pm1 = [pm1; pm1; pm1];
    pm_err1 = [pm_err1; pm_err1; pm_err1];
    pmz2 = [[pmz2-24];pmz2; [pmz2+24]];
    pm2 = [pm2; pm2; pm2];
    pm_err2 = [pm_err2; pm_err2; pm_err2];
    
    index = find ((pmz1(:,1)>=0) .* (pmz1(:,1)<=36));
    pm1=pm1(index,:); pmz1 = pmz1(index,:); pm_err1 = pm_err1(index,:);
    index = find ((pmz2(:,1)>=0) .* (pmz2(:,1)<=36));
    pm2=pm2(index,:); pmz2 = pmz2(index,:); pm_err2 = pm_err2(index,:);
    
    %natureplot_for_hsp_plotyy
    %natureplot_for_hsp_plot
    
    figure1 = figure; set (figure1, 'Position',[524 339 560*3/3 420*4/3]*font_scaling,'Color','w');
    h1=gca; errorbar([pmz1], [pm1], [pm_err1],'LineWidth',2);
    figure1 = figure; set (figure1, 'Position',[524 339 560*3/3 420*4/3]*font_scaling,'Color','w');
    h2=gca; errorbar([ pmz2], [ pm2], [ pm_err2],'LineWidth',2);
%     set(h1,'OuterPosition',[0.00 0 0.4 1.0]);
%     set(h2,'OuterPosition',[0.5 0 0.5 1.0]);
    
%     annotation(figure1,'textbox',[0.07 0.92 0.05455 0.08571],'String',{'a'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels*2);
%     annotation(figure1,'textbox',[0.49 0.92 0.05455 0.08571],'String',{'b'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels*2);
%     annotation(figure1,'textbox',[0.07 0.44 0.05455 0.08571],'String',{'c'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels*2);
%     annotation(figure1,'textbox',[0.49 0.44 0.05455 0.08571],'String',{'d'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels*2);

    
    
%     title(['Plotting ' dat_fieldname_sing]);
    axes(h1);
%     xlabel('Time (hours)', 'FontSize',FS_axislabels);
%     ylabel('Firing rate (s^{-1})', 'FontSize',FS_axislabels);
    ylimits = get(gca,'YLim'); xlimits = get(gca,'XLim');
    axis([-2 24 ylimits(1)-1 17]);
    set(gca,'Box','off');
    set(gca, 'FontSize',FS_axis);
    if plot_daynight_shift
        axis([-0 36 ylimits(1)-1 ylimits(2)+4]);
        rectangle('Position',[-30 ylimits(1)-1 12 0.6],'FaceColor','k');
        rectangle('Position',[-18 ylimits(1)-1 12 0.6],'FaceColor','w');
        rectangle('Position',[-6 ylimits(1)-1 12 0.6],'FaceColor','k');
        rectangle('Position',[6 ylimits(1)-1 12 0.6],'FaceColor','w');
        rectangle('Position',[18 ylimits(1)-1 12 0.6],'FaceColor','k');
        rectangle('Position',[30 ylimits(1)-1 12 0.6],'FaceColor','w');
    end
    
    xlim= get(gca,'XLim');
    xtickarr = xlim(1):12:xlim(2);
    set(gca,'XTick',xtickarr,'XTickLabel',xtickarr);
    
    % % % Make all x-axis entries positive
    xlabelarr = get(gca,'XTickLabel');
    xlabelarr = str2num(xlabelarr);
%     xlabelarr = xlabelarr + 24;
    for ii = 1:length(xlabelarr)
        if xlabelarr(ii) < 0;
            xlabelarr(ii) = xlabelarr(ii) + 24;
        end
    end
    set(gca,'XTickLabel',num2str(xlabelarr));
    
    axes(h2);
%     xlabel('Time (hours)', 'FontSize',FS_axislabels);
    ylimits = get(gca,'YLim'); xlimits = get(gca,'XLim');
    axis([-2 24 ylimits(1)-1 17]);
    set(gca,'Box','off');
    set(gca, 'FontSize',FS_axis);
    leg1=legend('BC','MSG','O-LM','PYR');
    legend('boxoff');
    set (leg1,'FontSize',FS_axis);
    pos = get(leg1,'Position');
    set(leg1,'Position',[0.7317 0.7553 0.2289 0.2197]);

    if plot_daynight_shift
        axis([-0 36 ylimits(1)-1 ylimits(2)+4]);
        rectangle('Position',[-30 ylimits(1)-1 12 0.6],'FaceColor','k');
        rectangle('Position',[-18 ylimits(1)-1 12 0.6],'FaceColor','w');
        rectangle('Position',[-6 ylimits(1)-1 12 0.6],'FaceColor','k');
        rectangle('Position',[6 ylimits(1)-1 12 0.6],'FaceColor','w');
        rectangle('Position',[18 ylimits(1)-1 12 0.6],'FaceColor','k');
        rectangle('Position',[30 ylimits(1)-1 12 0.6],'FaceColor','w');
    end
    
    xlim= get(gca,'XLim');
    xtickarr = xlim(1):12:xlim(2);
    set(gca,'XTick',xtickarr,'XTickLabel',xtickarr);
    % % % Make all x-axis entries positive
    xlabelarr = get(gca,'XTickLabel');
    xlabelarr = str2num(xlabelarr);
%     xlabelarr = xlabelarr + 24;
    for ii = 1:length(xlabelarr)
        if xlabelarr(ii) < 0;
            xlabelarr(ii) = xlabelarr(ii) + 24;
        end
    end
    set(gca,'XTickLabel',num2str(xlabelarr));
    
    if (1)
%         h3 = axes('Parent',gcf,'Position',[0.2811 0.5818 0.1767 0.3768]);
%         compass_arr(h3, real(Z_arr(1,:)),imag(Z_arr(1,:)));
    end
    
    plot_healthy_on = 1; natureplot_with_scalebars
    plot_healthy_on = 0; natureplot_with_scalebars

end


if fig2
    font_scaling=0.5;
    linewidth=linewidth_def;
    markersize=markersize_def;
    FS_axislabels=FS_axislabels_def*font_scaling;
    FS_axis=FS_axis_def*font_scaling;

    
    curr_dir = pwd;
    cd (path_singles);
    if reload; load(name_singles); else sim=sim2;end
    cd (curr_dir);

    
    set_values=0;
    
    sim_num=0;
    sim_num=sim_num+1;
    cell_range=1:4;
    %time_range = (1:length(sim{sim_num}.time));

    plot_on=0;
    plot_traces = 0;
    plot_inputs = 0;
        
    plot_stats = ~plot_traces;
        plot_error = 1;
        plot_efield = 0;
        if plot_efield; cell_range = 1:11; end
        

    if plot_traces
       cell_range=[4];
       time_range=8;
       %%%%%% TO DO: Fix KAPPA - It gives non-intuitive values for pyr
        %%% Are initial values biasing? Should I be chopping off some of the
        %%% initial data points?
        %%% Might also need to adjust bin size used by KAPPA.
    end
    
    cells_to_consider=[1:4];
    sim_num=0; sim_num=sim_num+1;
    plot_struct; pm1=plotmat_arr(:,cells_to_consider); pmz1=plotmat_zeitgeber_arr(:,cells_to_consider); pm_err1=plotmat_ste_arr(:,cells_to_consider);
    sim_num=1; sim_num=sim_num+1;
    plot_struct; pm2=plotmat_arr(:,cells_to_consider); pmz2=plotmat_zeitgeber_arr(:,cells_to_consider); pm_err2=plotmat_ste_arr(:,cells_to_consider);
    sim_num=2; sim_num=sim_num+1;
    plot_struct; pm3=plotmat_arr(:,cells_to_consider); pmz3=plotmat_zeitgeber_arr(:,cells_to_consider); pm_err3=plotmat_ste_arr(:,cells_to_consider);
%     figure;
%     errorbar([pmz1 pmz2], [pm1 pm2], [pm_err1 pm_err2],':');
%     hold on;errorbar([pmz1], [pm1], [pm_err1]);
    
%     figure; errorbar([pmz1], [pm1], [pm_err1],'LineWidth',1);
%     hold on; errorbar([ pmz2], [ pm2], [ pm_err2],':','LineWidth',2);
%     hold on; errorbar([ pmz3], [ pm3], [ pm_err3],':','LineWidth',2);
%     legend('b1','msg1','olm1','pyr1','b2','msg2','olm2','pyr2');
%     title(['Plotting ' dat_fieldname_sing]);
%     figure1 = figure;

    % Plot phases!
    if plot_phases
        phi_arr=[]; A_arr=[]; perr_arr=[];
        phi=[]; A=[]; perr=[];
        for ii = cells_to_consider
            [A(ii) phi(ii) mse_temp perr(ii)] = fit_sinwave(pmz1(:,ii), pm1(:,ii), 24);
        end
        phi_arr = [phi_arr; phi]; A_arr = [A_arr; A]; perr_arr = [perr_arr; perr];

        phi=[]; A=[]; perr=[];
        for ii = cells_to_consider
            [A(ii) phi(ii) mse_temp perr(ii)] = fit_sinwave(pmz2(:,ii), pm2(:,ii), 24);
        end
        phi_arr = [phi_arr; phi]; A_arr = [A_arr; A]; perr_arr = [perr_arr; perr];

        phi=[]; A=[]; perr=[];
        for ii = cells_to_consider
            [A(ii) phi(ii) mse_temp perr(ii)] = fit_sinwave(pmz3(:,ii), pm3(:,ii), 24);
        end
        phi_arr = [phi_arr; phi]; A_arr = [A_arr; A]; perr_arr = [perr_arr; perr];
        
        mean_firing_rate = [mean(pm1); mean(pm2); mean(pm3)];
        
        phi_arr_screened = phi_arr;
        [rows cols] = size(phi_arr);
        for ii = 1:rows
            for jj = 1:cols
                Cerr1=0;Cerr2=0;
                if perr_arr(ii,jj) > fiterr_thresh; Cerr1 = 1; end
                if mean_firing_rate(ii,jj)/A_arr(ii,jj) < amperr_thresh; Cerr2=1; end
                if ((Cerr1 || Cerr2) && (screen_phases))
                    phi_arr_screened(ii,jj) = Inf;
                end
            end
        end
        

        figure1 = figure;
        set (figure1, 'Position',[524 339 560 420],'Color','w');
        
        phi_arr2 = phi_arr_screened;
        phi_arr2 = fliplr(flipud(phi_arr2));
        corder = get(0,'DefaultAxesColorOrder');
        colormap (flipud(corder(1:size(phi_arr2,2),:)))
        
        h_bar= barh(phi_arr2);
        set (h_bar,'BaseValue',-6);
        rectangle('Position',[-6 0.5 12 0.1],'FaceColor','k');
        axis([-6 18 0.5 3.5]);
        
        ylabelarr = {'Schaffer','Fimbria','mel'};
        ylabelarr = fliplr (ylabelarr);
%         set(gca,'YTick',1:length(ylabelarr))
        set(gca,'YTickLabel',ylabelarr, 'FontSize', 10);
        
        
        
        figure1 = figure;
        set (figure1, 'Position',[524 339 560 420],'Color','w');
        phi_arr2 = phi_arr_screened';
        phi_arr2 = fliplr(flipud(phi_arr2));
        h_bar= barh(phi_arr2);
        set (h_bar,'BaseValue',-6);
        rectangle('Position',[-6 0.5 12 0.1],'FaceColor','k');
        axis([-6 18 0.5 4.5]);
        
        ylabelarr = {'bc','msg','olm','pyr'};
        ylabelarr = fliplr (ylabelarr);
%         set(gca,'YTick',1:length(ylabelarr))
        set(gca,'YTickLabel',ylabelarr, 'FontSize', 10);
        
    end
    if plot_daynight_shift
        pmz1 = [[pmz1-24];pmz1; [pmz1+24]];
        pm1 = [pm1; pm1; pm1];
        pm_err1 = [pm_err1; pm_err1; pm_err1];
        pmz2 = [[pmz2-24];pmz2; [pmz2+24]];
        pm2 = [pm2; pm2; pm2];
        pm_err2 = [pm_err2; pm_err2; pm_err2];
        pmz3 = [[pmz3-24];pmz3; [pmz3+24]];
        pm3 = [pm3; pm3; pm3];
        pm_err3 = [pm_err3; pm_err3; pm_err3];
    end
    
    figure1 = figure;
    set (figure1, 'Position',[524 339 560*3/3 420*4/3]*font_scaling,'Color','w');
%     h1=subplot(111); 
    figure2 = figure;
    set (figure2, 'Position',[524 339 560*3/3 420*4/3]*font_scaling,'Color','w');
%     h2=subplot(111); 
    figure3 = figure;
    set (figure3, 'Position',[524 339 560*3/3 420*4/3]*font_scaling,'Color','w');
%     h3=subplot(111); 
    figure4 = figure;
    set (figure4, 'Position',[524 339 560*3/3 420*4/3]*font_scaling,'Color','w');
%     h4=subplot(111); 
%     yy=get(h1,'OuterPosition'); set(h1,'OuterPosition',[ yy(2) yy(3) yy(4)]);
%     set(h2,'OuterPosition',[0.5 0 0.5 1.0]);
    
%     annotation(figure1,'textbox',[0.03 0.92 0.05455 0.08571],'String',{'a'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels*2);
%     annotation(figure1,'textbox',[0.48 0.92 0.05455 0.08571],'String',{'b'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels*2);
%     annotation(figure1,'textbox',[0.03 0.45 0.05455 0.08571],'String',{'c'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels*2);
%     annotation(figure1,'textbox',[0.48 0.45 0.05455 0.08571],'String',{'d'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels*2);

    figure(figure2); errorbar([pmz1 ], [pm1 ], [pm_err1 ],'LineWidth',linewidth)
    figure(figure3); errorbar([pmz2 ], [pm2 ], [pm_err2 ],'LineWidth',linewidth)
    figure(figure4); errorbar([pmz3], [pm3], [pm_err3],'LineWidth',linewidth)

    figure(figure2)
    ylimits = get(gca,'YLim'); xlimits = get(gca,'XLim');
    axis([0 36 ylimits(1)-1 ylimits(2)+2.5]);
    leg1=legend('BC','MSG','O-LM','PYR'); legend('boxoff'); set(leg1,'Position',[0.7494 0.7754 0.1869 0.1688]);
%     xlabel('Time (hours)', 'FontSize',FS_axislabels);
%     ylabel('Firing rate (s^{-1})', 'FontSize',FS_axislabels);
    set(gca, 'FontSize',FS_axis,'Box','off');
    rectangle('Position',[-30 ylimits(1)-1 12 0.4],'FaceColor','k');
    rectangle('Position',[-18 ylimits(1)-1 12 0.4],'FaceColor','w');
    rectangle('Position',[-6 ylimits(1)-1 12 0.4],'FaceColor','k');
    rectangle('Position',[6 ylimits(1)-1 12 0.4],'FaceColor','w');
    rectangle('Position',[18 ylimits(1)-1 12 0.4],'FaceColor','k');
    rectangle('Position',[30 ylimits(1)-1 12 0.4],'FaceColor','w');
    xlim= get(gca,'XLim');
    xtickarr = xlim(1):12:xlim(2);
    set(gca,'XTick',xtickarr,'XTickLabel',xtickarr);
    figure(figure3)
    ylimits = get(gca,'YLim'); xlimits = get(gca,'XLim');
    axis([0 36 ylimits(1)-1 ylimits(2)+1]);
%     xlabel('Time (hours)', 'FontSize',FS_axislabels);
%     ylabel('Firing rate (s^{-1})', 'FontSize',FS_axislabels);
    set(gca, 'FontSize',FS_axis,'Box','off');
    rectangle('Position',[-30 ylimits(1)-1 12 0.6],'FaceColor','k');
    rectangle('Position',[-18 ylimits(1)-1 12 0.6],'FaceColor','w');
    rectangle('Position',[-6 ylimits(1)-1 12 0.6],'FaceColor','k');
    rectangle('Position',[6 ylimits(1)-1 12 0.6],'FaceColor','w');
    rectangle('Position',[18 ylimits(1)-1 12 0.6],'FaceColor','k');
    rectangle('Position',[30 ylimits(1)-1 12 0.6],'FaceColor','w');
    xlim= get(gca,'XLim');
    xtickarr = xlim(1):12:xlim(2);
    set(gca,'XTick',xtickarr,'XTickLabel',xtickarr);
    figure(figure4)
    ylimits = get(gca,'YLim'); xlimits = get(gca,'XLim');
    axis([0 36 ylimits(1)-1 ylimits(2)+1]);
%     xlabel('Time (hours)', 'FontSize',FS_axislabels);
%     ylabel('Firing rate (s^{-1})', 'FontSize',FS_axislabels);
    set(gca, 'FontSize',FS_axis,'Box','off');
    rectangle('Position',[-30 ylimits(1)-1 12 0.4],'FaceColor','k');
    rectangle('Position',[-18 ylimits(1)-1 12 0.4],'FaceColor','w');
    rectangle('Position',[-6 ylimits(1)-1 12 0.4],'FaceColor','k');
    rectangle('Position',[6 ylimits(1)-1 12 0.4],'FaceColor','w');
    rectangle('Position',[18 ylimits(1)-1 12 0.4],'FaceColor','k');
    rectangle('Position',[30 ylimits(1)-1 12 0.4],'FaceColor','w');
    xlim= get(gca,'XLim');
    xtickarr = xlim(1):12:xlim(2);
    set(gca,'XTick',xtickarr,'XTickLabel',xtickarr);

    
    
    curr_dir = pwd;
    cd (path_cutfimbria);
    if reload; load(name_cutfimbria); else sim=sim1;end
    cd (curr_dir);
    
    set_values=0;
    
    sim_num=0;
    sim_num=sim_num+1;
    cell_range=1:4;
    time_range = (1:length(sim{sim_num}.time));

    plot_on=0;
    plot_traces = 0;
    plot_inputs = 1;
        
    plot_stats = 0;
        plot_error = 1;
        plot_efield = 0;
        if plot_efield; cell_range = 1:11; end
        

    if plot_traces
       cell_range=[4];
       time_range=8;
       %%%%%% TO DO: Fix KAPPA - It gives non-intuitive values for pyr
        %%% Are initial values biasing? Should I be chopping off some of the
        %%% initial data points?
        %%% Might also need to adjust bin size used by KAPPA.
    end
    
    dat_fieldname_sing_arr = {'EC_val','SCN_val','mel_val'};
    plot_struct
    
%     axes3 = axes('Parent',figure1,'Position',[0.3982 0.21 0.2518 0.259],...
%     'FontSize',12);
    pmz4 = plotmat_zeitgeber_arr;
    pm4 = plotmat_arr;
    pmz4 = [[pmz4-24];pmz4; [pmz4+24]];
    pm4 = [pm4; pm4; pm4];
    %pm_err4 = [pm_err4; pm_err4; pm_err4];
    
    figure(figure1); hold on;
    corder = jet(10);
    corder = corder(floor(linspace(length(corder)/3,length(corder)/1.0,3)),:);
    corder = [        0.0    0.6666    1.0;
    0.3333    1.0000    0.6667;
    1.0000    0.3333         0];
    set(gca,'ColorOrder',corder);
    plot(pmz4,pm4,'LineWidth',linewidth);
%     plot(plotmat_zeitgeber_arr(:,1),plotmat_arr(:,1),'LineWidth',linewidth,'Color',[1 1 1]*0);
%     plot(plotmat_zeitgeber_arr(:,2),plotmat_arr(:,2),'LineWidth',linewidth,'Color',[1 1 1]*0.5);
%     plot(plotmat_zeitgeber_arr(:,3),plotmat_arr(:,3),'LineWidth',linewidth,'Color',[1 1 1]*0.7);
%     legend(dat_fieldname_sing_arr, 'FontSize',12);
%     xlabel('Time (hours)', 'FontSize',12);
%     ylabel('Firing rate (s^{-1})', 'FontSize',12);
%     set(gca, 'FontSize',12);
%     ylimits = get(gca,'YLim'); xlimits = get(gca,'XLim');
%     axis([-2 24 ylimits(1) ylimits(2)]);
    
    figure(figure1)
    leg1=legend({'CA3 PYR','MSG','GABA_A'}); legend('boxoff'); %set(leg1,'Position',[0.7244 0.6628 0.1252 0.264]);
    %set(leg1,'Position',[0.286 0.8304 0.1869 0.1688]);
    ylimits = get(gca,'YLim'); xlimits = get(gca,'XLim');
    axis([0 36 ylimits(1)-0.1 ylimits(2)+0.25]);
%     xlabel('Time (hours)', 'FontSize',FS_axislabels);
%     ylabel('Scaling factor', 'FontSize',FS_axislabels);
    set(gca, 'FontSize',FS_axis,'Box','off');
    set(gcf,'DefaultAxesColorOrder',[0 0 0;0.1 0.1 0.1;0.2 0.2 0.2])
    rectangle('Position',[-30 ylimits(1)-0.1 12 0.03],'FaceColor','k');
    rectangle('Position',[-18 ylimits(1)-0.1 12 0.03],'FaceColor','w');
    rectangle('Position',[-6 ylimits(1)-0.1 12 0.03],'FaceColor','k');
    rectangle('Position',[6 ylimits(1)-0.1 12 0.03],'FaceColor','w');
    rectangle('Position',[18 ylimits(1)-0.1 12 0.03],'FaceColor','k');
    rectangle('Position',[30 ylimits(1)-0.1 12 0.03],'FaceColor','w');
    xlim= get(gca,'XLim');
    xtickarr = xlim(1):12:24;
    set(gca,'XTick',xtickarr,'XTickLabel',xtickarr);

    plot_singles_num = 1; natureplot_singles_scalebars;
    plot_singles_num = 2; natureplot_singles_scalebars;
    plot_singles_num = 3; natureplot_singles_scalebars;
end

if fig2b
    figure1 = figure;
    set (figure1, 'Position',[524 339 560*3/3 420*4/3]*font_scaling,'Color','w');
    h2 = gca;
    
    merg_pmz = [pmz1(:,1) pmz2(:,1) pmz3(:,1)];
    merg_pm = [pm1(:,1) pm2(:,1) pm3(:,1)];
    merg_pmerr = [pm_err1(:,1) pm_err2(:,1) pm_err3(:,1)];
    
    corder = jet(10);
    corder = corder(floor(linspace(length(corder)/3,length(corder)/1.0,3)),:);
    set(gca,'ColorOrder',corder);
    hold on; plot([merg_pmz], [merg_pm],'LineWidth',linewidth)
%     hold on; errorbar([merg_pmz], [merg_pm], [merg_pmerr],'LineWidth',linewidth)

    axes(h2);
    ylimits = get(gca,'YLim'); xlimits = get(gca,'XLim');
    axis([-0 36 ylimits(1)-1 ylimits(2)+2]);
    leg1=legend({'Schaffer','septal','mel'}); legend('boxoff');
%     xlabel('Time (hours)', 'FontSize',FS_axislabels);
%     ylabel('Firing rate (s^{-1})', 'FontSize',FS_axislabels);
    set(gca, 'FontSize',FS_axis,'Box','off');
    rectangle('Position',[-30 ylimits(1)-1 12 0.3],'FaceColor','k');
    rectangle('Position',[-18 ylimits(1)-1 12 0.3],'FaceColor','w');
    rectangle('Position',[-6 ylimits(1)-1 12 0.3],'FaceColor','k');
    rectangle('Position',[6 ylimits(1)-1 12 0.3],'FaceColor','w');
    rectangle('Position',[18 ylimits(1)-1 12 0.3],'FaceColor','k');
    rectangle('Position',[30 ylimits(1)-1 12 0.3],'FaceColor','w');
    xlim= get(gca,'XLim');
    xtickarr = xlim(1):12:xlim(2);
    set(gca,'XTick',xtickarr,'XTickLabel',xtickarr);
end

if fig3
    
    font_scaling=1.0;
    linewidth=linewidth_def;
    markersize=markersize_def;
    FS_axislabels=FS_axislabels_def*font_scaling;
    FS_axis=FS_axis_def*font_scaling;
    
    set_values_multi=0;
    
    % % % % % Set up stuff for multi_plot
    sim_start=0;
    plot_summary=0;         % Turns plots containing data from multiple simulations
    plot_2D_sens = 1;
        if plot_2D_sens;
            cell_to_plot = 1;  % 1 for basket cells
            error_threshold = 50;
            uniform_row = 0;     % Make bottom row(s) of plot uniform
            rownum = 1;
            show_sensplot = 0;
            use_colourmap = 0;
        end
    plot_across_experiments = 1;                    % Plot a single cell across multiple experimnets (different colour code per exp).
    plot_across_cells = ~plot_across_experiments;   % Plot all cells across multiple experiments
    cell2plot = 1;     % Cell number to use for 2D plots and for plotting across experiments
    new_legarr = {'basket','msg','olm','pyr'};
    fignum=88 + sim_start + plot_across_experiments*2;
    
    % % % % Sim3 - Vary MSG 2 B divergence
%     sim = sim3;
%     loop1ROI=[3]; loop1range = 1:6;     % Range of interest for outer loop; Total number of iterations of outer loop
%     loop2ROI=[1 6]; loop2range = 1:8;   % Range of interest for inner loop; Total number of iterations of inner loop
%     experiment_ROI = [0]; experiment_range = 0:0; % Experiment number of interest within loops; Total number of experiments within nested loops
%     if plot_2D_sens
%         loop1ROI = loop1range; loop2ROI = loop2range(2:8);   % If doing sensitivity analysis, need to use whole grid.
%     end
%     loop1vals = [-0.04 -0.08 -0.12 -0.16 -0.20 -0.24];  % We absolute value these later ...just incase
%     loop2vals = [0 4 8 12 16 20 24 28];                   % We absolute value these later ...just incase
%     multi_plot;
%     C_phi_interp1 = C_phi_interp;
%     C_err_interp1 = C_err_interp;
%     x1=x; y1=y;
%     
%     pm_zeit_cell1 = pm_zeit_cell;
%     pm_cell1 = pm_cell;
%     pm_ste_cell1 = pm_ste_cell;
%     bC_phi1 = reshape(C_phi,1,length(C_phi(:)));
%     bC_err1 = reshape(C_err,1,length(C_err(:)));    
    
    
    % % % % Sim4 - Vary strength of fimbria input
    sim = sim4;
    loop1ROI=[6]; loop1range = [1:7];     % Range of interest for outer loop; Total number of iterations of outer loop
    loop2ROI=[2:5]; loop2range = 1:7;   % Range of interest for inner loop; Total number of iterations of inner loop
    experiment_ROI = [0]; experiment_range = 0:0; % Experiment number of interest within loops; Total number of experiments within nested loops
    if plot_2D_sens
        loop1ROI = loop1range([1:7]); loop2ROI = loop2range([1:7]);   % If doing sensitivity analysis, need to use whole grid.
            % Note, for this simulation, sim{36:38} have bad values (sim
            % terminated on error)
    end
    loop1vals = [-0.05 -0.075 -0.085 -0.10 -0.12 -0.14 -0.18];  % We absolute value these later ...just incase
    loop2vals = [0.0 0.15 0.3 0.45 0.65 0.80 1.0]*50;                   % We absolute value these later ...just incase
    multi_plot;
    C_phi_interp2 = C_phi_interp;
    C_err_interp2 = C_err_interp;
    x2=x; y2=y;
    
    pm_zeit_cell2 = pm_zeit_cell;
    pm_cell2 = pm_cell;
    pm_ste_cell2 = pm_ste_cell;
    bC_phi2 = reshape(C_phi,1,length(C_phi(:)));
    bC_err2 = reshape(C_err,1,length(C_err(:)));
    
    figure1 = figure;
    set (figure1, 'Position',[524 339 560*3/2 420]*font_scaling,'Color','w');
    annotation(figure1,'textbox',[0.03 0.92 0.05455 0.08571],'String',{'a'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels*2);
    annotation(figure1,'textbox',[0.47 0.92 0.05455 0.08571],'String',{'b'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels*2);
    
    h1 = subplot(121);
%     imagesc(x1,y1,C_phi_interp1,[0 12]); set(gca,'YDir','normal')
%     %colorbar;
%     h = findall(gca,'Type','image');
%     set (h(1), 'AlphaData',1-C_err_interp1);                 % Set transparency to account for error.
%     xlabel('Mel amp', 'FontSize',FS_axislabels);
%     ylabel('msg to bc divergence', 'FontSize',FS_axislabels);
%     %title('Peak firing (hours)', 'FontSize',FS_axislabels);
%     hold on;
%     plot(0.12,20,'kx','MarkerSize',markersize,'LineWidth',2)
%     plot([0.12 0.12],[0 28],'k:','LineWidth',1)
%     plot([0.0 0.24],[20 20],'k:','LineWidth',1)

    h2 = subplot(122);
    xlabel('Mel amp', 'FontSize',FS_axislabels);
    imagesc(x2,y2*100/50,C_phi_interp2,[0 12]); set(gca,'YDir','normal')
    set(gca, 'FontSize',FS_axis/3*2);
    
%     imagesc(x2,y2*4,C_phi_interp2,[0 12]); set(gca,'YDir','normal')
    h = findall(gca,'Type','image');
    set (h(1), 'AlphaData',1-C_err_interp2);                 % Set transparency to account for error.
    xlabel('Mel amp', 'FontSize',FS_axislabels);
    ylabel(['Septal innervation (% max)'], 'FontSize',FS_axislabels);
    hcb = colorbar;
    hcb2 = get(hcb,'Title');
    set(hcb2,'String','Basket peak firing T_0 (hours)','Position',[4,6,1.005],'Rotation',270,'FontSize',FS_axislabels)
    hold on;
    plot(0.12,100,'kx','MarkerSize',markersize,'LineWidth',2)
    plot(0.12,0,'kx','MarkerSize',markersize,'LineWidth',2)
    plot([0.12 0.12],[0 160],'k:','LineWidth',1)
    plot([0.0 0.24],[100 100],'k:','LineWidth',1)
    
    set (h1,'Position',[0.08929 0.1333 0.3395 0.7929]);
    set (h2,'Position',[0.5703 0.1333 0.3395 0.7929]);
    
%     h_ann = annotation(figure1,'textbox',[0.03 0.92 0.05455 0.08571],'String',{'Peak firing (hours)'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels);
%     h3 = axes('YAxisLocation','right','Color','none');
%     set (h3,'Position',[0.9012 0.2881 0.008333 0.5557]);
%     h_ylabel = ylabel ('Peak firing (hours)','FontSize',FS_axislabels);
%     set(h3,'Box','off');
%     set(h3,'Visible','off');
%     set(h_ylabel,'Visible','on','Rotation',270);

    if use_colourmap
        figure;
        cmap = colormap;
        ncodes = size(colormap,1);
        Cphi_rgb = ind2rgb(wcodemat(C_phi,ncodes,'mat'), cmap);
        for ii = 1:size(C_err,1);
            for jj = 1:size(C_err,2);
                if (C_err(ii,jj))
                    Cphi_rgb(ii,jj,1) = 1.0;
                    Cphi_rgb(ii,jj,2) = 1.0;
                    Cphi_rgb(ii,jj,3) = 1.0;
                end
            end
        end
        image(x,y,Cphi_rgb); set(gca,'YDir','normal');
        Cphi_rgb_int(:,:,1) = interp2(xvals, yvals, Cphi_rgb(:,:,1),loop1vals_interp,loop2vals_interp,'linear');
        Cphi_rgb_int(:,:,2) = interp2(xvals, yvals, Cphi_rgb(:,:,2),loop1vals_interp,loop2vals_interp,'linear');
        Cphi_rgb_int(:,:,3) = interp2(xvals, yvals, Cphi_rgb(:,:,3),loop1vals_interp,loop2vals_interp,'linear');
        figure; image(x,y,Cphi_rgb_int); set(gca,'YDir','normal');
    end
    
    
end


if fig4_suppl

    % % Plot raw BASKET data for sens analysis, merged
    font_scaling = 1.0;
    linewidth=linewidth_def;
    markersize=markersize_def;
    FS_axislabels=FS_axislabels_def*font_scaling;
    FS_axis=FS_axis_def*font_scaling;
    cell2plot=1;
    % Convert our firing rate cell arrays into matricies, extracting
    % out a specific cell number
    [pm_zeit_single1 pm_single1 pm_ste_single1] = extract_cell_zeit(cell2plot,pm_zeit_cell1, pm_cell1, pm_ste_cell1);
    [pm_zeit_single2 pm_single2 pm_ste_single2] = extract_cell_zeit(cell2plot,pm_zeit_cell2, pm_cell2, pm_ste_cell2);


    bC_phi=[bC_phi1 bC_phi2];
    bC_err=[bC_err1 bC_err2];
    pmzs_merg=[pm_zeit_single1 pm_zeit_single2];
    pms_merg=[pm_single1 pm_single2];
    pmss_merg=[pm_ste_single1 pm_ste_single2];

    plot_error=0;
    figure1 = figure;
    set (figure1, 'Position',[524 339 560*3/2 420]*font_scaling,'Color','w');
    subplot(121);
    ind = find((bC_phi > 6) & (~bC_err));
    if plot_error; errorbar(pmzs_merg(:,ind),pms_merg(:,ind),pmss_merg(:,ind)); else   
    plot(pmzs_merg(:,ind),pms_merg(:,ind),'--'); end
    xlabel('Time (hours)', 'FontSize',FS_axislabels);
    ylabel('firing rate (s^{-1})', 'FontSize',FS_axislabels);
    title('B firing rate noon, merged', 'FontSize',FS_axislabels);
    ylimits = get(gca,'YLim'); xlimits = get(gca,'XLim');
    axis([-2 24 ylimits(1)-1 ylimits(2)]);
    xlim= get(gca,'XLim');
    xtickarr = xlim(1):6:xlim(2);
    set(gca,'XTick',xtickarr,'XTickLabel',xtickarr);
    subplot(122);
    ind = find((bC_phi < 6) & (~bC_err));
    if plot_error; errorbar(pmzs_merg(:,ind),pms_merg(:,ind),pmss_merg(:,ind)); else   
    plot(pmzs_merg(:,ind),pms_merg(:,ind),'--'); end
    xlabel('Time (hours)', 'FontSize',FS_axislabels);
    title('B firing rate midnight, merged', 'FontSize',FS_axislabels);
    ylimits = get(gca,'YLim'); xlimits = get(gca,'XLim');
    axis([-2 24 ylimits(1)-1 ylimits(2)]);
    xlim= get(gca,'XLim');
    xtickarr = xlim(1):6:xlim(2);
    set(gca,'XTick',xtickarr,'XTickLabel',xtickarr);


    % % Plot raw BASKET data for sens analysis, not merged
    cell2plot=1;
    [pm_zeit_single1 pm_single1 pm_ste_single1] = extract_cell_zeit(cell2plot,pm_zeit_cell1, pm_cell1, pm_ste_cell1);
    [pm_zeit_single2 pm_single2 pm_ste_single2] = extract_cell_zeit(cell2plot,pm_zeit_cell2, pm_cell2, pm_ste_cell2);
    bC_phi=[bC_phi1 ];
    bC_err=[bC_err1 ];
    pmzs_merg=[pm_zeit_single1 ];
    pms_merg=[pm_single1 ];
    pmss_merg=[pm_ste_single1 ];

    font_scaling = 0.5;
    linewidth=linewidth_def;
    markersize=markersize_def;
    FS_axislabels=FS_axislabels_def*font_scaling;
    FS_axis=FS_axis_def*font_scaling;
    figure1 = figure;
    set (figure1, 'Position',[524 339 560*3/2 420*7/4]*font_scaling,'Color','w');
    subplot(221);
    ind = find((bC_phi > 6) & (~bC_err));
    if plot_error; errorbar(pmzs_merg(:,ind),pms_merg(:,ind),pmss_merg(:,ind)); else   
    plot(pmzs_merg(:,ind),pms_merg(:,ind),'--'); end
    xlabel('Time (hours)', 'FontSize',FS_axislabels);
    ylabel('firing rate (s^{-1})', 'FontSize',FS_axislabels);
    title('Bas FR phase noon, msg2b', 'FontSize',FS_axislabels);
    ylimits = get(gca,'YLim'); xlimits = get(gca,'XLim');
    axis([-2 24 ylimits(1)-1 ylimits(2)]);
    xlim= get(gca,'XLim');
    xtickarr = xlim(1):6:xlim(2);
    set(gca,'XTick',xtickarr,'XTickLabel',xtickarr);
    subplot(222);
    ind = find((bC_phi < 6) & (~bC_err));
    if plot_error; errorbar(pmzs_merg(:,ind),pms_merg(:,ind),pmss_merg(:,ind)); else   
    plot(pmzs_merg(:,ind),pms_merg(:,ind),'--'); end
    xlabel('Time (hours)', 'FontSize',FS_axislabels);
    title('Bas FR phase midnight, msg2b', 'FontSize',FS_axislabels);
    ylimits = get(gca,'YLim'); xlimits = get(gca,'XLim');
    axis([-2 24 ylimits(1)-1 ylimits(2)]);
    xlim= get(gca,'XLim');
    xtickarr = xlim(1):6:xlim(2);
    set(gca,'XTick',xtickarr,'XTickLabel',xtickarr);

    bC_phi=[bC_phi2 ];
    bC_err=[bC_err2 ];
    pmzs_merg=[pm_zeit_single2 ];
    pms_merg=[pm_single2 ];
    pmss_merg=[pm_ste_single2 ];

    subplot(223);
    ind = find((bC_phi > 6) & (~bC_err));
    if plot_error; errorbar(pmzs_merg(:,ind),pms_merg(:,ind),pmss_merg(:,ind)); else   
    plot(pmzs_merg(:,ind),pms_merg(:,ind),'--'); end
    xlabel('Time (hours)', 'FontSize',FS_axislabels);
    ylabel('firing rate (s^{-1})', 'FontSize',FS_axislabels);
    title('Bas FR noon, chop', 'FontSize',FS_axislabels);
    ylimits = get(gca,'YLim'); xlimits = get(gca,'XLim');
    axis([-2 24 ylimits(1)-1 ylimits(2)]);
    xlim= get(gca,'XLim');
    xtickarr = xlim(1):6:xlim(2);
    set(gca,'XTick',xtickarr,'XTickLabel',xtickarr);

    subplot(224);
    ind = find((bC_phi < 6) & (~bC_err));
    if plot_error; errorbar(pmzs_merg(:,ind),pms_merg(:,ind),pmss_merg(:,ind)); else   
    plot(pmzs_merg(:,ind),pms_merg(:,ind),'--'); end
    xlabel('Time (hours)', 'FontSize',FS_axislabels);
    title('Bas FR phase midnight, chop', 'FontSize',FS_axislabels);
    ylimits = get(gca,'YLim'); xlimits = get(gca,'XLim');
    axis([-2 24 ylimits(1)-1 ylimits(2)]);
    xlim= get(gca,'XLim');
    xtickarr = xlim(1):6:xlim(2);
    set(gca,'XTick',xtickarr,'XTickLabel',xtickarr);
    
    
    
    % % Plot raw BASKET data for just chop data
    cell2plot=1;
   
    [pm_zeit_single2 pm_single2 pm_ste_single2] = extract_cell_zeit(cell2plot,pm_zeit_cell2, pm_cell2, pm_ste_cell2);
    
    font_scaling = 0.5;
    linewidth=linewidth_def;
    markersize=markersize_def;
    FS_axislabels=FS_axislabels_def*font_scaling;
    FS_axis=FS_axis_def*font_scaling;
    figure1 = figure;
    set (figure1, 'Position',[524 339 560*3/2 420*7/4]*font_scaling,'Color','w');
    
    bC_phi=[bC_phi2 ];
    bC_err=[bC_err2 ];
    pmzs_merg=[pm_zeit_single2 ];
    pms_merg=[pm_single2 ];
    pmss_merg=[pm_ste_single2 ];

    subplot(221);
    ind = find((bC_phi > 6) & (~bC_err));
    if plot_error; errorbar(pmzs_merg(:,ind),pms_merg(:,ind),pmss_merg(:,ind)); else   
    plot(pmzs_merg(:,ind),pms_merg(:,ind)); end
    xlabel('Time (h)', 'FontSize',FS_axislabels);
    ylabel('Firing rate (s^{-1})', 'FontSize',FS_axislabels);
%     title('Bas FR noon, chop', 'FontSize',FS_axislabels);
    ylimits = get(gca,'YLim'); xlimits = get(gca,'XLim');
    axis([-2 24 ylimits(1)-1 ylimits(2)]);
    xlim= get(gca,'XLim');
    xtickarr = xlim(1):6:xlim(2);
    set(gca,'XTick',xtickarr,'XTickLabel',xtickarr);

    subplot(222);
    ind = find((bC_phi < 6) & (~bC_err));
    if plot_error; errorbar(pmzs_merg(:,ind),pms_merg(:,ind),pmss_merg(:,ind)); else   
    plot(pmzs_merg(:,ind),pms_merg(:,ind)); end
    xlabel('Time (h)', 'FontSize',FS_axislabels);
    ylabel('Firing rate (s^{-1})', 'FontSize',FS_axislabels);
%     title('Bas FR phase midnight, chop', 'FontSize',FS_axislabels);
    ylimits = get(gca,'YLim'); xlimits = get(gca,'XLim');
    axis([-2 24 ylimits(1)-1 ylimits(2)]);
    xlim= get(gca,'XLim');
    xtickarr = xlim(1):6:xlim(2);
    set(gca,'XTick',xtickarr,'XTickLabel',xtickarr);
    
    
    subplot(223);
    ind = find(bC_err);
    if plot_error; errorbar(pmzs_merg(:,ind),pms_merg(:,ind),pmss_merg(:,ind)); else   
    plot(pmzs_merg(:,ind),pms_merg(:,ind)); end
    xlabel('Time (h)', 'FontSize',FS_axislabels);
%     title('Bas FR phase midnight, chop', 'FontSize',FS_axislabels);
    ylimits = get(gca,'YLim'); xlimits = get(gca,'XLim');
    axis([-2 24 ylimits(1)-1 ylimits(2)]);
    xlim= get(gca,'XLim');
    xtickarr = xlim(1):6:xlim(2);
    set(gca,'XTick',xtickarr,'XTickLabel',xtickarr);
    ylabel('Firing rate (s^{-1})', 'FontSize',FS_axislabels);
    

    % % Plot raw PYR data for sens analysis, merged
    cell2plot=4;
    % Convert our firing rate cell arrays into matricies, extracting
    % out a specific cell number
    [pm_zeit_single1 pm_single1 pm_ste_single1] = extract_cell_zeit(cell2plot,pm_zeit_cell1, pm_cell1, pm_ste_cell1);
    [pm_zeit_single2 pm_single2 pm_ste_single2] = extract_cell_zeit(cell2plot,pm_zeit_cell2, pm_cell2, pm_ste_cell2);

%     bC_phi=[bC_phi1 bC_phi2];
%     bC_err=[bC_err1 bC_err2];
%     pmzs_merg=[pm_zeit_single1 pm_zeit_single2];
%     pms_merg=[pm_single1 pm_single2];
%     pmss_merg=[pm_ste_single1 pm_ste_single2];
    
    bC_phi=[bC_phi2];
    bC_err=[bC_err2];
    pmzs_merg=[pm_zeit_single2];
    pms_merg=[pm_single2];
    pmss_merg=[pm_ste_single2];

%     figure1 = figure;
%     set (figure1, 'Position',[524 339 560 420]*font_scaling,'Color','w');
    subplot(224)
    ind = find((~bC_err) | (bC_err));
    if plot_error; errorbar(pmzs_merg(:,ind),pms_merg(:,ind),pmss_merg(:,ind)); else   
    plot(pmzs_merg(:,ind),pms_merg(:,ind)); end
    xlabel('Time (h)', 'FontSize',FS_axislabels);
    ylabel('Firing rate (s^{-1})', 'FontSize',FS_axislabels);
%     title('Pyr firing rate', 'FontSize',FS_axislabels);
    ylimits = get(gca,'YLim'); xlimits = get(gca,'XLim');
    axis([-2 24 ylimits(1)-1 ylimits(2)]);
    xlim= get(gca,'XLim');
    xtickarr = xlim(1):6:xlim(2);
    set(gca,'XTick',xtickarr,'XTickLabel',xtickarr);
    
%     annotation(figure1,'textbox',[0.088 0.97 0.02464 0.0619],'String',{'a'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels*2);
%     annotation(figure1,'textbox',[0.37 0.97 0.02464 0.0619],'String',{'b'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels*2);
%     annotation(figure1,'textbox',[0.66 0.97  0.02464 0.0619],'String',{'c'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels*2);
    
    annotation(figure1,'textbox',[0.03 0.92 0.05455 0.08571],'String',{'A'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels*2);
    annotation(figure1,'textbox',[0.48 0.92 0.05455 0.08571],'String',{'B'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels*2);
    annotation(figure1,'textbox',[0.03 0.45 0.05455 0.08571],'String',{'C'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels*2);
    annotation(figure1,'textbox',[0.48 0.45 0.05455 0.08571],'String',{'D'},'FitBoxToText','off','LineStyle','none','FontSize',FS_axislabels*2);
    
    

end



clear set_values set_values_multi