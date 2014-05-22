
function curr_sim = SPW_meanfield (curr_sim)

time_range = (1:length(curr_sim.time));
dt = curr_sim.os.dt;

plot_test = 0;
AP_thresh = -0.030; % Volts

smooth_window = 0.050; % Seconds
H_tau = 20e-3; % Seconds    (slow)
    
smooth_window = 0.020; % Seconds
H_tau = 5e-3; % Seconds     (fast)


% Start for loop.
cellnum=4;



for k = time_range

    plotmat{cellnum} = curr_sim.time{k}.column.sptr.ct{cellnum};
    plotmat_t{cellnum} = [0:(length(plotmat{cellnum})-1)]*dt;
    meanfield = mean((plotmat{cellnum})');

    pm_t = plotmat_t{cellnum};
    hpsp = (exp(-pm_t(1:end) ./ H_tau));
    % hpsp = zeros(1,length(hpm_t)); hpsp(1) = 1;
    pm = plotmat{cellnum};
    spikes = get_spikes (pm, AP_thresh, 0);
    if plot_test; figure; plot (pm);
        hold on; plot(spikes.*pm,'o'); end
    psps = [];
    for kk = 1:size(pm,2)
        psps(:,kk) = conv(hpsp,spikes(:,kk));
    end

    psps = psps(1:length(pm_t),:);
    if plot_test; figure; plot(pm_t, psps); end

    meanfield_psps = mean(psps')';
    psps_smooth = 1/round(smooth_window/dt) * conv(meanfield_psps, ones(round(smooth_window/dt),1));
    psps_smooth = wkeep(psps_smooth, size(pm,1), 'c');

%     SPWs = get_spikes(psps_smooth, SPW_thresh, SPW_refract);
%     if plot_test;
%         figure; plot(pm_t, meanfield_psps);
%         hold on; plot(pm_t, psps_smooth,'r');
%         hold on; plot(pm_t,SPWs.*psps_smooth,'ro','LineWidth',2);
%     end

%     psps_norm = meanfield_psps * (max(meanfield)-min(meanfield)) + mean(meanfield);
%     psps_smooth_norm = psps_smooth * (max(meanfield)-min(meanfield)) + mean(meanfield);
%     SPWs_norm = psps_smooth_norm .* SPWs;
%     index = find(SPWs == 0);
%     SPWs_norm(index) = NaN;


%     if plot_on
%         figure (99);
%         opt_struct.shift = 0;
%         plot_matrix(plotmat_t{cellnum},plotmat{cellnum} + shiftval,opt_struct);
%         hold on; plot(plotmat_t{cellnum},meanfield + shiftval,'LineWidth',1);
%         plot(pm_t,psps_norm + shiftval,'k','LineWidth',2);
%         plot(pm_t,psps_smooth_norm + shiftval,'r','LineWidth',2);
%         plot(pm_t,SPWs_norm + shiftval,'ko','LineWidth',2);
%     end
% 
%     shiftval = shiftval + shift_delta;
%     SPW_arr = [SPW_arr SPWs];


    % Save data
    curr_sim.time{k}.column.SPW.psp_t = pm_t;
    curr_sim.time{k}.column.SPW.meanfield = meanfield;  % Mean voltage trace of all cells
    curr_sim.time{k}.column.SPW.psps = meanfield_psps;  % Mean PSPs produced by all cells
    curr_sim.time{k}.column.SPW.psps_smooth = psps_smooth;
    
    
%     curr_sim.time{k}.column.SPW.SPWs = SPWs;
%     curr_sim.time{k}.column.SPW_stats.SPW_rate = sum(SPWs)/max(pm_t);
%     curr_sim.time{k}.column.SPW_stats.SPW_rate_std=0;
%     curr_sim.time{k}.column.SPW_stats.SPW_rate_ste=0;

end
if plot_test;
    title(['Cellnum=' cellnum_to_name(cellnum)]);
    xlabel('time (s)');
    ylabel('signal (V)');
end


% if plot_spw_rates        
%     [plotmat_zeitgeber]= struct2matrix({curr_sim.time{time_range}},'time',[],0, 0);
%     figure; plot(plotmat_zeitgeber,sum(SPW_arr)/max(pm_t));
% end


end