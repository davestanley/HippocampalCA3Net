
function opt_strct = set_opt_strct_CaRes


baseline_freq = 0.05;

% % autostruct.m settings
opt_strct.binsize = 60;

% % build_struct.m settings
opt_strct.ds2 = 1;
opt_strct.baseline_freq = baseline_freq; %Hz
opt_strct.max_freq_filt = 300; %Hz

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

opt_strct.use_wvlets = 1;

opt_strct.clean_filtered=0;
opt_strct.apply_downsample=0;
    opt_strct.ds_num=-1;
opt_strct.clean_unfiltered=0;