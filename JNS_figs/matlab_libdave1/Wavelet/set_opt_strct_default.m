
function opt_strct = set_opt_strct_default




% % build_struct.m settings
opt_strct.ds2 = 1;
opt_strct.baseline_freq = 0.2; %Hz
opt_strct.max_freq_filt = 5000; %Hz



% % stats_dave.m settings
opt_strct.lowfreq_min = 0.2;
opt_strct.lowfreq_max = 5;
opt_strct.midfreq_min = opt_strct.lowfreq_max;
opt_strct.midfreq_max = 20;
opt_strct.highfreq_min = 50;
opt_strct.highfreq_max = 100;

opt_strct.jlowfreq_min = 0.2;
opt_strct.jlowfreq_max = 2;
% opt_strct.jmidfreq_min = 15;
% opt_strct.jmidfreq_max = 35;
opt_strct.jmidfreq_min = 5;          % Values used in thesis
opt_strct.jmidfreq_max = 100;

opt_strct.FFT_bin_size = 5;
opt_strct.stats_bin_duration = 5; %seconds