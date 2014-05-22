
function os = set_opt_strct_evol 

    os.dt = 5e-4;
    os.dt2 = 1e-4;
    os.binning_int=1e-2; % 10 milliseconds (Hajos et al, 2004); used to calculate kappa
    os.max_traces = 3;
    os.binsize = 0.02;
    os.stats_bin_duration = 1.0;    % Bin duration of 1 second
    os.ncells = 3; % Number of timeseries to store for each cell type

end