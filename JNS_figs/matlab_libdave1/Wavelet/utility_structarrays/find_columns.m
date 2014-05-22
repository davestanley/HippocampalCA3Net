
function column_nums = find_columns (channelnames, desirednames_arr)

    column_nums=[];

    for j = 1:length(desirednames_arr)
        currname = desirednames_arr{j};
        curr_column_num = -1;
        for i = 1:length(channelnames)
            currchan = channelnames{i};
            strloc = findstr(currchan, currname);
                                    % Need to make sure that currchan is
                                    % the longer string because of how
                                    % findstr works
            if ~isempty(strloc) && (length(currchan)>=length(currname));
                curr_column_num = i; break;
            end
        end
        curr_column_num;
        column_nums = [column_nums, curr_column_num];
    end    
end
