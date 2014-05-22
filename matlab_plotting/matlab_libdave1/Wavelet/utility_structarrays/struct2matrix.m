

function [dataout legarr]= struct2matrix (struct, fieldname, legfield, normalize_columns, sub_min)
    dataout = [];
    legarr{1} = '-1';
    for i = 1:length(struct)
        eval (['dat = struct{i}.' fieldname ';']);
        dat=dat(:);
        if exist('sub_min','var')
            [temp_min temp_ind] = min(abs(dat));
            if (sub_min); dat = dat - dat(temp_ind); end
        end
        if exist('normalize_columns','var')
            if (normalize_columns); dat = dat / max(abs(dat)); end
        end
        
        [row col] = size(dataout);
        [r2 c2] = size(dat);
        if (row > r2); dat = [dat; -1*ones(row-r2,c2)];   % Pad dat with minus ones as needed
        elseif (r2 > row); dataout = [dataout; -1*ones(r2-row, col)];end
        dataout=[dataout dat];
        if exist('legfield', 'var')
            if ~isempty (legfield)
            eval (['legarr{i} = struct{i}.' legfield ';']);
            end
        end

    end
end




% % Original code
% function [dataout legarr]= struct2matrix (struct, fieldname, legfield, normalize_columns, sub_min)
%     dataout = [];
%     legarr{1} = '-1';
%     for i = 1:length(struct)
%         eval (['dat = struct{i}.' fieldname ';']);
%         dat=dat(:);
%         if exist('sub_min','var')
%             [temp_min temp_ind] = min(abs(dat));
%             if (sub_min); dat = dat - dat(temp_ind); end
%         end
%         if exist('normalize_columns','var')
%             if (normalize_columns); dat = dat / max(abs(dat)); end
%         end
% 
%         dataout=[dataout dat];
%         if exist('legfield', 'var')
%             if ~isempty (legfield)
%             eval (['legarr{i} = struct{i}.' legfield ';']);
%             end
%         end
% 
%     end
% end