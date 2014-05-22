
function opt_strct = set_opt_strct_CaRes_Diba


baseline_freq = 0.2;
% baseline_freq = 0.6;


% % extract_all_fields settings
opt_strct.prefilter_on = 1;           % Does the filtering tht is normally listed under the "build_struct" section
                            % instead in the extract_all_fields script.

% % autostruct.m settings
opt_strct.binsize = 20;

% % build_struct.m settings
opt_strct.ds2 = 1;
% opt_strct.baseline_freq = baseline_freq; %Hz
% opt_strct.max_freq_filt = 300; %Hz
opt_strct.baseline_freq = 0.1; %Hz
opt_strct.max_freq_filt = 500; %Hz

% % stats_dave.m settings
opt_strct.lowfreq_min = baseline_freq;
opt_strct.lowfreq_max = 5;
opt_strct.midfreq_min = opt_strct.lowfreq_max;
opt_strct.midfreq_max = 20;
opt_strct.highfreq_min = 50;
opt_strct.highfreq_max = 100;

opt_strct.jlowfreq_min = baseline_freq;
opt_strct.jlowfreq_max = 2;
% opt_strct.jmidfreq_min = 15;
% opt_strct.jmidfreq_max = 35;
opt_strct.jmidfreq_min = 5;          % Values used in thesis
opt_strct.jmidfreq_max = 100;

opt_strct.FFT_bin_size = 1/baseline_freq;
opt_strct.stats_bin_duration = 1/baseline_freq; %seconds

opt_strct.use_wvlets = 0;

opt_strct.clean_filtered=1;
opt_strct.apply_downsample=1;
    opt_strct.ds_num=5;
opt_strct.clean_unfiltered=1;