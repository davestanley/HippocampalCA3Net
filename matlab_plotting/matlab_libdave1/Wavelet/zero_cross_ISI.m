
function s = zero_cross_ISI (s)

format compact;
dt = s.datatimes(2) - s.datatimes(1);


datafilt_lowpass = qif (s.datatimes, s.datafilt, [0 1]); datatimes_lowpass = s.datatimes;
[datatimes_lowpass datafilt_lowpass] = lowpass_avg (s.datatimes, datafilt_lowpass, 100);

% s.data_diff = diff(datafilt_lowpass);
% s.datatimes_diff = s.datatimes (1:length(s.data)-1);














% tr = 0.0:0.02:0.22; %threshold range
% mir = 0.01:0.01:0.02; %minimium interval range
lpstd = std(datafilt_lowpass);
% tr = 1.1 * lpstd;
tr = 0.65;                          % This value seems to work great for ic7gap and ic7gapsyn. Can decrease lowpass filter freq
mir = 0.000001;


figure; hold on;
ds = 5;
num = 1:length(datafilt_lowpass);
plotds (s.datatimes, s.data - mean(s.data), 'b', ds); hold on;
% plot (dt * wkeep(num, length(s.datafilt_nobase), 'c'), s.datafilt_nobase, 'g:');
plotds ( datatimes_lowpass, datafilt_lowpass - mean(datafilt_lowpass), 'r', ds);
plotds (dt * num, tr + zeros(1, length(num)), 'k', ds);
legend('unfiltered', 'filtered', ['stdev=' num2str(lpstd)]);

% return;



if length(mir) > 1
    dmir = mir(2) - mir(1);
    dtr = tr(2) - tr(1);
    amat = zeros(length(tr), length(mir));
end

for min_int = mir
    a = [];
    for thresh = tr
        thresh;
        [ints EPSPamps indicies] = down_up_ints (datatimes_lowpass, datafilt_lowpass, thresh);
    %     ints = down_up_ints (s.datatimes_diff, s.data_diff, thresh);

    %     ints = gamrnd(2,2,1,50000);
        keeping = find(ints>min_int);
        ints = ints(keeping);
        indicies = indicies(keeping+1);
        EPSPamps = EPSPamps(keeping);
        
        
        hold on; plot(s.datatimes(indicies),tr*ones(length(indicies),1),'r*');
        
        % EPSP Amplitude Histogram
        IQR = iqr(EPSPamps);
        len = length(EPSPamps);

        %  Friedman Diaconis Rule
        spacing = 2*IQR*len^(-1/3);                       % Estimate the appropriate number of bins
        nbins = ceil ((max(EPSPamps) - min(EPSPamps))/spacing); % using Freedman-Draconis ruls

        sp = spacing;

        [epsp_hist epsp_bins] = hist(EPSPamps, min(EPSPamps):sp:(max(EPSPamps)));
        figure; h1 = bar (epsp_bins, epsp_hist,'b');


        % ISI Times Histogram
        IQR = iqr(ints);
        len = length(ints);

    %     % Sturges' Formula
    %     nbins = log2(len) + 1;
    %     spacing = (max(ints) - min(ints)) / nbins;

    %      % Scott Rule
    %      spacing = 3.5*std(ints)*len^(-1/3);   % Estimate the appropriate number of bins
    %      nbins = ceil ((max(ints) - min(ints))/spacing); % using Freedman-Draconis ruls    

        %  Friedman Diaconis Rule
        spacing = 2*IQR*len^(-1/3);                       % Estimate the appropriate number of bins
        nbins = ceil ((max(ints) - min(ints))/spacing); % using Freedman-Draconis ruls

        sp = max(dt, spacing);

        [nhist binloc] = hist(ints, min(ints):sp:max(ints));

    
        fprintf ('Thresh = %g; min_int = %g\n',thresh,min_int);

        [coefs resnorm] = fit_poisson (ints, binloc, nhist);
        [area_under_curve resnorm2] = fit_poisson_scale (ints, binloc, nhist);
%         area_under_curve = sum(nhist)*sp;

        figure; h1 = bar (binloc, nhist,'b'); hold on;
        plot (binloc, area_under_curve*exppdf(binloc, mean(ints)),'g');
        h2 = plot (binloc, poisson_exp ([coefs(1) coefs(6)], binloc), 'r');    
        legend (['thresh=' num2str(thresh) ' mint=' num2str(min_int) 'mean=' num2str(mean(ints))] ,['a=' num2str(coefs(2)) ' b=' num2str(coefs(3)) ' max=' num2str(coefs(4)) ' err=' num2str(resnorm)]);

        % Make a array (old code, 1d)
        a = [a coefs(2)];

        % Make a matrix (2d)
        if length(mir) > 1
            miindex = round((min_int-min(mir))/dmir + 1);
            trindex = round((thresh-min(tr))/dtr + 1);
            amat(trindex, miindex) = coefs(2);
        end
    end


    
    if length(a) > 1
        figure; bar(tr, a);
        xdiff = max(tr) - min(tr);
        ydiff = max(a) - min(a);
        axis ([(min(tr)-0.25*xdiff) (max(tr)+0.25*xdiff) min(0.8, min(a)-0.25*ydiff) max(a)]);
    end
end

if length(mir)>1
    s.amat = amat;
    imagesc (mir, tr, amat);
end

end



function [times lowpass] = lowpass_avg (datatimes, data, filt_freq)

    % Set constants
    filt_time = 1/filt_freq;
    dt = datatimes(2) - datatimes(1);
    len = length (data);
    
    % Design filter
    filt_size = round(filt_time / dt);
    filt = ones(1, filt_size) / filt_size;
    
    % Apply filter
    fout = conv (data, filt);
    lkeep = len - filt_size;
    lowpass = wkeep (fout, lkeep, 'c');
    times = (0:lkeep-1)*dt;

end

function [ints zc_indices] = crossing_intervals (t, x, thresh)

    x = x - thresh;
    dt = t(2) - t(1);
    N = length(x);
    
    x_sign = ( x >= 0 ) - ( x < 0 );
    zc_list = (x_sign(1:N-1) - x_sign(2:N));
    zc_indices = find (zc_list ~= 0);
    ints = diff (zc_indices);
    ints = ints * dt;

end

function [ints ISIamps downup_indicies] = down_up_ints (t, x, thresh)

    x = x - thresh;
    dt = t(2) - t(1);
    N = length(x);
    
    x_sign = ( x >= 0 ) - ( x < 0 );
    zc_list = (x_sign(1:N-1) - x_sign(2:N));
    downup_indicies = find (zc_list == -2);
    ints = diff (downup_indicies);
    ints = ints * dt;
    
    ISIamps = [];
    x = x + thresh;
    for i = 1:length(downup_indicies)-1
        ISIamps = [ISIamps max(x(downup_indicies(i):downup_indicies(i+1)))];
    end

end




function [coefs_out resnorm_out] = fit_poisson (data, binloc, nhist)
global sig
global C_scale
global b_scale
                % sig = sqrt(alpha) * beta
                % C = Cprime * C_scale



    sig = std(data);
            % Note: variance = alpha*beta^2, so we only need to fit 2
            % parameters
    a0 = 1;
    C0 = (binloc(2) - binloc(1)) * sum(nhist);   %Set the constant multiplier to be equal to the integrated area of our data
    b0 = sig;
    Cprime0 = a0;
    bprime = a0;
    
    C_scale = C0 / Cprime0;
    b_scale = b0 / bprime;
    
    coefs_out0 = [Cprime0 bprime];
    options = optimset ('MaxFunEvals', 5000, 'TolFun', 0.000001);
    [coefs_out resnorm_out] = lsqcurvefit(@poisson_exp, coefs_out0, binloc, nhist, -Inf, Inf, options);
    
    a = 1;
    bprime = coefs_out(2);
    b = bprime * b_scale;
    Cprime = coefs_out(1);
    C = Cprime * C_scale;

    coefs_out = [Cprime a b C C_scale bprime b_scale];
    
end



function f = poisson_exp(coefs, x)
global sig
global C_scale
global b_scale
                % sig = sqrt(alpha) * beta
                % C = Cprime * C_scale

    C = coefs(1) * C_scale;
    a = 1;
    b = coefs(2) * b_scale;
%     b = sig/sqrt(a);
    

    f = C * 1/((b^a)*gamma(a)) * x.^(a-1).*exp(-x/b);

end





function [C_scale resnorm_out] = fit_poisson_scale (data, binloc, nhist)
global lambda
global C_scale
global b_scale
                % lambda = sqrt(alpha) * beta
                % C = Cprime * C_scale



    lambda = mean(data);
            % Note: variance = alpha*beta^2, so we only need to fit 2
            % parameters
    a0 = 1;
    C0 = (binloc(2) - binloc(1)) * sum(nhist);   %Set the constant multiplier to be equal to the integrated area of our data
    b0 = lambda;
    Cprime0 = a0;
    bprime = a0;
    
    C_scale = C0 / Cprime0;
    b_scale = b0 / bprime;
    
    coefs_out0 = [Cprime0];
    options = optimset ('MaxFunEvals', 5000, 'TolFun', 0.000001);
    [coefs_out resnorm_out] = lsqcurvefit(@poisson_default_sig, coefs_out0, binloc, nhist, -Inf, Inf, options);
    
    a = 1;
    b = lambda;
    Cprime = coefs_out(1);
    C = Cprime * C_scale;

%     coefs_out = [Cprime a b C C_scale bprime b_scale];
    C_scale = C;
    
end



function f = poisson_default_sig (coefs, x)
global lambda
global C_scale
global b_scale
                % lambda = sqrt(alpha) * beta
                % C = Cprime * C_scale

    C = coefs(1) * C_scale;
    a = 1;
    b = lambda;
%     b = lambda/sqrt(a);
    

    f = C * 1/((b^a)*gamma(a)) * x.^(a-1).*exp(-x/b);

end
