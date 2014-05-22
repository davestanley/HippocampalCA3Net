

%Imports all global variables to current workspace
%To run, just trype import_global

        %Generates an array of global variables
global_list_array = who('global');

        %Convert this list into a string separated by spaces
global_list = global_list_array{1};
for i = 2:length(global_list_array)
    global_list = [global_list ' ' global_list_array{i}];
end

        %Load the list of global variables
eval(['global ' global_list]);

        %Cleanup
clear  global_list
clear global_list_array
clear i