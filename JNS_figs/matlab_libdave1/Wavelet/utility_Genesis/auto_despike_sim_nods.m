

% Extracts and saves a field from each file
% Same as standard auto_despike.m, except we have
% the paramaters optimized for the case when there
% is no downsampling of the model data

fnarr{1} = 'fb0s_onlybase';
fnarr{2} = 'fb1s_onlyPSP';
fnarr{3} = 'fb2s_det_PSPs';
fnarr{4} = 'fb4s_stoch_PSPs';
fnarr{5} = 'fb5s_det_PSPs';
fnarr{6} = 'fb6s_bstoch_PSPs';
fnarr{7} = 'fb7s_bdet_PSPs';
fnarr{8} = 'fb8s_bstochPSP_m';
fnarr{9} = 'fb8s_bstochPSP_m2';

fnarr{10} = 'fb0s_balance_first_try';
fnarr{11} = 'fb3s_fix_GABAB';
fnarr{12} = 'fb19_w2f_all';

fnarr{13} = 'fb0s_onlyion';
fnarr{14} = 'fb1s_stoch';
fnarr{15} = 'fb2s_det';
fnarr{16} = 'fb3sonly_stoch';
fnarr{17} = 'fb4sonly_det';

fnarr{18} = 'fb0s_base_m50m45';
fnarr{19} = 'fb0s_base_m45m45';
fnarr{20} = 'fb0s_base_m40m40';
fnarr{21} = 'fb0s_base_m35m35';

fnarr{22} = 'acsf';


fnarr{21} = 'fb0s_ap62';
fnarr{22} = 'fb0s_ap62_det';
fnarr{23} = 'fb0s_ap62_det_soma';
fnarr{24} = 'fb0s_ap62_soma';
fnarr{25} = 'fb0s_ap92';
fnarr{26} = 'fb0s_ap92_det';
fnarr{27} = 'fb0s_ap92_det_soma';
fnarr{28} = 'fb0s_ap92_soma';
fnarr{29} = 'fb0s_bas12';
fnarr{30} = 'fb0s_bas12_det';
fnarr{31} = 'fb0s_bas12_det_soma';
fnarr{32} = 'fb0s_bas12_soma';



fnarr{91} = 'fb5s_stoch_noAMPA';
fnarr{92} = 'fb5sb_stoch_defaulttest';




datastart = 1; % AFter the PID is finished...
downsamp = 1;
plotting = 1;


% Test it on the first one
    i = 5
    fn = fnarr{i};
    if ~(isempty(fn))

        data_orig = load (fn);

        data_orig_start = data_orig(1:datastart,:);
        s = data_orig(datastart+1:end,:);
        s = downsample(s,downsamp);


        [jcs spk] = spikinator_dav3(s(:,2),10000,5,0, 0, 0.5, 0.2,2500);  % Everything scaled up due to smaller dt
        jcs = [ s(1:length(jcs),1) jcs ];
        data = [data_orig_start; jcs];

        if (plotting)
            figure; plotarr([data_orig_start; s]);
            hold on; plotarr(data, 'r');
%             hold on; plotarr(data_orig,'g');
            legend ('original','despiked');
        end
        channelnames = 'Vm';
        save (fn, 'data', 'channelnames');

    end



for i = 50:54
    i
    fn = fnarr{i};
    if ~(isempty(fn))

        data_orig = load (fn);

        data_orig_start = data_orig(1:datastart,:);
        s = data_orig(datastart+1:end,:);
        s = downsample(s,downsamp);


        [jcs spk] = spikinator_dav3(s(:,2),2000,10,0, 0, 0.5, 0.2,500);
        jcs = [ s(1:length(jcs),1) jcs ];
        data = [data_orig_start; jcs];

        if (plotting)
            figure; plotarr([data_orig_start; s]);
            hold on; plotarr(data, 'r');
            hold on; plotarr(data_orig,'g');
            legend ('original','despiked', 'original');
        end
        channelnames = 'Vm';
        save (fn, 'data', 'channelnames');
    end
end
