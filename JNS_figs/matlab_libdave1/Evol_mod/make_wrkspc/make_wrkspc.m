


% function make_wrkspc (sim_num)
	clear
%     if nargin < 1
        sim_num = -1;
%     end
    
    %startup_Evol_dominique
    
    os = set_opt_strct_evol;
    os.settling_time=1.0;

    path_working = pwd;
    path_sim = '.';

    path_dataout = '.';
    run([path_sim '/' path_dataout '/fnamelistfile.m'])
    run([path_sim '/' path_dataout '/varnamelistfile.m'])

    if sim_num > 0
        sim_range = sim_num;
    else
        sim_range = 1:length(fnamelist);
    end
    
    for i = sim_range
    % for i = 1:1
    %     cd ([path_sim '/' fnamelist{i}]);
        i
        clear circnamelist
        run ([path_sim '/' fnamelist{i} '/circnamelistfile.m']);
        sim{i}.fname=fnamelist{i}; sim{i}.varname=varnamelist{i};
        for j = 1:length(circnamelist)
    %     for j = 1:1
    %         cd ([path_sim '/' circnamelist{j}]);
            j
            if (i==4 & j==2)
                j
            end
            path_ld = [path_sim '/' circnamelist{j}];
            if exist([path_ld '/circvalfile.m'])
                run([path_ld '/circvalfile.m']);
                musc_circscale(j) = -10;
            else
                SCN_val(j) = -10;
                mel_val(j) = -10;
                EC_val(j) = -10;
                ACh_val(j) = -10;
                musc_circscale(j) = -10;
                Ca_val(j) = -10;
                msg_to_bas(j) = -10;
            end

            sim{i}.time{j}.circnamelist=circnamelist{j};

            sim{i}.time{j}.EC_val=EC_val(j);
            sim{i}.time{j}.SCN_val=SCN_val(j);
            sim{i}.time{j}.mel_val=mel_val(j);
            sim{i}.time{j}.ACh_val=ACh_val(j);
            sim{i}.time{j}.musc_val=musc_circscale(j);
            sim{i}.time{j}.Ca_val=Ca_val(j);
            currexp = fnamelist{i}; currtime=circnamelist{j}; sim{i}.time{j}.time = str2num(currtime(length(currexp)+3:end));
            if exist ('ACh_level'); sim{i}.time{j}.ACh_level=ACh_level(j); end
            if exist ('ACh_accom_scale'); sim{i}.time{j}.ACh_accom_scale=ACh_accom_scale(j); end
            if exist ('ACh_Esyn_scale'); sim{i}.time{j}.ACh_Esyn_scale=ACh_Esyn_scale(j); end
            if exist ('ACh_Isyn_scale'); sim{i}.time{j}.ACh_Isyn_scale=ACh_Isyn_scale(j); end
            if exist ('ACh_pyr_inj'); sim{i}.time{j}.ACh_pyr_inj=ACh_pyr_inj(j); end
            if exist ('ACh_bc_inj'); sim{i}.time{j}.ACh_bc_inj=ACh_bc_inj(j); end
            if exist ('ACh_olm_inj'); sim{i}.time{j}.ACh_olm_inj=ACh_olm_inj(j); end
            if exist ('Ca_val'); sim{i}.time{j}.Ca_val=Ca_val(j); end
            if exist ('percent_msg_intact'); sim{i}.time{j}.percent_msg_intact=percent_msg_intact(j); end
            if exist ('percent_ACh_intact'); sim{i}.time{j}.percent_ACh_intact=percent_ACh_intact(j); end
            

            [sim{i}.time{j}.column, os]=build_evol(path_ld,os);
            if ~isempty(sim{i}.time{j}.column.rast.ct{1})
                sim{i}.time{j}.column=stats_evol(sim{i}.time{j}.column,os);
                sim{i}.time{j}.column=clean_evol(sim{i}.time{j}.column, os.ncells);
            else
                for k = 1:4         % If files are missing, fill stats columns with -1's.
                    sim{i}.time{j}.column.stats.amp.ct{k} = -1;
                    sim{i}.time{j}.column.stats.amp.ct_std{k} = -1;
                    sim{i}.time{j}.column.stats.amp.ct_ste{k} = -1;
                    sim{i}.time{j}.column.stats.period1.ct{k} = -1;
                    sim{i}.time{j}.column.stats.period1.ct_std{k} = -1;
                    sim{i}.time{j}.column.stats.period1.ct_ste{k} = -1;
                    sim{i}.time{j}.column.stats.period2.ct{k} = -1;
                    sim{i}.time{j}.column.stats.period2.ct_std{k} = -1;
                    sim{i}.time{j}.column.stats.period2.ct_ste{k} = -1;
                end
                sim{i}.time{j}.column.stats.std{5} = -1;
                sim{i}.time{j}.column.stats.stderr{5} = -1;
            end
        end
        sim{i}.os = os;
    end

    %sim = make_SPWs(sim);
%     save('wrkspc.mat','sim')
    save('wrkspc.mat','sim','-v7.3')
%     if sim_num > 0
%         save(['wrkspc_' num2str(sim_num) '.mat'],'sim','-mat');
%     else
%         save('wrkspc.mat','sim','-mat')
%     end

% end








