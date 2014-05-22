

function sim = make_SPWs (sim)

    N_sims = length(sim);
    
    for i = 1:N_sims
        os = sim{i}.os;
        sim{i} = SPW_meanfield (sim{i});
        sim{i} = SPW_identify (sim{i});
        for j = 1:length(sim{i}.time)
            sim{i}.time{j}.column = SPW_extract (sim{i}.time{j}.column,os);
            sim{i}.time{j}.column = SPW_gaussfit (sim{i}.time{j}.column,os);
        end
    end

end

function curr_sim = SPW_identify (curr_sim)

    plot_on = 0;
    plot_test = 0;
    plot_spw_rates = 0;
    time_range = (1:length(curr_sim.time));
    dt = curr_sim.os.dt;
    SPW_refract = round(100e-3 / dt); % Indicies (Seconds / timestep)
    SPW_thresh = 0.3;   % Arb units     %For slow SPW
    SPW_thresh = 0.10;   % Arb units    %For fast SPW
    
    if plot_on; figure(99); hold on; end
    shiftval = 0;
    shift_delta = 60e-3;
    SPW_arr = [];
    
    for k = time_range
        
        % Save data
        pm_t = curr_sim.time{k}.column.SPW.psp_t;
        meanfield = curr_sim.time{k}.column.SPW.meanfield;  % Mean voltage trace of all cells
        meanfield_psps = curr_sim.time{k}.column.SPW.psps;  % Mean PSPs produced by all cells
        psps_smooth = curr_sim.time{k}.column.SPW.psps_smooth;
        
        SPWs = get_spikes(psps_smooth, SPW_thresh, SPW_refract);
        if plot_test;
            figure; plot(pm_t, meanfield_psps);
            hold on; plot(pm_t, psps_smooth,'r');
            hold on; plot(pm_t,SPWs.*psps_smooth,'ro','LineWidth',2);
        end

        psps_norm = meanfield_psps * (max(meanfield)-min(meanfield)) + mean(meanfield);
        psps_smooth_norm = psps_smooth * (max(meanfield)-min(meanfield)) + mean(meanfield);
        SPWs_norm = psps_smooth_norm .* SPWs;
        index = find(SPWs == 0);
        SPWs_norm(index) = NaN;


        if plot_on
            figure (99);
            opt_struct.shift = 0;
            %plot_matrix(plotmat_t{cellnum},plotmat{cellnum} + shiftval,opt_struct);
            hold on; plot(pm_t,meanfield + shiftval,'LineWidth',1);
            plot(pm_t,psps_norm + shiftval,'k','LineWidth',2);
            plot(pm_t,psps_smooth_norm + shiftval,'r','LineWidth',2);
            plot(pm_t,SPWs_norm + shiftval,'ko','LineWidth',2);
            legend('Vm meanfield','PSPs','smoothed_PSPs','Identified SPWs');
        end

        shiftval = shiftval + shift_delta;
        SPW_arr = [SPW_arr SPWs];
        
        % Save data
        curr_sim.time{k}.column.SPW.SPWs = SPWs;
        curr_sim.time{k}.column.SPW_stats.SPW_rate = sum(SPWs)/max(pm_t);
        curr_sim.time{k}.column.SPW_stats.SPW_rate_std=0;
        curr_sim.time{k}.column.SPW_stats.SPW_rate_ste=0;
    end
    
    

end


function s = SPW_extract (s,os)

    plot_on = 0;
    
    dt = os.dt;
    ind_before = round(0.040 / dt); % initial guess at window around spike
    ind_after = round(0.080 / dt);
    ind_before2 = round(0.060 / dt);    % 2nd guess at window
    ind_after2 = round(0.060 / dt);
    index = find(s.SPW.SPWs > 0);
    
    s.SPW_extract = [];
    s.SPW_stats.amp_prenorm = [];
    for i = 1:length(index)
        istart = index(i)-ind_before;
        istop = index(i)+ind_after;
        if (istart > 0 && istop <= length(s.SPW.psps_smooth))
            spw_temp = s.SPW.psps_smooth(istart:istop);
            
            [temp index2] = max(spw_temp);  % Find local maximum of first guess
            index2 = index2 + istart;       % Remove relative coordinates
            istart2 = index2 - ind_before2;
            istop2 = index2 + ind_after2;
            if (istart2 > 0 && istop2 <= length(s.SPW.psps_smooth))
                spw_temp = s.SPW.psps_smooth(istart2:istop2);
                
                
                s.SPW_stats.amp_prenorm = [s.SPW_stats.amp_prenorm mean(spw_temp)];  % Save amplitude
                spw_temp = spw_temp / sum(spw_temp);    % Normalize

                s.SPW_extract = [s.SPW_extract spw_temp];
                
                
            end
        end
        
        
        
    end
    
    s.SPW_stats.amp_prenorm = mean(s.SPW_stats.amp_prenorm);
    
    if plot_on
        figure; plot((0:length(s.SPW_extract)-1)*dt,s.SPW_extract)
    end

end


function s = SPW_gaussfit (s, os)

    plot_on = 0;
    fit_one_at_a_time = 0; % Fit each SPW individually and then average; otherwise, pool & fit
    
    t = (0:size(s.SPW_extract,1)-1)*os.dt;
    t=t(:);
    if plot_on; figure; end
    if fit_one_at_a_time
        amps = [];
        width = [];
        coefs_arr = [];
        for k = 1:size(s.SPW_extract,2)
            coefs0 = [max(s.SPW_extract(:,k)) 0.050 0.060];
            [coefs err] = lsqcurvefit (@gauss, coefs0, t, s.SPW_extract(:,k),-Inf, Inf);
%             [coefs err] = lsqcurvefit (@gauss, coefs0, t, s.SPW_extract(:,k),[0 0 0], [Inf 3*max(t) max(t)]);
            if plot_on
                plot(t,s.SPW_extract(:,k));
                hold on; plot(t,gauss(coefs,t),'r');
            end
            amps = [amps coefs(1)];
            width = [width coefs(2)];
            coefs_arr = [coefs_arr coefs(:)];
        end
    else
        if ~isempty(s.SPW_extract)
            coefs0 = [max(s.SPW_extract(:)) 0.050 0.060];
            %[coefs err] = lsqcurvefit (@gauss, coefs0, t, s.SPW_extract(:,k),-Inf, Inf);
            t_all = repmat(t,size(s.SPW_extract,2),1);
            [coefs err] = lsqcurvefit (@gauss, coefs0, t_all, s.SPW_extract(:),[0 0 0], [Inf 3*max(t) max(t)]);
            if plot_on
                plot(t_all,s.SPW_extract(:),'k.');
                hold on; plot(t,gauss(coefs,t),'r','LineWidth',2);
            end

            amps = coefs(1);
            width = coefs(2);
            coefs_arr = coefs;
        else
            amps = 0;
            width = 0;
            coefs_arr = [0 0 0];
        end
        
    end
    
    s.SPW_stats.amp = mean(amps);
    s.SPW_stats.amp_std = std(amps);
    s.SPW_stats.amp_ste = std(amps)/ length(amps);
    s.SPW_stats.width = mean(width);
    s.SPW_stats.width_std = std(width);
    s.SPW_stats.width_ste = std(width)/ length(width);
    s.SPW_stats.coefs = coefs_arr;

    
    if plot_on
    end
end

% fft_power = abs(fft_val).^2;
% coefs0 = [interp1(f, fft_power, 1) -2];
% [coefs err] = lsqcurvefit (@myfunc, coefs0, f(fit_list), fft_power(fit_list), -Inf, Inf);
% const_est = log10(coefs(1));          %Take log to get it in the same form as loglog curve fitting
% beta_est = coefs(2);


function x = gauss(coefs,t)
    a=coefs(1);
    sig=coefs(2);
    mu = coefs(3);
    
    x = a*exp(-((t-mu)./sig).^2);
end

% function pow = myfunc(coefs, f)
% % Multiscale power function of form power = f^-beta
% 
%     a = coefs(1);
%     b = coefs(2);
%     pow = a*f.^b;
% 
% end



