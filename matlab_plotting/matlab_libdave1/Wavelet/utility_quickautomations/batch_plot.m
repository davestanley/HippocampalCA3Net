

% Inputs:
% command:       the variable 'command', containging a string that houses the
%                  command to be executed
% inp_arr:       The variable x in the command string will be replaced by the
%                  variables stored in the inp_arr string cell array
% Outputs:
% ....:          Whatever the command "command" generates!






% m: spacing
% ds: downsample



for j = 1:length(inp_arr)/2

    xloc = fliplr(xloc);
    exec_cmd = command;
        for i = 1:length(xloc)
            exec_cmd = [exec_cmd(1:xloc-1) inp_arr{j} exec_cmd(xloc+1:end)]  ;
            fprintf('Executing: %s\n',exec_cmd);
            eval (exec_cmd);
        end

end
