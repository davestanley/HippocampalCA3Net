
function s = lyap_struct (s, cap, typ, ds, numpts)
%typ: operation mode; type any of the following ('...'):
%        gp = Grassberger Procaccia estimate of correlation dimension
%        takens = Takens' estimate of correlation dimension
%        l = maximum lyapunov estimate (Rosenstein Method)
%        stl = maximum lyapunov estimate (STLmax, Iasemidas et al.)
%        ! = fast mode (Rosenstein Method only; accuracy not guaranteed)
%        * = error checking on dimension estimate (uses slow GP algorithm
%            in case of poor convergence)
%        Modes can be run independently or in combination; To combine 
%        modes, just type string in series (default='lgp*'); user cannot 
%        combine both dimension measures or both lyapunov measures in one 
%        run, as only one version will be used to produce the estimate.  

%cap: window size and sliding increment
%     format: cap = [increment size, window size]
%     e.g. cap = [50 1000] is increment 50 samples per slide, 1000 samples
%                for the window size (i.e. overlapping windows)
%          cap = 2000 is increment 2000 samples with 2000 sample window
%                (i.e. no overlap)
%          *** Make sure long enough segments are used to satisfy
%              Eckmann-Ruelle limits, otherwise estimates may be inaccurate

if nargin < 2
    cap = [2000 2000];
    typ = 'lgp*';
    ds = 5;
    numpts = 80000;
end
if nargin < 3
    typ = 'lgp*';
    ds = 5;
    numpts = 80000;
end
if nargin < 4
    ds = 5;
    numpts = 80000;
end
if nargin < 5
    numpts = 80000;
end



% Create a mini data set
numpts = 80000;
data2 = downsample(s.datafilt2,ds);
time2 = downsample(s.datatimes,ds);

data2 = data2(1:numpts);
time2 = time2(1:length(data2));

% figure; plot (data2);

% % % % Basic test
p = STLmax_getConfig();
L = STLmax(data2(:)',p)         % Linux estimate 3.6858


% Test complexity & Lyapunov
x = data2;
% typ = 'stlgp*';
SR = 1;
diverge = '';
delay = '';
emb = '';
numL = '';
flt = '';
% Clear old data
Dc = ''; Lmax = ''; D = ''; L = ''; X = ''; d='';l='';ind='';

ct1 = clock;
% full: [Dc,Lmax,D,L,X]=complexity(x,typ,SR,diverge,delay,emb,LsampleSz,flt)
% [Dc,Lmax,D,L,X]=complexity(x,typ, SR);
ct2 = clock;


% cap = [2000 2000];
wt1 = clock;
% full: [d,l,ind] = wcomplexity(x,typ,cap,SR,diverge,delay,emb,LsampleSz,flt)
[d,l,ind] = wcomplexity(x,typ, cap, SR);
wt2 = clock;

l = l * length(x);


if (isfield (s, 'cdata'))
    cdata = s.cdata;
else
    cdata = [];
end


% Save Trial data
% index = length(cdata) + 1;
index = 1;
% cdata(index).x = x;
cdata(index).typ = typ;
cdata(index).SR = SR;
cdata(index).diverge = diverge;
cdata(index).delay = delay;
cdata(index).emb = emb;
cdata(index).numL = numL;
cdata(index).flt = filt;
cdata(index).cap = cap;
% Save Output
cdata(index).out.Dc = Dc;
cdata(index).out.Lmax = Lmax;
cdata(index).out.D = D;
cdata(index).out.L = L;
cdata(index).out.X = X;
cdata(index).out.simtime = ct2-ct1;
cdata(index).out.d = d;
cdata(index).out.l = l;
cdata(index).out.ind = ind;
cdata(index).out.wsimtime = wt2-wt1;

dval = d(:,1);
dval = dval(find(~isnan(dval)));
lval = l(:,1);
lval = lval(find(~isnan(lval)));


cdata(index).avg.d=mean(dval);
cdata(index).avg.derr=std(dval)/length(dval);
cdata(index).avg.l=mean(lval);
cdata(index).avg.lerr=std(lval)/length(lval);

s.cdata = cdata;









end