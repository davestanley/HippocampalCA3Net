

function genplot (data, channelnames, plot_cols, starting)

% Set data_info to '-1' in order to either specify no info file
% or to search for an info file automatically

sampling = 1e-3;


colour = 'bgrmckybgrmckybgrmcky';
n = size(data,1);
numfields = size(data,2);

if (exist('starting','var'))
    data = data(starting:end,:);
end

if (exist('sampling','var'))
    ds = round (sampling/(data(end,1)-data(end-1,1)) );
    data = downsample (data,ds);
end

subplot(211)
plot(data(:,1),data(:,2))
dt = data(end,1)-data(end-1,1);
ylabel ('Channel Voltage (mV)');


subplot(212)
j = 1;
for i = plot_cols
    hold on; plot(data(:,1),data(:,i), colour(j));
    M{j} = channelnames{i};
    j = j + 1;
end
j = 1;
legend (M);
hold off;
ylabel ('Channel Current(A)');
xlabel ('Time (s)');



end