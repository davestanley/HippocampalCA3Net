

% Expected variables

% pathloc = path_data_mat;  specifies the path of the data
% tofilt = 'y';             specifies whether or not to apply smartfilter
% starting_val = 1;         disregard data points before this
% ismat = 1;                set to 1 if input file 'name' is a .mat binary
% name = 'ic1acsf';         name of input file (without the .mat)


% % Same as autostruct, except expects a time input, starting_time
% % instead of an index input, starting_val

split_dataset = 1;
rebuild_from_scratch = 1;

if ~exist('desired_data_column','var')
    desired_data_column = 2;
end

if ~exist('opt_strct','var');       % A pre-specified structure containing options for statistical analysis
    opt_strct = set_opt_strct_default;
end


use_wvlets = 1;
if isfield (opt_strct, 'use_wvlets'); use_wvlets = opt_strct.use_wvlets; end

if isfield (opt_strct, 'prefilter_on');
    prefilter_on = opt_strct.prefilter_on;
    if prefilter_on
        tofilt='n';
    end
end



if (ismat)
    if (rebuild_from_scratch)       % If we're not rebuilding from scratch, assume dataset already exists
        filename = [pathloc name '.mat'];
        load (filename)
    end
else                        % Legacy....
    if (rebuild_from_scratch)
        filename = name;
        data = load ([pathloc filename]);
    end
end


% If have full dataset including currents, pick the data column we want to use
if size(data,2) > 2
    data = [data(:,1) data(:,desired_data_column)];
end



if (split_dataset == 1)

    % Remove pre-starting value stuff
    if exist ('starting_time', 'var')
        starting_val = find (data(:,1) >= starting_time,1','first');
    end


    data = data (starting_val:end,:);
    dt = data(end,1) - data(end-1,1);
    data(:,1) = (0:length(data)-1)*dt;

    bin_size = opt_strct.binsize; % Seconds

    curr_time = 0;
    nbins = 0;
    time_start = find (data(:,1) > bin_size*nbins, 1, 'first');
    time_stop = find (data(:,1) >= bin_size*(nbins+1), 1, 'first');
    clear binstats;

    while ~isempty(time_stop)

        s = build_struct('-1', [data(time_start:time_stop,1) data(time_start:time_stop,2)], tofilt, 1, opt_strct);
        s = stats_dave (s, opt_strct);
        s = betas_dave(s, opt_strct);
        s = clean_struct(s, opt_strct);
    %     eval ([ name ' = s;']);

        nbins = nbins + 1;
        time_start = find (data(:,1) > bin_size*nbins, 1, 'first');
        time_stop = find (data(:,1) >= bin_size*(nbins+1), 1, 'first');

        binstats{nbins}.statsdata = s.statsdata;
        binstats{nbins}.general_beta_est = s.general_beta_est;
        binstats{nbins}.specstd = s.specstd;

    end


    % Actually, instead, run the full data set through no matter what!
    % if (nbins == 0)             % Even if nbins is 1, may as well get the most out of our data
        % % Run it a final time on the full dataset
        s = build_struct('-1', [data(:,1) data(:,2)], tofilt, 1, opt_strct);
        s = stats_dave (s, opt_strct);
        s = betas_dave(s, opt_strct);
        s = clean_struct(s, opt_strct);
    %     eval ([ name ' = s;']);
    % end



    if nbins > 1
        include_error = 1;
        clear name_arr
        for i = 1:nbins
            name_arr{i} = ['binstats{' num2str(i) '}'];
        end
        
        stats_suffix = '.statsdata.mean'; batch_avg; s.statsdata.mean = avg; s.statsdata.meanerr = sterr; s.statsdata.meanspread = avg_spread;
        stats_suffix = '.statsdata.std'; batch_avg; s.statsdata.std = avg; s.statsdata.stderr = sterr; s.statsdata.stdspread = avg_spread;
        stats_suffix = '.statsdata.skew'; batch_avg; s.statsdata.skew = avg;  s.statsdata.skewerr = sterr; s.statsdata.skewspread = avg_spread;
        stats_suffix = '.statsdata.kurt'; batch_avg; s.statsdata.kurt = avg;  s.statsdata.kurterr = sterr; s.statsdata.kurtspread = avg_spread;
%         stats_suffix = '.statsdata.gauspdf'; batch_avg; s.statsdata.gauspdf = avg;  s.statsdata.gauspdferr = sterr; s.statsdata.gauspdfspread = avg_spread;
        stats_suffix = '.general_beta_est.beta_est'; batch_avg; s.general_beta_est.beta_est = avg;  s.general_beta_est.beta_esterr = sterr; s.statsdata.general_beta_est.beta_estspread = avg_spread;
        if use_wvlets; stats_suffix = '.general_beta_est.wvbeta_est'; batch_avg; s.general_beta_est.wvbeta_est = avg;  s.general_beta_est.wvbeta_esterr = sterr; s.statsdata.general_beta_est.wvbeta_estspread = avg_spread; end
        stats_suffix = '.specstd.low'; batch_avg; s.specstd.low = avg; s.specstd.lowerr = sterr; s.specstd.lowspread = avg_spread;    
        stats_suffix = '.specstd.mid'; batch_avg; s.specstd.mid = avg; s.specstd.miderr = sterr; s.specstd.midspread = avg_spread;
        stats_suffix = '.specstd.high'; batch_avg; s.specstd.high = avg; s.specstd.higherr = sterr; s.specstd.highspread = avg_spread;        
        stats_suffix = '.specstd.jlow'; batch_avg; s.specstd.jlow = avg; s.specstd.jlowerr = sterr; s.specstd.jlowspread = avg_spread;    
        stats_suffix = '.specstd.jmid'; batch_avg; s.specstd.jmid = avg; s.specstd.jmiderr = sterr; s.specstd.jmidspread = avg_spread;    


    end

    s.opt_strct = opt_strct;
    eval ([ name ' = s;']);


else
    if (rebuild_from_scratch)
        s = build_struct('-1', [data(:,1) data(:,2)], tofilt, starting_val, opt_strct);
    else 
        eval ([ 's = ' name ';' ]);
    end
%     s = stats_dave (s, opt_strct);
%     s = betas_dave(s);
    s = lyap_struct (s);
    eval ([ name ' = s;']);
    bin_size = -1;
    nbins = 0;
    
end


fprintf ('Number of %g sec cell recordings averaged: %d\n',bin_size,nbins);
clear data dt bin_size curr_time nbins time_start time_stop binstats include_error name_arr stats_suffix starting_val starting_time;


% auto_write.m





