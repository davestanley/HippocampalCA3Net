

function handles =plot_matrix_err(t, data, err, opt_strct, leg_arr, colourarr, linesize)

if nargin < 7
   linesize = 1; 
end

if nargin < 6
    colourarr = ['bgrmckbgrmckbgrmckbgrmckbgrmckbgrmck'];
end

if isempty(colourarr); colourarr = ['bgrmckbgrmckbgrmckbgrmckbgrmckbgrmck']; end

ds = 1;
shift = 0;
zero_means = 0;
plotloglog = 0;
normalize_everything = 0;

[rows cols] = size(data);
[rows2 cols2] = size(t);
if cols2 == 1; t = repmat(t, 1, cols); end

if exist('opt_strct','var')
    if ~isempty(opt_strct);
        if isfield (opt_strct,'ds'); ds = opt_strct.ds; end
        if isfield (opt_strct,'shift'); shift = opt_strct.shift; end
        if isfield (opt_strct,'zero_means'); zero_means = opt_strct.zero_means; end
        if isfield (opt_strct,'plotloglog'); plotloglog = opt_strct.plotloglog; end
        if isfield (opt_strct,'normalize_everything'); normalize_everything = opt_strct.normalize_everything; end
    end
end

if ~exist('err','var')
    err=[];
end

if normalize_everything
   for jj = 1:size(data,2)
       xtemp = data(:,jj);
       xtemp = xtemp - mean(xtemp);
       xtemp = xtemp / std(xtemp);
       data(:,jj) = xtemp;
   end
end

t = downsample(t, ds);
for i = 1:size(data,2)
    plotdata = data(:,i);
    if zero_means; plotdata = plotdata - mean(plotdata); end
    plotdata = downsample(plotdata, ds);
    if ~plotloglog
        handles.plot = plot (t(:,i), plotdata + (i-1)*shift, colourarr(i), 'LineWidth',linesize); hold on;
        hold on; if ~isempty(err); errorbar(t(:,i),plotdata + (i-1)*shift, err(:,i)); end
    else
        loglog(t(:,i), plotdata, colourarr(i), 'LineWidth',linesize); hold on;
        if (shift ~= 0)
            handles.plotlog = loglog(t(:,i), plotdata + (i-1)*shift, colourarr(i), 'LineWidth',linesize); hold on;
        end
    end
end

if exist('leg_arr','var')
    if ~isempty(leg_arr)
        for i = 1:length(leg_arr)
            tempstr = leg_arr{i};
            leg_arr{i} = strrep (leg_arr{i}, '_', ' ');
        end
        handles.legend = legend (leg_arr);
    end
end




end