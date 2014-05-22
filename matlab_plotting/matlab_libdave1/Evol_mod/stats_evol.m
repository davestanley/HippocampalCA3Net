
function s = stats_evol(s,os)

    for i = 1:4
        [s.auto.ct{i} s.auto.t ] = calc_auto(s.sptr.ct{i}, os); % Get autocorrelation
        [s.hist.ct{i} s.hist.t{i} ] = calc_hist(s.rast.ct{i}, os); % Get raster plots

        % Amplitude
            s.stats.amp.ct{i} = mean(s.hist.ct{i}) / size(s.rast.ct{i},2) / os.binsize ;
            s.stats.amp.ct_std{i} = std(s.hist.ct{i}) / size(s.rast.ct{i},2) / os.binsize;
            s.stats.amp.ct_ste{i} = std(s.hist.ct{i}) / size(s.rast.ct{i},2) / length(s.hist.ct{i}) / os.binsize;

        % Period 1
            [s.stats.period1.ct{i} s.stats.period1.ct_std{i} s.stats.period1.ct_ste{i}] = calcperiod_countspikes(s.rast.ct{i}, os);

        % Period 2
            [s.stats.period2.ct{i} s.stats.period2.ct_std{i} s.stats.period2.ct_ste{i}] = calcperiod_diff(s.rast.ct{i}, os);
    end
    
    for i = 5:5
        [rows cols] = size(s.sptr.ct{5});
        t = [0:(rows-1)]*os.dt;
        
        [s.stats.std{i} s.stats.stderr{i}] = dave_binoverlap_stats2(t, s.sptr.ct{i}, os.stats_bin_duration,'std(x)');
%         [s.stats.stdnov{i} s.stats.stdnoverr{i}] = dave_bin_stats(t, s.sptr.ct{i}, os.stats_bin_duration,'std(x)');
    end
end


function [plotmat tout] = calc_auto (X, os)
    plot_on = 0;
    max_traces = os.max_traces;
    dt = os.dt;
    
    [rows cols] = size(X);

    
        plotmat = [];
        for j = 1:min(max_traces, cols);
            t = (0:size(X,1)-1)*dt;
            cell1 = X(:,j);
            [xout, tout] = davexcorr (t,cell1,cell1,1,0);
            plotmat = [plotmat xout];
        end
        if plot_on; figure; plot(tout, plotmat); end
end

function [data t] = calc_hist (X, os)
    
    plot_on = 0;
    binsize = os.binsize;
    
    
    % Createspike time histogram
    [rows cols] = size(X);
    Xall = reshape(X, rows*cols, 1);
    Xall = Xall( find(Xall > 0) );
    
    starttime = 0.0;
    endtime = os.maxtime - os.settling_time;
    
    nbins = round((endtime-starttime)/binsize);
%     nbins = round((max(Xall)-min(Xall))/binsize);
    if isempty(Xall)
        n = zeros(1,nbins);
        xout = 1:nbins;
        xout=xout(:);
    else
        [n xout] = hist(Xall,nbins);
    end
    t = xout(1:end);
    data=n(1:end);

%     figure; plot(xout(2:end),n(2:end),'b');
    if plot_on;
        figure; bar(t,data);
%         [temp_val temp_ind] = find (xout > 1, 1, 'first');
%         axis([1 4 0 max(n(temp_ind:end))]);
        xlabel('Time (s)');
        ylabel('Number of cells firing');
        title(['Firing histogram']);
    end
    
    data=data(:);
    t=t(:);

end


function [fr_mean fr_std fr_ste] = calcperiod_countspikes(X, os)
    % Count the number of spikes of each neuron that occured during the simulation
    % to determine average firing rate.
    plot_on=0;
    
%     maxtime = max(max(X)); % Assume time of last spike equals time of simulation.
    maxtime = os.maxtime - os.settling_time;
    [row col] = size(X);
    
    spike_matrix = (X > 0);
    num_spikes_new = sum(spike_matrix);
    
    
    
    % % % % Old way % % % %
    
        [nrow ncol] = find (X > 0);

        firing_columns = unique(ncol);
        [num_spikes, firing_columns2] = hist(ncol, firing_columns);
        firing_columns2=firing_columns2(:); firing_columns=firing_columns(:);

            % Sanity check! --  firing_columns and firing_columns2 should be the same
        if (sum(abs(firing_columns2-firing_columns)) ~= 0);
            fprintf('Error, mismatch calculating period spiketime. \n');
        end

        % Include non-spiking neurons
        num_spikes_all = zeros(1, col);
        all_columns = 1:col;
        num_spikes_all(firing_columns2) = num_spikes;

    % % % % Old way % % % %
    
    % Compare new and old ways!
    %if (sum(abs(num_spikes_new-num_spikes_all)) ~= 0); fprintf('Error, disagreement between calculating period in method 1. \n'); end
    firing_rate = num_spikes_new / maxtime;
    
    if plot_on; figure; plot(all_columns,firing_rate,'-o'); end

    fr_mean = mean(firing_rate);
    fr_std = std(firing_rate);  %Standard deviation
    fr_ste = fr_std / col;  % Standard error
    
end


function [fr_mean fr_std fr_ste] = calcperiod_diff(X,os)
    % Take the mean time difference between spikes to determine firing
    % rate.
    plot_on = 0;
    [row col] = size(X);
    maxtime = os.maxtime - os.settling_time;
    
    if row > 1
        Xdiff = diff(X);
        for k = 1:col
            if (max(X(:,k)) <= 0) % No spikes
                firing_rate(k) = 0;
            elseif length(find(X(:,k) > 0)) == 1    % One spike
                firing_rate(k) = 1 / maxtime;   % Assume firing rate is once per simulation, to match up with other calcperiod method.
            else                            % At least 2 spikes
                xdiff = Xdiff(:,k);
                index = find(xdiff > 0);
                mean_ISI = mean(xdiff(index));
                firing_rate(k) = 1/mean_ISI;
            end
        end

        if plot_on; figure; plot(firing_rate, '-o'); end

        fr_mean = mean(firing_rate);
        fr_std = std(firing_rate);  %Standard deviation
        fr_ste = fr_std / col;  % Standard error
    
    else
       fprintf('Cannot get firing rate - no spikes observed! \n');
       fr_mean=0; fr_std=0; fr_ste=0;
    end
end

