


% Delete some of the excess pyramidal cell traces
N_pyr = 3;
clear sim_trim
for i = 1:length(sim)
    sim_trim{i} = sim{i};
    for j = 1:length(sim{i}.time)
        sim_trim{i}.time{j}.column.sptr.ct{4} = sim_trim{i}.time{j}.column.sptr.ct{4}(:,1:N_pyr); 
    end
end

% Remove the raster and autocorrelation fields from the structure
clear sim_trim2
for i = 1:length(sim_trim)
    sim_trim2{i} = sim_trim{i};
    for j = 1:length(sim_trim{i}.time)
        sim_trim2{i}.time{j} = rmfield(sim_trim{i}.time{j},'column');
%         if isfield(sim_trim{i}.time{j}.column, 'rast'); sim_trim2{i}.time{j}.column.rast = sim_trim{i}.time{j}.column.rast; end
        if isfield(sim_trim{i}.time{j}.column, 'sptr'); sim_trim2{i}.time{j}.column.sptr = sim_trim{i}.time{j}.column.sptr; end
        if isfield(sim_trim{i}.time{j}.column, 'stats'); sim_trim2{i}.time{j}.column.stats = sim_trim{i}.time{j}.column.stats; end
%         if isfield(sim_trim{i}.time{j}.column, 'auto'); sim_trim2{i}.time{j}.column.auto = sim_trim{i}.time{j}.column.auto; end
        if isfield(sim_trim{i}.time{j}.column, 'hist'); sim_trim2{i}.time{j}.column.hist = sim_trim{i}.time{j}.column.hist; end
        if isfield(sim_trim{i}.time{j}.column, 'SPW'); sim_trim2{i}.time{j}.column.SPW = sim_trim{i}.time{j}.column.SPW; end
        if isfield(sim_trim{i}.time{j}.column, 'SPW_stats'); sim_trim2{i}.time{j}.column.SPW_stats = sim_trim{i}.time{j}.column.SPW_stats; end
        if isfield(sim_trim{i}.time{j}.column, 'SPW_extract'); sim_trim2{i}.time{j}.column.SPW_extract = sim_trim{i}.time{j}.column.SPW_extract; end
        
    end
end



