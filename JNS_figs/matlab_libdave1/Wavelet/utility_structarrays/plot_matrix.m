

function handles = plot_matrix (t, data, opt_strct, leg_arr, colourarr, linesize)

if nargin < 6
   linesize = 1; 
end

if nargin < 5
    colourarr = ['bgrmckbgrmckbgrmckbgrmckbgrmckbgrmck'];
    colourarr = get(0, 'DefaultAxesColorOrder'); colourarr = repmat(colourarr, size(data,2), 1);
end

if isempty(colourarr); colourarr = ['bgrmckbgrmckbgrmckbgrmckbgrmckbgrmck']; end

ds = 1;
shift = 0;
zero_means = 0;
plotloglog = 0;
normalize_everything = 0;

if exist('opt_strct','var')
    if ~isempty(opt_strct);
        if isfield (opt_strct,'ds'); ds = opt_strct.ds; end
        if isfield (opt_strct,'shift'); shift = opt_strct.shift; end
        if isfield (opt_strct,'zero_means'); zero_means = opt_strct.zero_means; end
        if isfield (opt_strct,'plotloglog'); plotloglog = opt_strct.plotloglog; end
        if isfield (opt_strct,'normalize_everything'); normalize_everything = opt_strct.normalize_everything; end
    end
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
    if ischar(colourarr)
        currcolour = colourarr(i);
    else
        currcolour = colourarr(i,:);
    end
    plotdata = data(:,i);
    if zero_means; plotdata = plotdata - mean(plotdata); end
    plotdata = downsample(plotdata, ds);
    if ~plotloglog
        handles.plot = plot (t, plotdata + (i-1)*shift, 'Color', currcolour, 'LineWidth',linesize); hold on;
    else
        loglog(t, plotdata, 'Color', currcolour, 'LineWidth',linesize); hold on;
        if (shift ~= 0)
            handles.plotlog = loglog(t, plotdata + (i-1)*shift, 'Color', currcolour, 'LineWidth',linesize); hold on;
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