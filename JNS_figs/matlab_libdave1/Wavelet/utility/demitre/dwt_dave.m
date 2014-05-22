
function struct = dwt_dave (data, numcoefs, plot_on)


%len = 2^floor(log2(length(data)));
len=length(data);
data = data (1:len)';


% figure
if plot_on >=1
    figure(90);
    subplot(211), plot(data);title('Analyzed signal.'); 
end
%set(gca,'Xlim',[0 len])
% Perform discrete wavelet transform at level 5 by sym2. 
% Levels 1 to 5 correspond to scales 2, 4, 8, 16 and 32. 
[coefs,book_keeping] = wavedec(data,numcoefs,'db8');

% Expand(stretch) discrete wavelet coefficients for plot. 
% Levels 1 to 5 correspond to scales 2, 4, 8, 16 and 32. 
stretch_coefs = zeros(numcoefs,len); 
for k = 1:numcoefs 
    d = detcoef(coefs,book_keeping,k); 
    d = d(ones(1,2^k),:);
    d = d(:)';
    stretch_coefs(k,:) = wkeep(d,len,'c');      %i think this 'c' is correct
end


%Not sure the point of this code, however
%it appears to change all coefficients with a
%value less than squrt (eps) to zeros
% cfd = cfd(:); 
% I = find(abs(cfd)<sqrt(eps)); 
% cfd(I)=zeros(size(I)); 
% cfd = reshape(cfd,numcoefs,len);

% Plot discrete coefficients. 
if plot_on >=1
    subplot(212), colormap(gray(64)); 
    img = image(flipud(wcodemat(stretch_coefs,64,'row'))); 
    set(get(img,'parent'),'YtickLabel',[]); 
    title('Discrete Transform, absolute coefficients.') 
    ylabel('level (beginning at scale 2^1)')
    colorbar;
end

%Plot the unstretched wavelet coefficients
% figure
maxd = 0;
for k = 1:numcoefs
    len_log2 = log2(len);
    d = detcoef(coefs,book_keeping,k);
    
    % choosing fudge factors to get rid of edge effects
    if (len/2^k) > 15
        d = wkeep (d,round(len/2^k - 8),'c');
    elseif (len/2^k) > 7
        d = wkeep (d,round(len/2^k - 4),'c');
    else
        d = wkeep (d,round(len/2^k - 0),'c');
    end

    struct.dwt(k).coefs = d;
    struct.dwt(k).scale = 2^k;
    if plot_on >=2
        figure(91)
        subplot(numcoefs,1,numcoefs+1-k), colormap(pink(64));
        plot(d);
        if length(d) >= maxd
            maxd = length(d);
        end
        axis ([1 maxd min(d) max(d)]);
        ylabel(['Wv Scale ' int2str(2^k)]);
        legend (['mean=' num2str(mean(d)) ' & std=' num2str(std(d))]);
    end    
end

struct.rawdata = data;
struct.cwt = [];
struct.dwtmotherwavelet = [];



