

function lyap_plot(s, index)


if nargin < 2
    if (isfield (s, 'cdata'))
        index = length(s.cdata);
    else
        fprintf ('No Lyap data can be found in the cdata field. Exiting...');
        return
    end
end

cdata = s.cdata;

% Load Trial data & Plot
% index = 3;
x = cdata(index).x;
Dc = cdata(index).out.Dc;
Lmax = cdata(index).out.Lmax;
D = cdata(index).out.D;
L = cdata(index).out.L;
X = cdata(index).out.X;
d = cdata(index).out.d;
l = cdata(index).out.l;
ind = cdata(index).out.ind;


figure; 
subplot (311); plot (x);

subplot(312); hold on;
if ~(isempty(Dc)) plot (ind, ones(length(ind),1)*Dc(1,1),'r:'); end
plot(ind, d(:,1),'b'), plot(ind, d(:,1) + d(:,2),'g:');plot(ind, d(:,1) - d(:,2),'g:');
%errorbar (ind, d(:,1), d(:,2));
if ~(isempty(Dc))
    title (['Correlation dimension. Overall est = ' num2str(Dc(1,1)) '; Wind Avg Est = ' num2str(mean(d(:,1)))]);
    legend ('complexity','wcomplexity', 'err');
else
    title (['Correlation dimension. Wind Avg Est = ' num2str(mean(d(:,1)))]);
    legend ('wcomplexity', 'err');
end


subplot(313); hold on;
if ~(isempty(Lmax)) plot (ind, ones(length(ind),1)*Lmax(1,1),'r:'); end
plot(ind, l(:,1),'b'), plot(ind, l(:,1) + l(:,2),'g:');plot(ind, l(:,1) - l(:,2),'g:');
%errorbar (ind, l(:,1), l(:,2));
if ~(isempty(Lmax))
    title (['Lyap exponent. Overall est = ' num2str(Lmax(1,1)) '; Wind Avg Est = ' num2str(mean(l(:,1))) ]  );
    legend ('complexity','wcomplexity', 'err');
else
    title (['Lyap exponent. Wind Avg Est = ' num2str(mean(l(:,1))) ]  );
    legend ('wcomplexity', 'err');
end


