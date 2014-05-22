    



path_working = pwd;
path_sim = '.';

path_dataout = '.';
run([path_sim '/' path_dataout '/fnamelistfile.m'])
run([path_sim '/' path_dataout '/varnamelistfile.m'])

for i = 1:length(fnamelist)
   load (['wrkspc_' num2str(i) '.mat']);
   sim_full{i} = sim{i};
   clear sim;
end

