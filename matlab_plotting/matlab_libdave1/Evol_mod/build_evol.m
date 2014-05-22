

function [s, os] = build_evol(path_ld,os)

    [s.rast.ct{1} s.sptr.ct{1} s.stats.K.ct{1}] = analyse_data_celltype(path_ld,'b',os);
    [s.rast.ct{2} s.sptr.ct{2} s.stats.K.ct{2}] = analyse_data_celltype(path_ld,'msg',os);
    [s.rast.ct{3} s.sptr.ct{3} s.stats.K.ct{3}] = analyse_data_celltype(path_ld,'olm',os);
    [s.rast.ct{4} s.sptr.ct{4} s.stats.K.ct{4}] = analyse_data_celltype(path_ld,'psoma',os);
    [s.rast.ct{5} s.sptr.ct{5} s.stats.K.ct{5}] = analyse_data_celltype(path_ld,'efield_arr',os);

    os.maxtime = os.dt * (size(s.sptr.ct{1},1)-1); % Base max simulation time on length of spike trace and stepsize.
    s = remove_settling_time(s, os, os.settling_time);
end



function [X_rast X_sptr K ] = analyse_data_celltype (path_ld, celltype, os)


    % Data variables
    plot_on = 1;
    dt = 5e-4;
    binning_int=1e-2; % 10 milliseconds (Hajos et al, 2004)
    max_traces = 3;
        % If raster = 0, can set these!
            plot_traces=1;
            plot_autocorr=0;


    if exist('os','var')
        if isfield(os,'dt'); dt = os.dt; end;
        if isfield(os,'binning_int'); binning_int = os.binning_int; end;
    end
    
    raster = 1;
    if raster == 1
        raster_or_train = 'raster_';
    else
        raster_or_train = 'sptr_';
    end
    X_rast = load_files2mat (path_ld, raster_or_train, celltype);
    
    [rows cols] = size(X_rast);
    range_max = 1:cols;
    if ~strcmp(celltype,'efield_arr')
        %K = get_me_kappa ([path_ld '/' 'raster_' celltype '%d.dat'],range_max, binning_int);
        K=0;
    else
        K=0;
    end
    
    
    raster = 0;
    if raster == 1
        raster_or_train = 'raster_';
    else
        raster_or_train = 'sptr_';
    end
    X_sptr = load_files2mat (path_ld, raster_or_train, celltype);

    

end


function s = remove_settling_time (s, os, stime)

    if nargin < 2
        stime = 1.0;
    end
    

    for i = 1:length(s.sptr.ct)
        dat = s.sptr.ct{i};
        dt = get_dt(os, i);
        t = [0:(size(dat,1)-1)]*dt;
        sindex = find (t >= stime, 1, 'first');     % Lazy coding, I know
        s.sptr.ct{i} = dat(sindex:end, :);
    end
    
    for i = 1:4
        dat = s.rast.ct{i};
        dat = dat - stime;
        % dat = (dat > 0) .* dat;
        
        [rows cols] = size(dat);
        newrowlength = [];
        for j = 1:cols
            sindex = find (dat(:,j) > 0);
            newcol = dat(sindex,j);
            newrowlength(j) = length(newcol);
            dat(:,j) = zeros(rows, 1);
            dat(1:length(newcol),j) = newcol;
        end
        dat = dat(1:(max(newrowlength) + 1),:);
        
        s.rast.ct{i} = dat;
    end

    
end