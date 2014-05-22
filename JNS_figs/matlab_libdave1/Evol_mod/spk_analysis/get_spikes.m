
function spikes = get_spikes (pm, thresh, refract)

    if size(pm,1) == 1; pm = pm(:); end % If it's a single row vector, make into a column
    pm = pm - thresh;
    pm_later = pm(2:end,:);
    pm_earlier = pm(1:end-1,:);
    pmdiff = sign(pm_later) - sign(pm_earlier);
    spikes = (pmdiff > 1);
    spikes = [zeros(1,size(spikes,2));spikes];   % Add a row of zeroes to spikes matrix

    if refract > 0
        spikes_refract = [];
        N = size(spikes,1);
        for kk = 1:size(pm,2)
            index = find(spikes(:,kk),1,'first');
            index_old = index - 1;
            while ~isempty(index)
                index = find(spikes(index_old:end,kk),1,'first');
                index = index + index_old - 1;
                end_index = min(N,index+refract);   % Make sure not to go over the end of the array
                spikes((index+1):end_index,kk)=0;
                index_old = index + 1;
            end
        end
    end

end