


% load wrkspc2.mat

if ~exist('set_values_multi');
    set_values_multi=1;
end


clear leg_arr

set_values=0;



% % % % % Default setup stuff % % % % %
        sim_num=2;
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
           cell_range=[1:4];
           time_range=4;
           plot_inputs = 0;
           %%%%%% TO DO: Fix KAPPA - It gives non-intuitive values for pyr
            %%% Are initial values biasing? Should I be chopping off some of the
            %%% initial data points?
            %%% Might also need to adjust bin size used by KAPPA.
        end
% % % % % End default setup stuff % % % % %


if set_values_multi
    linewidth_def=2;
    markersize_def=1;
    FS_axislabels_def=20;
    FS_axis_def=20;

    font_scaling=1;
    linewidth=linewidth_def;
    markersize=markersize_def;
    FS_axislabels=FS_axislabels_def*font_scaling;
    FS_axis=FS_axis_def*font_scaling;
    linear_or_nearest='linear';
    fiterr_thresh = 33;
    amperr_thresh = 0.03;
    
    sim_start=0;
    plot_summary=1;         % Turns plots containing data from multiple simulations
    plot_2D_sens = 1;
        if plot_2D_sens;
            cell_to_plot = 1;  % 1 for basket cells
            error_threshold = 50;
            uniform_row = 0;     % Make bottom row(s) of plot uniform
            rownum = 1;
            show_sensplot = 1;
            use_colourmap = 0;
        end
    plot_across_experiments = 1;                    % Plot a single cell across multiple experimnets (different colour code per exp).
    plot_across_cells = ~plot_across_experiments;   % Plot all cells across multiple experiments
    cell2plot = 1;     % Cell number to use for 2D plots and for plotting across experiments
    new_legarr = {'basket','msg','olm','pyr'};
    fignum=88 + sim_start + plot_across_experiments*2;

    loop1ROI=[6]; loop1range = [1:6];     % Range of interest for outer loop; Total number of iterations of outer loop
    loop2ROI=[2:5]; loop2range = 1:11;   % Range of interest for inner loop; Total number of iterations of inner loop
    experiment_ROI = [0]; experiment_range = 0:0; % Experiment number of interest within loops; Total number of experiments within nested loops
    if plot_2D_sens
        loop1ROI = loop1range([1:6]); loop2ROI = loop2range([1:11]);   % If doing sensitivity analysis, need to use whole grid.
            % Note, for this simulation, sim{36:38} have bad values (sim
            % terminated on error)
    end
    loop1vals = [-0.04 -0.08 -0.12 -0.16 -0.20 -0.24];  % We absolute value these later ...just incase
    loop2vals = [0 5 10 15 20 25 30 35 40 45 50];                   % We absolute value these later ...just incase

end

i = 0; sim_num0=[]; sim_axes.loop1 = []; sim_axes.loop2 = [];
for loop1 = loop1range
    for loop2 = loop2range
        for experiment_num = experiment_range
            if ~isempty(find(loop1 == loop1ROI)) && ~isempty(find(loop2 == loop2ROI)) && ~isempty(find(experiment_num == experiment_ROI));
                sim_num0 = [sim_num0 i];
                sim_axes.loop1 = [sim_axes.loop1 abs(loop1vals(loop1))];  % Recall i starts at zero here! We add + 1 to it later
                sim_axes.loop2 = [sim_axes.loop2 abs(loop2vals(loop2))];
            end
            i = i + 1;
        end
    end
end
sim_num0 = sim_num0 + 1;    % Shift by +1 for Matlab array format


pm_zeit_cell={}; pm_cell={}; pm_ste_cell={};
if plot_2D_sens; A=[]; phi=[]; percent_err=[]; mean_firing_rate=[]; end
for ii = 1:length(sim_num0)
    ii
    sim_num = sim_num0(ii);
    plot_struct
    pm_zeit_cell{ii} = plotmat_zeitgeber_arr;
    pm_cell{ii} = plotmat_arr;
    pm_ste_cell{ii} = plotmat_ste_arr;
    
%     if plot_2D_sens
        [A(ii) phi(ii) mse_temp percent_err(ii)] = fit_sinwave(plotmat_zeitgeber_arr(:,cell2plot), plotmat_arr(:,cell2plot), 24);
        mean_firing_rate(ii) = mean(plotmat_arr(:,cell2plot));
%     end
    
    
    if plot_across_cells && ~plot_across_experiments && plot_summary
        figure(fignum); hold on;
        if plot_error; errorbar(pm_zeit_cell{ii},pm_cell{ii},pm_ste_cell{ii}); else    
        plot(pm_zeit_cell{ii},pm_cell{ii}); end
        legend(new_legarr);
        title(['Plotting circadian input vs time']);
    end
    
end


if plot_across_experiments && ~plot_across_cells && plot_summary
    figure(fignum); hold on;
    pm_zeit_single = []; pm_single = []; pm_ste_single =[];
    for ii=1:length(pm_cell)
        pm_zeit_single = [pm_zeit_single pm_zeit_cell{ii}(:,cell2plot)];
        pm_single = [pm_single pm_cell{ii}(:,cell2plot)];
        pm_ste_single = [pm_ste_single pm_ste_cell{ii}(:,cell2plot)];
        leg_arr{ii} = ['L1(x)=' num2str(sim_axes.loop1(ii)) ' L2(y)=' num2str(sim_axes.loop2(ii)) ' phi=' num2str(phi(ii))];
    end
%     pm_zeit_cell = cell2mat(pm_zeit_cell);
%     pm_cell = cell2mat(pm_cell);
%     pm_ste_cell = cell2mat(pm_ste_cell);
    if plot_error; errorbar(pm_zeit_single,pm_single,pm_ste_single); else    
    plot(pm_zeit_single,pm_single); end
    title(['Plotting cell ' new_legarr{cell2plot}]);
    legend(leg_arr);
end


if plot_2D_sens
    N_interp=200;       % Number of interpolation points on sens_plot
%     error_threshold = 10; % Threshold for whiting out parts of phase image with high error in sinusoid fit
    error_threshold = 12; % Threshold for whiting out parts of phase image with high error in sinusoid fit
    error_threshold = fiterr_thresh;
    xsize = [length(loop1ROI)];
    ysize = [length(loop2ROI)];
    x = [min(abs(loop1vals(loop1ROI))) max(abs(loop1vals(loop1ROI)))];
    y = [min(abs(loop2vals(loop2ROI))) max(abs(loop2vals(loop2ROI)))];
    C_phi = reshape (phi,ysize, xsize);
    C_amp = reshape (A,ysize, xsize);
    C_err = reshape (percent_err,ysize, xsize);
    C_mean_firing_rate = reshape (mean_firing_rate,ysize, xsize);
    
    xvals = reshape(abs(sim_axes.loop1), ysize, xsize);
    yvals = reshape (abs(sim_axes.loop2), ysize, xsize);
    loop1vals_interp = linspace(x(1),x(2),N_interp); loop1vals_interp = repmat((loop1vals_interp(:))',N_interp,1);
    loop2vals_interp = linspace(y(1),y(2),N_interp); loop2vals_interp = repmat(loop2vals_interp(:),1,N_interp);
    
    C_err_orig = C_err;
    C_err1 = C_err > error_threshold;                % Threshold before interpolation
%     C_err2 = (C_amp./C_mean_firing_rate) < 0.07;   % Error due to low amplitude sinusoid
    C_err2 = (C_amp./C_mean_firing_rate) < 0.05;   % Error due to low amplitude sinusoid
    C_err2 = (C_amp./C_mean_firing_rate) < amperr_thresh;
    C_err = (C_err1 | C_err2);

    
    C_phi_interp = interp2(xvals, yvals, C_phi,loop1vals_interp,loop2vals_interp,linear_or_nearest);
    C_err_interp = interp2(xvals, yvals, C_err,loop1vals_interp,loop2vals_interp,linear_or_nearest);
%     C_err_interp = (C_err_interp > error_threshold);  % Threshold after interpolation
    
    if uniform_row
        ur_yrange = find( (loop2vals_interp(:,1) < loop2vals(rownum + 1)) );     % Y-range of uniform row
        yr_xvals = xvals(rownum,:);
        yr_loop1vals_interp = linspace(x(1),x(2),N_interp);
        yr_Cphi_interp  = interp1(yr_xvals, C_phi(rownum,:), yr_loop1vals_interp);
        yr_Cerr_interp  = interp1(yr_xvals, C_err(rownum,:), yr_loop1vals_interp);
        C_phi_interp(ur_yrange,:) = repmat(yr_Cphi_interp,length(ur_yrange),1);
        C_err_interp(ur_yrange,:) = repmat(yr_Cerr_interp,length(ur_yrange),1);
        
%         C_phi_interp(ur_yrange,:) = repmat(C_phi_interp(1,:),length(ur_yrange),1);
%         C_err_interp(ur_yrange,:) = repmat(C_err_interp(1,:),length(ur_yrange),1);
        
    end

%     background_img = zeros(N_interp, N_interp,3);            % Black background image
%     figure; image(x,y,background_img);        % Can more easily implement this by setting background to black
    if show_sensplot
        figure; imagesc(x,y,C_phi_interp); colorbar; set(gca,'YDir','normal')
        h = findall(gca,'Type','image');
        set (h(1), 'AlphaData',1-C_err_interp);                 % Set transparency to account for error.
    end
    
    if use_colourmap && show_sensplot
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
    
    
%     figure; imagesc(x,y,C_err_interp); colorbar; set(gca,'YDir','normal')    
%     figure; imagesc(x,y,C_phi); colorbar; set(gca,'YDir','normal')
%     figure; imagesc(C_amp); colorbar; set(gca,'YDir','normal')
%     figure; imagesc(x,y,C_err); colorbar; set(gca,'YDir','normal')
%     figure; imagesc(C_err_orig); colorbar; set(gca,'YDir','normal')
%     figure; imagesc(C_err,[0 50]); colorbar;
end

clear set_values

