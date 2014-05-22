

% Loads a file only if it's empty
% requires that name be defined

if ~exist (name,'var')
    
    eval (['load ' name]);
    % Downsample data if need be
    if exist('ds','var'); eval([name ' = downsample(' name ',' num2str(ds) ');']); end

end;

