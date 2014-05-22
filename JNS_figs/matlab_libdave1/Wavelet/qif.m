%Quick ideal filter

function dout = qif (datatimes, data, interval)

    ts1 = timeseries(data,datatimes);
    ts1filt = idealfilter (ts1, interval, 'notch');
    dout = ts1filt.data;
    
end