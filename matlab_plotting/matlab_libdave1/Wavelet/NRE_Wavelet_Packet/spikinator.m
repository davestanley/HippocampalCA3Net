function [y,spk] = spikinator(x,windw,thr,amp,smth,cleanthr,frame)
%
%
%Remove large amplitude spikes from a time series.
%
%[y,spk] = spikinator(x,windw,thr,amp,smth,cleanthr,frame);
%
%x: spikey signal
%windw: spike window size in samples (... not time units)
%thresh: threshold for spike detection (greater or equal to 1); default=1.2
%amp: spike removal filter amplitude; default=0.001
%    ****If amp = 0, THIS SETS PROGRAM TO EXCISION OF SPIKES***
%smth: magnitude of extra smoothing of spike stumps (0 to 1); default=0
%cleanthr: degree of spike cleaning (between 0 and 1); default=0.5
%          higher = greater cleaning, but may incur signal distortion
%frame: window frame margin (fraction of window size); default=0.2
%y: cleaned signal
%spk: time series containing removed spikes (only for non-excision mode)
%
%
%Osbert Zalay, Oct 2007
%
%*** For academic/research use. Please acknowledge author. ***

%load spikinatorJPG;
%subplot(1,2,1),image(spikinatorJPG)
%axis off

if nargin < 2
    disp('Need to input x and windw to work...exiting');
    y=[];
    return
end
if nargin < 3
    thr=1.2;
    amp=0.001;
    smth=0;
    cleanthr=0; %0.2;
    frame=0.2;
end
if nargin < 4
    amp=0.001;
    smth=0;
    cleanthr=0; %0.2;
    frame=0.2;
end
if nargin < 5
    smth=0;
    cleanthr=0; %0.2;
    frame=0.2;
end
if nargin < 6
    cleanthr=0; %0.2;
    frame=0.2;
end
if nargin < 7
    frame=0.2;
end

lenx=length(x);
hwindw=round(windw/2);
cleanthr=1-cleanthr;
spk=x;
x=x.';
xm=x-min(x);
[mv,indv]=lmaxv(xm,1);
%mvbar=mean(mv); %global threshold (mean of peak-to-peak values)
mvbar=rms(xm); %global threshold (RMS)
mvcut=thr*mvbar;
indmv=find(mv > mvcut);
indspk=indv(indmv);
lenspk=length(indspk);
hwdwsize=hwindw;
count=0;
for i=1:lenspk
    indi=indspk(i);
    while (hwdwsize >= indi) | (hwdwsize >= (lenx-indi))
        hwdwsize=round(hwdwsize/2);
    end
    lb=indi-hwdwsize;
    ub=indi+hwdwsize;
    xs=x(lb:ub);
    minxs=min(xs);
    xsm=xs-minxs;
    mvbar=rms(xsm); %local threshold (RMS)
    mvx=lmaxv(xsm,1);
    indmvx=find(mvx > mvcut);
    subplot(1,2,2),plot(xs);
    pause(0.0001);
    if ~isempty(indmvx)
        if amp ~= 0
            lenxs=length(xs);
            mxsm=max(xsm);
            [env,lf,uf]=envelope(lenxs,1,frame);
            xflt=1-env.*amp.*xsm./mxsm;
            while (mxsm > cleanthr*mvbar) & (count < 10000)
            %while (mxsm > (cleanthr*mvbar+a0)) & (count < 10000)
                count=count+1;
                xsm=xflt.*xsm;
                cm=CofM(xsm,lenxs);
                indi=indi+(cm-round(lenxs/2));
                if smth~=0
                    lenflt=max([3 ceil(smth*(uf-lf))]);
                    xsm(lf:uf) = smooth(xsm(lf:uf),lenflt);
                end
                xsm=xsm+minxs;
                x(lb:ub)=xsm;
                hwdwsize=hwindw;
                while (hwdwsize >= indi) | (hwdwsize >= (lenx-indi))
                    hwdwsize=round(hwdwsize/2);
                end
                lb=indi-hwdwsize;
                ub=indi+hwdwsize;
                xs=x(lb:ub);
                minxs=min(xs);
                xsm=xs-minxs;
                %a0=mean(xsm);
                mxsm=max(xsm);
                lenxs=length(xs);
                [env,lf,uf]=envelope(lenxs,1,frame);
                xflt=1-env.*amp.*xsm./mxsm;
            end
        else
            subplot(1,2,2),plot(xs);
            pause(0.0001);
            x(lb:ub)=NaN;
        end
    end
    hwdwsize=hwindw;
    count=0;
end
y=x(find(~isnan(x))).';
if amp~=0
    spk=spk-y;
else
    spk=0;
end


function [y] = Linflt(x,SR,wn,filt_type,order)
[mx nx]=size(x);
if nx>1 
    x=x.';
    mx=nx;
end
normCutoff=2*wn/SR;
len=mx;
h=fir1(order,normCutoff,filt_type);
H=fft(h,len);
X=fft(x,len).';
Y=H.*X;
y=ifft(Y);
y=shft(SR,order,y);


function [uShift] = shft(SR,order,u)
lenu=length(u);
uShift=zeros(1,lenu);
shiftindex=order/2;
tdelay=(shiftindex)/SR;
k=0;
for i=shiftindex:lenu
    k=i-shiftindex+1;
    uShift(k)=u(i);
end
for i=1:shiftindex-1
    uShift(k+i)=u(i);   
end


function [lmval,indd]=lmaxv(xx,filtr)
x=xx;
len_x = length(x);
	fltr=[1 1 1]/3;
  if nargin <2, filtr=0; 
	else
x1=x(1); x2=x(len_x); 
	for jj=1:filtr,
	c=conv(fltr,x);
	x=c(2:len_x+1);
	x(1)=x1;  
        x(len_x)=x2; 
	end
  end
lmval=[]; indd=[];
i=2;		
    while i < len_x-1,
	if x(i) > x(i-1)
	   if x(i) > x(i+1)	
lmval =[lmval x(i)];
indd = [ indd i];
	   elseif x(i)==x(i+1)&x(i)==x(i+2)	
i = i + 2;  		
	   elseif x(i)==x(i+1)
i = i + 1;		
	   end
	end
	i = i + 1;
    end
if filtr>0 & ~isempty(indd),
	if (indd(1)<= 3)|(indd(length(indd))+2>length(xx)), 
	   rng=1;	
	else rng=2;
	end
	  for ii=1:length(indd), 
	    [val(ii) iind(ii)] = max(xx(indd(ii) -rng:indd(ii) +rng));
	    iind(ii)=indd(ii) + iind(ii)  -rng-1;
	  end
  indd=iind; lmval=val;
else
end


function [env,lf,uf] = envelope(len,divar,frame)
k=100./len;
ivar=[divar:divar:len];
lf=round(frame*len);
uf=round((1-frame)*len);
env=(1+exp(-k.*(ivar-lf))).^(-1)-(1+exp(-k.*(ivar-uf))).^(-1);


function cm = CofM(xx,len)
r=[1:len];
cm=round(sum(xx.*r)/sum(xx));

%% I added this function

function y=rms(x)
% function RMS(X)
% Returns root mean square of vector or matrix X

% D. Menemenlis (dimitri@ocean.mit.edu), 26 may 99

ix=find(~isnan(x));
if length(ix)>1
  y=sqrt(mean(x(ix).*x(ix)));
else
  y=nan;
end


