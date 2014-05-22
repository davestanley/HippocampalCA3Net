


function dat_arr = load_files2mat (path, raster_or_train, celltype)
    % raster_or_train: 'raster' or 'sptr'
    % type = b, olm, psoma, msg
    % Range is not needed, since this will simply stop when the last file
    % is reached

        
    dat_arr = [];
    figid =0;
    i = 0;
    while (figid ~= -1)
        i=i+1;
        fn=strcat(path, '/', raster_or_train, celltype, num2str(i),'.dat');
        figid=fopen(fn,'r','native');
        if figid ~= -1
            val=fscanf(figid,'%g',Inf);
            dat_arr = [dat_arr val(:)];
        end
        if (figid ~= -1); fclose(figid); end
    end
end




% 
% 
% function [hx, hy]=spikehist2(ppath, dir, type, range)
% 
% 				#Purpose: spike histogram plotting tool
% 				#         it uses rasters to do this
% 				#Output: 2 vectors containing x and y 
% 				#        coordinates to plot histograms with
% 				#        plot(hx,hy)
% 				#
% 				#Usage: [hx, hy]=spikehist2(ppath, dir, type, range)
% 				#
% 				#ppath  projectpath
% 				#dir    the directory rastergrams are stored in
% 				#type   type of neuron (e.g. 'olm','b','psoma'
% 				#range  the interval in which histograms
% 				#       have to be calculated (e.g. 1:50)
% 
%      dt=0.01;
%      nb=100;
%      pos=1;
%      global DATAPATH;
%      fn=strcat(DATAPATH, '/', ppath, '/', dir, '/raster_', type, '%d.dat');
%   for i=range
%     fn2=sprintf(fn,i);
%     figid=fopen(fn2,'r','native');
%     val=fscanf(figid,'%g',Inf);
%     endpos=pos+length(val)-1;
%     raster(pos:endpos)=val;
%     fclose(figid);
%     pos=endpos+1;
%   end