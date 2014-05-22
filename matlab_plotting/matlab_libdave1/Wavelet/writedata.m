
function s = writedata (s, name, filename, fid, mode)

s.name = name;
fprintf(fid,'\n%s\t',s.name);

if mode == 1
    fprintf(fid,'Stats:\t');
    fprintf(fid,'%s\t',num2str(s.statsdata.mean));
    fprintf(fid,'%s\t',num2str(s.statsdata.std));
    fprintf(fid,'%s\t',num2str(s.statsdata.var));
    fprintf(fid,'%s\t',num2str(s.statsdata.skew));
    fprintf(fid,'%s\t',num2str(s.statsdata.kurt));
    fprintf(fid,'%s\t',num2str(s.statsdata.pdfcoefs(2)));
    fprintf(fid,'%s\t',num2str(s.general_beta_est.beta_est));
    fprintf(fid,'%s\t',num2str(s.general_beta_est.wvbeta_est));
    fprintf(fid,'%s\t',num2str(s.statsdata.pdfcoefs5(3)));    % Gamma mod alpha
    fprintf(fid,'%s\t',num2str(s.statsdata.pdfcoefs5(4)));    % Gamma mod beta
    fprintf(fid,'%s\t',num2str(s.statsdata.pdfcoefs7(2)));    % Cauchy-Gauss mod alpha
    fprintf(fid,'%s\t',num2str(s.statsdata.pdfcoefs7(3)));    % Cauchy-Gauss mod beta
end

if mode == 2
    fprintf(fid,'Betas:\t');
    betsiz = size(s.betas.b);
    for i = fliplr(2:betsiz(2))
        fprintf(fid,'%s\t',num2str(s.betas.b(2,i)));
    end
end

if mode == 3
    fprintf(fid,'Power:\t');
    powsiz = size(s.betas.power.val);
    for i = fliplr(1:powsiz(2))
        fprintf(fid,'%s\t',num2str(s.betas.power.val(i)));
    end
end

if mode == 4
    fprintf(fid,'PowerFreq:\t');
    freqsiz = size(s.betas.power.freq);
    for i = fliplr(1:freqsiz(2))
        fprintf(fid,'%s\t',num2str(s.betas.power.freq(i)));
    end
end

