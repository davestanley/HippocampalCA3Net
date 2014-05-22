


% clc


if ~exist('set_values');
    set_values=1;
end


if set_values

    sim_num=2;
    sim_num=sim_num+1;
    cell_range=1:4;
    time_range = (1:length(sim{sim_num}.time));

    plot_on=1;
    plot_traces = 0;
    plot_inputs = 0;
    plot_spws = 1;
    plot_raster = 0;
        timerange_raster = 1;
    plot_auto = 0;
    plot_matrix_on = 0;
        
    plot_stats = 0;
        plot_error = 0;
        plot_efield = 0;
        plot_SPWs_stats = 1;
            dat_fieldname_sing_SPW='column.SPW_stats.width';
%             dat_fieldname_sing_SPW='column.SPW_stats.SPW_rate';
%             dat_fieldname_sing_SPW='column.SPW_stats.amp_prenorm';
        if plot_efield; cell_range = 1:11; end
        if plot_SPWs_stats; cell_range = 4; end
    
    
    if plot_traces
       cell_range=4;
       time_range=(1:length(sim{sim_num}.time));
%        time_range=11;
       calc_auto = 0;
       plot_inputs = 0;
       recalc_SPWs = 1;
       plot_rawtraces = 0;
       plot_spw_rates = 0;
       %%%%%% TO DO: Fix KAPPA - It gives non-intuitive values for pyr
        %%% Are initial values biasing? Should I be chopping off some of the
        %%% initial data points?
        %%% Might also need to adjust bin size used by KAPPA.
    end
    if plot_matrix_on
%         time_range=(1:length(sim{sim_num}.time));
        time_range=[1 2 8 9];
        
    end

end

    % Initialize storage arrays.
clear plotmat plotmat_std plotmat_ste plotmat_t
plotmat_zeitgeber_arr = [];
plotmat_input_arr = [];
plotmat_arr = [];
plotmat_std_arr = [];
plotmat_ste_arr = [];

    % Start for loop.
if plot_stats
    for cellnum = [cell_range]
%         dat_fieldname_sing='column.stats.amp.ct';
        dat_fieldname_sing='column.stats.period1.ct';
%         dat_fieldname_sing='column.stats.K.ct';
%         dat_fieldname_sing='Ca_val';
        
        dat_fieldname_zeitgeber='time';
        dat_fieldname_input = 'EC_val';

        
        if plot_efield
            [plotmat]= struct2matrix({sim{sim_num}.time{time_range}},['column.stats.std{5}(' num2str(cellnum) ')'],[],0, 0);
        elseif plot_SPWs_stats
            [plotmat]= struct2matrix({sim{sim_num}.time{time_range}},dat_fieldname_sing_SPW,[],0, 0);
            %[plotmat_std]= struct2matrix({sim{sim_num}.time{time_range}},[dat_fieldname_sing '_std'],[],0, 0);
            %[plotmat_ste]= struct2matrix({sim{sim_num}.time{time_range}},[dat_fieldname_sing '_ste'],[],0, 0);
        else
            [plotmat]= struct2matrix({sim{sim_num}.time{time_range}},[dat_fieldname_sing '{' num2str(cellnum) '}'],[],0, 0);
            [plotmat_std]= struct2matrix({sim{sim_num}.time{time_range}},[dat_fieldname_sing '_std'  '{' num2str(cellnum) '}'],[],0, 0);
            [plotmat_ste]= struct2matrix({sim{sim_num}.time{time_range}},[dat_fieldname_sing '_ste'  '{' num2str(cellnum) '}'],[],0, 0);
        end

        [plotmat_zeitgeber]= struct2matrix({sim{sim_num}.time{time_range}},[dat_fieldname_zeitgeber],[],0, 0);
        [plotmat_input]= struct2matrix({sim{sim_num}.time{time_range}},[dat_fieldname_input],[],0, 0);




        plotmat_zeitgeber_arr = [plotmat_zeitgeber_arr plotmat_zeitgeber(:)];
        plotmat_input_arr = [plotmat_input_arr plotmat_input(:)];
        plotmat_arr = [plotmat_arr plotmat(:)];
        if plot_error
            plotmat_std_arr = [plotmat_std_arr plotmat_std(:)];
            plotmat_ste_arr = [plotmat_ste_arr plotmat_ste(:)];
        end



    end
    
    if plot_on
        figure;
        set(gcf,'Position',[4   509   265   417]);
        hold on
        if plot_error; errorbar(plotmat_zeitgeber_arr,plotmat_arr,plotmat_ste_arr); else
        plot(plotmat_zeitgeber_arr,plotmat_arr); end
        %legend('basket','msg','olm','pyr');
        title(['Plotting circadian input vs time']);
        % figure; plot(plotmat_zeitgeber_arr, plotmat_input_arr);
    end
end


    % Start for loop.
if plot_inputs
    figure;
    dat_fieldname_sing_arr = {'EC_val','SCN_val','mel_val','ACh_val','musc_val','Ca_val'};
    dat_fieldname_sing_arr = {'SCN_val','mel_val','Ca_val','ACh_val','ACh_Esyn_scale','ACh_accom_scale','ACh_pyr_inj'};
    plotmat_arr=[];
    plotmat_zeitgeber_arr=[];
    for kk=1:length(dat_fieldname_sing_arr)

        dat_fieldname_sing=dat_fieldname_sing_arr{kk};

        dat_fieldname_zeitgeber='time';
        dat_fieldname_input = 'EC_val';

        [plotmat]= struct2matrix({sim{sim_num}.time{time_range}},[dat_fieldname_sing],[],0, 0);
        [plotmat_zeitgeber]= struct2matrix({sim{sim_num}.time{time_range}},[dat_fieldname_zeitgeber],[],0, 0);
        [plotmat_input]= struct2matrix({sim{sim_num}.time{time_range}},[dat_fieldname_input],[],0, 0);

        plotmat_arr=[plotmat_arr plotmat(:)];
        plotmat_zeitgeber_arr=[plotmat_zeitgeber_arr plotmat_zeitgeber(:)];
    end
    
    if plot_on
        for i = 1:length(dat_fieldname_sing_arr)
            dat_fieldname_sing_arr{i} = strrep (dat_fieldname_sing_arr{i}, '_val', '');
        end
        
        hold on
        plot(plotmat_zeitgeber_arr,plotmat_arr);
        legend(dat_fieldname_sing_arr);
        title(['Plotting ' dat_fieldname_sing]);
    end
end



if plot_traces
        % Initialize storage arrays.
    clear plotmat plotmat_std plotmat_ste plotmat_t


    % Start for loop.
    for cellnum = [cell_range]    
        dat_fieldname_sing='column.sptr.ct';
        datfield_t='';

        SPW_arr = [];
        if plot_traces

            figure; hold on;
            shiftval = 0;
            shift_delta = 20e-3;
            for k = time_range
                if cellnum == 5; opt_struct.shift = 5e-3; dt = sim{sim_num}.os.dt2; else opt_struct.shift = 0; dt = sim{sim_num}.os.dt; end
                
                if plot_rawtraces || recalc_SPWs
                    plotmat{cellnum} = sim{sim_num}.time{k}.column.sptr.ct{cellnum};
                    plotmat_t{cellnum} = [0:(length(plotmat{cellnum})-1)]*dt;
                end
                
                AP_thresh = -0.030; % Volts
                SPW_refract = round(100e-3 / dt); % Indicies (Seconds / timestep)

                SPW_thresh = 0.3;   % Arb units
                smooth_window = 0.050; % Seconds
                H_tau = 20e-3; % Seconds

                SPW_thresh = 0.1;   % Arb units
                smooth_window = 0.020; % Seconds
                H_tau = 5e-3; % Seconds
                
                if recalc_SPWs
                    meanfield = mean((plotmat{cellnum})');

                    pm_t = plotmat_t{cellnum};
                    hpsp = (exp(-pm_t(1:end) ./ H_tau));
                    % hpsp = zeros(1,length(pm_t)); hpsp(1) = 1;    % Test with delta function
                    pm = plotmat{cellnum};
                    spikes = get_spikes (pm, AP_thresh, 0);
    %                         figure; plot (pm);
    %                         hold on; plot(spikes.*pm,'o');
                    psps = [];
                    for kk = 1:size(pm,2)
                        psps(:,kk) = conv(hpsp,spikes(:,kk));
                    end

                    psps = psps(1:length(pm_t),:);
    %                         figure; plot(pm_t, psps)

                    meanfield_psps = mean(psps')';

                else
                    pm_t = sim{sim_num}.time{k}.column.SPW.psp_t;
                    meanfield = sim{sim_num}.time{k}.column.SPW.meanfield;  % Mean voltage trace of all cells
                    meanfield_psps = sim{sim_num}.time{k}.column.SPW.psps;  % Mean PSPs produced by all cells
                    psps_smooth = sim{sim_num}.time{k}.column.SPW.psps_smooth;
                end
                
                smooth_window = smooth_window;
                psps_smooth = 1/round(smooth_window/dt) * conv(meanfield_psps, ones(round(smooth_window/dt),1));
                psps_smooth = wkeep(psps_smooth, length(meanfield), 'c');

                SPWs = get_spikes(psps_smooth, SPW_thresh, SPW_refract);
%                         figure; plot(pm_t, meanfield_psps);
%                         hold on; plot(pm_t, psps_smooth,'r');
%                         hold on; plot(pm_t,SPWs.*psps_smooth,'ro','LineWidth',2);

                psps_norm = meanfield_psps * (max(meanfield)-min(meanfield)) + mean(meanfield);
                psps_smooth_norm = psps_smooth * (max(meanfield)-min(meanfield)) + mean(meanfield);
                SPWs_norm = psps_smooth_norm .* SPWs;
                index = find(SPWs == 0);
                SPWs_norm(index) = NaN;

%                 figure; plot(pm_t,meanfield_psps);
%                 hold on; plot(pm_t, psps_smooth,'r');

                if calc_auto
                    shift_delta = 1e0;
                    [Xcalc Tcalc] = davexcorr (plotmat_t{cellnum},meanfield,meanfield,1,0);
                    plotmat{cellnum} = Xcalc;
                    plotmat_t{cellnum} = Tcalc;
                end                

                if plot_rawtraces; plot_matrix(plotmat_t{cellnum},plotmat{cellnum} + shiftval,opt_struct);
                end
                if ~(calc_auto);
%                     plot(pm_t,meanfield + shiftval,'LineWidth',1);
                    %plot(pm_t,psps_norm + shiftval,'k','LineWidth',1);
                    plot(pm_t,psps_smooth_norm + shiftval,'r','LineWidth',2);
                    plot(pm_t,SPWs_norm + shiftval,'kx','LineWidth',2,'MarkerSize',10);
                end
                
                shiftval = shiftval + shift_delta;
                SPW_arr = [SPW_arr SPWs];
            end

            title(['Cellnum=' cellnum_to_name(cellnum)]);
            xlabel('time (s)');
            ylabel('signal (V)');
            
        end

    end
    if plot_spw_rates        
        [plotmat_zeitgeber]= struct2matrix({sim{sim_num}.time{time_range}},'time',[],0, 0);
        figure; plot(plotmat_zeitgeber,sum(SPW_arr)/max(pm_t));
    end
end

if plot_raster
    clear plotmat plotmat_std plotmat_ste plotmat_t
    dat_fieldname_sing='column.hist.ct';
    datfield_t='column.hist.t';
    [plotmat{cellnum}]= struct2matrix({sim{sim_num}.time{timerange_raster}},[dat_fieldname_sing '{' num2str(cellnum) '}'],[],0, 0);
    [plotmat_t{cellnum}]= struct2matrix({sim{sim_num}.time{timerange_raster}},[datfield_t '{' num2str(cellnum) '}'],[],0, 0);
    figure;
    bar(plotmat_t{cellnum},plotmat{cellnum});
    title(['Cellnum=' cellnum_to_name(cellnum)]);
    xlabel('time (s)');
    ylabel('signal (V)');
end

if (plot_auto)
    clear plotmat plotmat_std plotmat_ste plotmat_t
    for cellnum = [cell_range]
        figure; hold on;
        shiftval = 0;
        shift_delta = 1;
        for k = time_range
            if cellnum == 5; opt_struct.shift = 5e-3; dt = sim{sim_num}.os.dt2; else opt_struct.shift = 0; dt = sim{sim_num}.os.dt; end

            shift_delta = 1e0;
            plotmat{cellnum} = sim{sim_num}.time{k}.column.auto.ct{cellnum};
            plotmat_t{cellnum} = sim{sim_num}.time{k}.column.auto.t;

            plot_matrix(plotmat_t{cellnum},plotmat{cellnum} + shiftval,opt_struct);
            shiftval = shiftval + shift_delta;
            SPW_arr = [SPW_arr SPWs];
        end
    end
end


if plot_spws
    clear plotmat plotmat_std plotmat_ste plotmat_t
    dt = sim{sim_num}.os.dt;
    figure;
    shiftval = 0;
    shift_delta = 0.02;
    for k = time_range
            % Plot SPWs
        t = (0:length(sim{sim_num}.time{k}.column.SPW_extract(:,1))-1)*dt;
        hold on; plot(t,sim{sim_num}.time{k}.column.SPW_extract+shiftval);
            % Plot fit
        coefs = sim{sim_num}.time{k}.column.SPW_stats.coefs(:);
        A = coefs(1); sig = coefs(2); mu = coefs(3);
        hold on; plot(t,A*exp(-((t-mu)/sig).^2) + shiftval,'k','Linewidth',2);
        shiftval = shiftval + shift_delta;
    end
end


if plot_matrix_on
    
    for k = time_range
        X_pyr = sim{sim_num}.time{k}.column.rast.ct{4};
        X_bc = sim{sim_num}.time{k}.column.rast.ct{1};
        X_olm = sim{sim_num}.time{k}.column.rast.ct{3};
        X_msg = sim{sim_num}.time{k}.column.rast.ct{2};
        N_pyr = size(X_pyr,2);
        N_bc = size(X_bc,2);
        N_olm = size(X_olm,2);
        N_msg = size(X_msg,2);

%     [s.rast.ct{1} s.sptr.ct{1} s.stats.K.ct{1}] = analyse_data_celltype(path_ld,'b',os);
%     [s.rast.ct{2} s.sptr.ct{2} s.stats.K.ct{2}] = analyse_data_celltype(path_ld,'msg',os);
%     [s.rast.ct{3} s.sptr.ct{3} s.stats.K.ct{3}] = analyse_data_celltype(path_ld,'olm',os);
%     [s.rast.ct{4} s.sptr.ct{4} s.stats.K.ct{4}] = analyse_data_celltype(path_ld,'psoma',os);
    
        figure;
        hold on; X = X_pyr; x=repmat(1:size(X,2),size(X,1),1); plot(X(:),x(:),'b.')
        hold on; X = X_bc; x=repmat((1:size(X,2)) + N_pyr,size(X,1),1); plot(X(:),x(:),'r.')
        hold on; X = X_olm; x=repmat((1:size(X,2)) + N_pyr + N_bc,size(X,1),1); plot(X(:),x(:),'g.')
        hold on; X = X_msg; x=repmat((1:size(X,2)) + N_pyr + N_bc + N_olm,size(X,1),1); plot(X(:),x(:),'m.')
        legend ('pyr','bc','olm','msg');
        xlabel('time (s)'); ylabel('cell number');
        title(['Time ' num2str(sim{sim_num}.time{k}.time)]);
    end
end


