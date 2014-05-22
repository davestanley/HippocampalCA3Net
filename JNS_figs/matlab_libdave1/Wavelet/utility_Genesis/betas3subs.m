


% Produces three plots of betas in the same figure
%

function beta3subs (xy1, xy2, xy3, n1, n2, n3)
axminy = 0;
axmaxy = 4;
axminx = 0;
axmaxx = 18;




s = xy1;
%Plot the betas
subplot(311)
bar (fliplr(s.betas.b(2,2:size(s.betas.b,2))));
numcoefs = length (s.wvstruct.dwt);
%Add text and axis labels
for i = 2:numcoefs
    %Calculate frequencies and store in array to be placed along x-axis
    %xlabel_arr(i-1) = {[num2str(1/(2^(i-1))/s.dt1,'%1.1f') '-' num2str(1/(2^i)/s.dt1,'%1.1f')]};
    xlabel_arr(i-1) = {[num2str(1/(2^i)/s.dt1,'%1.1f')]};

    %Also draw in the scales
    ypos = max(s.betas.b(2,2:size(s.betas.b,2))) * 1;
    %text(numcoefs-(i-1)-.5, ypos, ['Scl' num2str(2^(i-1)) '-' num2str(2^i)],'FontSize',8);
    text(numcoefs-(i-1)-.5, ypos, ['Scl' num2str(2^(i-1))],'FontSize',8);
end

xlabel_arr = fliplr (xlabel_arr);
set(gca,'XTick',1:numcoefs-1)
set(gca,'XTickLabel',xlabel_arr, 'FontSize', 8)
title(n1);
xlabel ('Hz');
axis ([axminx axmaxx axminy axmaxy]);


s = xy2;
%Plot the betas
subplot(312)
bar (fliplr(s.betas.b(2,2:size(s.betas.b,2))));
numcoefs = length (s.wvstruct.dwt);
%Add text and axis labels
for i = 2:numcoefs
    %Calculate frequencies and store in array to be placed along x-axis
    %xlabel_arr(i-1) = {[num2str(1/(2^(i-1))/s.dt1,'%1.1f') '-' num2str(1/(2^i)/s.dt1,'%1.1f')]};
    xlabel_arr(i-1) = {[num2str(1/(2^i)/s.dt1,'%1.1f')]};

    %Also draw in the scales
    ypos = max(s.betas.b(2,2:size(s.betas.b,2))) * 1;
    %text(numcoefs-(i-1)-.5, ypos, ['Scl' num2str(2^(i-1)) '-' num2str(2^i)],'FontSize',8);
    text(numcoefs-(i-1)-.5, ypos, ['Scl' num2str(2^(i-1))],'FontSize',8);
end

xlabel_arr = fliplr (xlabel_arr);
set(gca,'XTick',1:numcoefs-1)
set(gca,'XTickLabel',xlabel_arr, 'FontSize', 8)
title(n2);
xlabel ('Hz');
axis ([axminx axmaxx axminy axmaxy]);




s = xy3;
%Plot the betas
subplot(313)
bar (fliplr(s.betas.b(2,2:size(s.betas.b,2))));
numcoefs = length (s.wvstruct.dwt);
%Add text and axis labels
for i = 2:numcoefs
    %Calculate frequencies and store in array to be placed along x-axis
    %xlabel_arr(i-1) = {[num2str(1/(2^(i-1))/s.dt1,'%1.1f') '-' num2str(1/(2^i)/s.dt1,'%1.1f')]};
    xlabel_arr(i-1) = {[num2str(1/(2^i)/s.dt1,'%1.1f')]};

    %Also draw in the scales
    ypos = max(s.betas.b(2,2:size(s.betas.b,2))) * 1;
    %text(numcoefs-(i-1)-.5, ypos, ['Scl' num2str(2^(i-1)) '-' num2str(2^i)],'FontSize',8);
    text(numcoefs-(i-1)-.5, ypos, ['Scl' num2str(2^(i-1))],'FontSize',8);
end

xlabel_arr = fliplr (xlabel_arr);
set(gca,'XTick',1:numcoefs-1)
set(gca,'XTickLabel',xlabel_arr, 'FontSize', 8)
title(n3);
xlabel ('Hz');
axis ([axminx axmaxx axminy axmaxy]);

end
