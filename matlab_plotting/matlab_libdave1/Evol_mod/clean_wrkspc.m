



clear sim_clean
for i = 1:length(sim)
    sim_clean{i} = sim{i};
    for j = 1:length(sim{i}.time)
        sim_clean{i}.time{j} = rmfield(sim{i}.time{j},'column');
%         if isfield(sim{i}.time{j}.column, 'rast'); sim_clean{i}.time{j}.column.rast = sim{i}.time{j}.column.rast; end
%         if isfield(sim{i}.time{j}.column, 'sptr'); sim_clean{i}.time{j}.column.sptr = sim{i}.time{j}.column.sptr; end
        if isfield(sim{i}.time{j}.column, 'stats'); sim_clean{i}.time{j}.column.stats = sim{i}.time{j}.column.stats; end
%         if isfield(sim{i}.time{j}.column, 'auto'); sim_clean{i}.time{j}.column.auto = sim{i}.time{j}.column.auto; end
        if isfield(sim{i}.time{j}.column, 'hist'); sim_clean{i}.time{j}.column.hist = sim{i}.time{j}.column.hist; end
        if isfield(sim{i}.time{j}.column, 'SPW'); sim_clean{i}.time{j}.column.SPW = sim{i}.time{j}.column.SPW; end
        if isfield(sim{i}.time{j}.column, 'SPW_stats'); sim_clean{i}.time{j}.column.SPW_stats = sim{i}.time{j}.column.SPW_stats; end
        if isfield(sim{i}.time{j}.column, 'SPW_extract'); sim_clean{i}.time{j}.column.SPW_extract = sim{i}.time{j}.column.SPW_extract; end
        
    end
end




