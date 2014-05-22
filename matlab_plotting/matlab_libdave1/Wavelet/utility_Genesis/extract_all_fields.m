

% Extracts and saves a field from each file


filename{1} = 'pyr01a_Ca_det';
filename{2} = 'pyr01b_Na_det';
filename{3} = 'pyr01c_K_DR_det';
filename{4} = 'pyr01d_K_A_det';
filename{5} = 'pyr01e_K_C_det';
filename{6} = 'pyr01f_K_AHP_det';
filename{7} = 'pyr01g_allmarkov';
filename{8} = 'pyr01h_allmarkov_constCa';
filename{9} = 'pyr01i_Ca_det_constCa';



% Test it on the first one
    i = 1
    fn = filename{i};
%     name = fn(1:(findstr(fn,'sim_out')-2));
    name = fn;
    datafile = load (fn);
    data = datafile;
    
    fid1 = fopen ([name '_info'], 'rt');
    numfields = size(datafile,2);
    j = 2;
    while (1)
        tline = fgetl(fid1);
        if (strcmp(num2str(tline),'-1')); break; end;       % Stop when we reach the end of the file
        if ~(isempty (tline))                           % Make sure this line is not a carrage return
            j = j + 1;
            channelnames{j} = tline(find (tline == '/', 1,'last')+1:end);
        end
    end
    if ~((j) == numfields)
        fprintf ('Error, input number of channel names does not match number of channels in dataset.');
    end
    
%     save (['ac' name], 'data', 'channelnames');
    save ([name], 'data', 'channelnames');

for i = 2:9

    i
    fn = filename{i};
%     name = fn(1:(findstr(fn,'sim_out')-2));
    name = fn;
    datafile = load (fn);
    data = datafile;
    
    fid1 = fopen ([name '_info'], 'rt');
    numfields = size(datafile,2);
    j = 2;
    while (1)
        tline = fgetl(fid1);
        if (strcmp(num2str(tline),'-1')); break; end;       % Stop when we reach the end of the file
        if ~(isempty (tline))                           % Make sure this line is not a carrage return
            j = j + 1;
            channelnames{j} = tline(find (tline == '/', 1,'last')+1:end);
        end
    end
    if ~((j) == numfields)
        fprintf ('Error, input number of channel names does not match number of channels in dataset.');
    end
    
%     save (['ac' name], 'data', 'channelnames');
    save ([name], 'data', 'channelnames');
end


