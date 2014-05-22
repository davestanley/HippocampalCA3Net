function [yR,yRR,R,S,indR,indRR,va,pa] = wavpackprune(T,thr,DC)
%
%[yR,yRR,R,S,indR,indRR,va,pa] = wavpackprune(T,prunethr,DC);
%
%T: analysis tree
%prunethr: interpeak interval variance threshold for pruning; default=0.01
%(nodes with variances less than 'thr' are pruned)
%DC=0 or 1 (default: 1; Never prune first node: 0)
%
%yR: filtered signal
%yRR: extracted signal (reconstructed from filtered components)
%S: synthesized signal with all nodes included
%R: matrix of terminal tree node reconstructions
%indR: index of terminal tree nodes used in constructing yR
%indRR: index of terminal tree nodes used in constructing yRR
%va is a vector of terminal node interpeak interval variances
%pa is a vector of terminal node signal power
%
%
%Osbert Zalay, August 2007

if nargin < 2
    thr=0.01;
    DC=1;
end
if nargin < 3
    DC=1;
end
firstn=2-DC;
[R,S,indx]=wpreconstruct(T);
[va,pa]=endnodestat(T);
[m,lenR]=size(R);
yR=zeros(m,1);
indR=zeros(lenR,1);
count=0;
ind=0;
for i=firstn:lenR
    ind=lenR-i+firstn;
    if va(ind) >= thr
        yR=yR+R(:,ind);
        vR=intvar(yR,1);
        if vR < thr
            yR=yR-R(:,ind);
        else
           count=count+1;
           indR(count)=ind;
        end
    end
end
if ~DC
    count=count+1;
    indR(count)=1;
    yR=yR+R(:,1);
end
indR=flipud(indR(1:count,1));
[yRR indRR]=extractRebuild(R,indR);

function [va,pa] = endnodestat(wtr)
N=leaves(wtr);
lenN=length(N);
va=zeros(1,lenN);
pa=zeros(1,lenN);
for i=1:lenN
    [va(i) pa(i)]=ithnodestat(wtr,N(i));
end

function [v p] = ithnodestat(wtr,N)
r=wprcoef(wtr,N);
lenr=length(r);
v=intvar(r,1);
p=sum(r.^2)/lenr;

function [varint]=intvar(s,flt)
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
    varint=10^10;
else
    interval=interval./mean(interval);
    varint=var(interval);
end

function [R,S,indx] = wpreconstruct(wtr)
N = leaves(wtr);
lenN = length(N);
S = wprcoef(wtr);
lenS=length(S);
R=zeros(lenS,lenN);
for i=1:lenN
    R(:,i)=wprcoef(wtr,N(i));
end
indx=[[1:lenN].' N];

function [yRR indRR]=extractRebuild(R,indR)
[m,lenR]=size(R);
lenI=length(indR);
indRR=zeros(lenR,1);
count=1;
for i=1:lenR
    ind=find(indR==i);
    if isempty(ind)
        indRR(count)=i;
        count=count+1;
    end
end
indRR=indRR(find(indRR));
lenIR=length(indRR);
yRR=zeros(m,1);
for i=1:lenIR
    yRR=yRR+R(:,indRR(i));
end
