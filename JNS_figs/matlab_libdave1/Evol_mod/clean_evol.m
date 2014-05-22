
function s = clean_evol(s, ncells, dsample)

    if nargin < 3
        dsample = 1;
    end
    if nargin < 2
        ncells = 8;
    end


    for i = 1:length(s.sptr.ct)
        if i ~= 4       % Leave pyramidal cells
            dat = s.sptr.ct{i};
            [rows cols] = size(dat);
            if cols > ncells; dat = dat(:,1:ncells); end
            dat = downsample(dat,dsample);
            s.sptr.ct{i} = dat;
        end
    end

end
