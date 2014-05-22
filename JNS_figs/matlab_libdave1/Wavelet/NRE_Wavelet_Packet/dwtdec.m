function [T,V,P,R,cc] = dwtdec(y,n,nivlim)
%
%Automated threshold estimation for NRE algorithm
%
%[THRESH,NIV,BETA,R,C] = dwtdec(y,n);
%
%y: time series (column vector)
%n: level of dwt decomposition (default: full decomposition)
%
%THRESH: returned threshold for pruning and power [theta, beta_p]
%NIV: normalized interpeak interval variances of dwt reconstructions
%BETA: fractional power of dwt reconstructions
%R: reconstructed dwt decomposition time series
%C: coefficients of dwt
%
%
%Osbert Zalay, Nov 2008

leny=numel(y);
if nargin < 2
    n=floor(log2(leny));
    nivlim=5e-4;
end
if nargin < 3
    nivlim=5e-4;
end
if n == 0
    R=emd(y).'; cc=0;
    [m,n]=size(R);
else
    [C,L]=wavedec(y,n,'dmey');
    lenL=numel(L);
    LL=L;
    L=cumsum(L);
    R=zeros(leny,n+1);
    cc=zeros(numel(C),(lenL-1));
    cc(1:L(1),1)=C(1:L(1));
    for i=2:(lenL-1)
        cc((L(i-1)+1):L(i),i)=C((L(i-1)+1):(L(i)));
    end
    for i=1:(n+1)
        R(:,i)=waverec(cc(:,i),LL,'dmey');
    end
end
%a=[n:-1:0];
%scal=2.^a;  %~1/f
%sumscal=sum(scal);
[V P]=sigstats(R);
[v p]=sigstats(y);

P=P./p; %normalize to input signal power
%ind=find(~isnan(V));
ind=find(~isnan(V) & V<1);
sump=sum(P(ind));
vp=V(ind).*P(ind)/sump;
nivthr=mean(vp);
%nivthr=mean(V(ind));
%nivthr=min(V); 
%nivthr=min(V)/v;
%nivthr=min(V)/(n*v);
%nivthr=min(V)/(3*v); %min NIV normalized by original NIV/(1/3)
if nivthr < nivlim
    nivthr=nivlim;
end
%pthr=sum(scal.*P')/sumscal;
%pthr=mean(P)/n;
pthr=mean(P(2:end)); %average just the detail coefficients


%Log scale factor
%log bases
bstn=2; %bstn=10; 
bspn=2; 
%factors
ktn=1/2;
kpn=1;

%TN=log(n)/log(bstn); PN=log(n)/log(bspn);
TN=ktn*log(n)/log(bstn); PN=kpn*log(n)/log(bspn);

%[NIV upper bound, pthr upper bound]
%T=[nivthr pthr];
T=[nivthr/TN pthr/PN];

    
function [v p] = sigstats(r)
[m,n]=size(r);
v=zeros(n,1); p=zeros(n,1);
for i=1:n
    v(i)=niv(r(:,i),1);
    p(i)=sum(r(:,i).^2)/m;
end

function [varint]=niv(s,flt)
x=wkeep(s,round(length(s)*0.9));
lenx=length(x);
interval=zeros(lenx,1);
fltr=[1 1 1]/3; 
x1=x(1); x2=x(lenx); 
for j=1:flt
	c=conv(fltr,x);
	x=c(2:lenx+1);
	x(1)=x1;  
    x(lenx)=x2; 
end
count=0;
keepgoing=1; start=2; k=start;
while (keepgoing) & (k < lenx)
    if x(k-1)<x(k) & x(k+1)<x(k)
        maxind1=k;
        keepgoing=0;
    end
    k=k+1;
    start=k;
end
if (start < lenx)
    for i=start:(lenx-1)
        if x(i-1)<x(i) & x(i+1)<x(i)
            count=count+1;
            maxind2=i;
            interval(count)=maxind2-maxind1;
            maxind1=maxind2;
        end
    end
end
interval=interval(find(interval));
if length(interval)<2
    varint=NaN;
else
    interval=interval./mean(interval);
    varint=var(interval);
end