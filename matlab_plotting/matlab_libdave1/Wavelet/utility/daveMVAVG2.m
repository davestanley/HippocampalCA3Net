

function [t2,y] = daveMVAVG2 (t,x,len_filt, fraction_overlap)
    

    x=x(:);
    N = length(x);
    dt = t(end)-t(end-1);
    filter = 1/len_filt*ones(len_filt, 1);
    
    no_downsample = 0;
    if nargin > 3 % Partially overlapping filter
        if (fraction_overlap > 1); fraction_overlap = fraction_overlap / 100; end  % Convert percent to a fraction if need be.
        shift_fraction = 1.0-fraction_overlap;
        fil_start = 1;
        fil_end = N - len_filt + 1;
        
        if (round(len_filt*shift_fraction)<=0); no_downsample=1;  % Make sure that we can do this small a shift; if not, conv
        else
            
            loopvar = fil_start:round(len_filt*shift_fraction):fil_end;
            Nout = length(loopvar);
            y=zeros(Nout, 1); t2=zeros(Nout, 1);
            j=0;
            for i = loopvar
                j=j+1;
                y(j)=filter' * x(i:(i+len_filt-1));
                t2(j) = t(round(mean([i i+len_filt-1])));
            end
        end
    else
        no_downsample=1;
    end
    
    if (no_downsample)  % We are not downsampling the output - i.e. use fully overlapping filter.
        y = conv(x,filter);
        y = wkeep(y, length(x)-len_filt,'c');
        t2 = (0:length(x)-1)*dt;
        t2 = wkeep(t2, length(x)-len_filt, 'c');
    end
    y=y(:);
    t2=t2(:);

end

