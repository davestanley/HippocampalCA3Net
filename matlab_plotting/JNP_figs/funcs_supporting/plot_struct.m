


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
        if plot_inputs; dat_fieldname_sing_arr = {'EC_val','SCN_val','mel_val','ACh_val','musc_val','Ca_val'}; end
        
    plot_stats = ~plot_traces;
        plot_error = 1;
        plot_efield = 0;
        if plot_efield; cell_range = 1:11; end
        

    if plot_traces
       cell_range=[1:4];
       time_range=8;
       %%%%%% TO DO: Fix KAPPA - It gives non-intuitive values for pyr
        %%% Are initial values biasing? Should I be chopping off some of the
        %%% initial data points?
        %%% Might also need to adjust bin size used by KAPPA.
        
        dat_fieldname_sing='column.hist.ct';
        datfield_t='column.hist.t';
        dat_fieldname_sing='column.sptr.ct';
        datfield_t='';
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
        else
            [plotmat]= struct2matrix({sim{sim_num}.time{time_range}},[dat_fieldname_sing '{' num2str(cellnum) '}'],[],0, 0);
        end
        if plot_error
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
        hold on
%         plotmat_arr(:,1) = plotmat_arr(:,1) - 7;
%         wake_wave = (0.25*cos(2*pi*(plotmat_zeitgeber_arr-14)/24) + 1);
%         plotmat_arr = plotmat_arr.*wake_wave;
        if plot_error; errorbar(plotmat_zeitgeber_arr,plotmat_arr,plotmat_ste_arr); else
        plot(plotmat_zeitgeber_arr,plotmat_arr); end
        legend('basket','msg','olm','pyr');
        title(['Plotting circadian input vs time']);
        % figure; plot(plotmat_zeitgeber_arr, plotmat_input_arr);
    end
end


    % Start for loop.
if plot_inputs
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
    
    for i = 1:length(dat_fieldname_sing_arr)
        dat_fieldname_sing_arr{i} = strrep (dat_fieldname_sing_arr{i}, '_val', '');
    end
    if plot_on
        figure;
        hold on
        plot(plotmat_zeitgeber_arr,plotmat_arr);
        legend(dat_fieldname_sing_arr);
    end
end


if plot_traces
    % Start for loop.
    for cellnum = [cell_range]    
        


        
%             [plotmat_t{cellnum}]= struct2matrix({sim{sim_num}.time{time_range}},[datfield_t '{' num2str(cellnum) '}'],[],0, 0);
            if isempty(datfield_t)
                [plotmat{cellnum}]= struct2matrix({sim{sim_num}.time{time_range}},[dat_fieldname_sing '{' num2str(cellnum) '}'],[],0, 0);
                plotmat{cellnum} = sim{sim_num}.time{time_range}.column.sptr.ct{cellnum};
                

                if cellnum == 5; opt_struct.shift = 5e-3; dt = sim{sim_num}.os.dt2; else opt_struct.shift = 0; dt = sim{sim_num}.os.dt; end
                plotmat_t{cellnum} = [0:(length(plotmat{cellnum})-1)]*dt;
                
                if plot_on; figure; plot_matrix(plotmat_t{cellnum},plotmat{cellnum},opt_struct); end
            else
                [plotmat{cellnum}]= struct2matrix({sim{sim_num}.time{time_range}},[dat_fieldname_sing '{' num2str(cellnum) '}'],[],0, 0);
                [plotmat_t{cellnum}]= struct2matrix({sim{sim_num}.time{time_range}},[datfield_t '{' num2str(cellnum) '}'],[],0, 0);
                if plot_on; figure; bar(plotmat_t{cellnum},plotmat{cellnum}); end
            end
            if plot_on
                title(['Cellnum=' cellnum_to_name(cellnum)]);
                xlabel('time (s)');
                ylabel('signal (V)');
            end
            
        

    end
end



