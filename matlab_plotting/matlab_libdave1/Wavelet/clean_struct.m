
function s = clean_struct(s,opt_strct)

clean_filtered=0;
apply_downsample=0;
    ds_num=-1;
clean_unfiltered=0;

if nargin > 1
    if isfield (opt_strct, 'clean_filtered'); clean_filtered = opt_strct.clean_filtered; end
    if isfield (opt_strct, 'apply_downsample'); apply_downsample = opt_strct.apply_downsample; end
        if isfield (opt_strct, 'ds_num'); ds_num = opt_strct.ds_num; end
    if isfield (opt_strct, 'clean_unfiltered'); clean_unfiltered = opt_strct.clean_unfiltered; end
end

if clean_filtered == 1
   s = rmfield(s, 'datafilt');
   s = rmfield(s, 'datafilt2');
end

if apply_downsample
   s.datds = downsample(s.data,ds_num);
   s.tds = downsample(s.datatimes,ds_num);
end

if clean_unfiltered == 1
   s = rmfield(s, 'data');
   s = rmfield(s, 'datatimes');
end

end


