% plot_singles_num = 1;


if plot_singles_num == 1
    currpm = pm1;
    currpmz = pmz1;
    currerr = pm_err1;
elseif plot_singles_num == 2
    currpm = pm2;
    currpmz = pmz2;
    currerr = pm_err2;
elseif plot_singles_num == 3
    currpm = pm3;
    currpmz = pmz3;
    currerr = pm_err3;
end

index = find ((currpmz(:,1)>=0) .* (currpmz(:,1)<=36));
currpm=currpm(index,:); currpmz = currpmz(index,:); currerr = currerr(index,:);


figure;
set (gcf, 'Position',[524 339 560*3/3 420*4/3]*font_scaling,'Color','w');
pm_shift = currpm - repmat(mean(currpm),size(currpm,1),1);
pm_shift2 = [pm_shift(:,1)+6 pm_shift(:,2)+4 pm_shift(:,3)+2 pm_shift(:,4)+0];
% pm_shift2 = pm_shift2 + abs(min(min(pm_shift2(:,[1 3 4])))) + 0.5;
% pm_shift2 = pm_shift2 + abs(min(min(pm_shift2(:,:)))) + 0.5;
% pm_shift2 = pm_shift;

currpmz = currpmz(:,1);
hold on; errorbar(currpmz, pm_shift2(:,1),currerr(:,1),'b','LineWidth',2);
hold on; errorbar(currpmz, pm_shift2(:,2),currerr(:,2),'g','Color',[0 0.5 0],'LineWidth',2);
hold on; errorbar(currpmz, pm_shift2(:,3),currerr(:,3),'r','LineWidth',2);
hold on; errorbar(currpmz, pm_shift2(:,4),currerr(:,4),'c','Color',[0 0.75 0.75],'LineWidth',2);

% ox=6; oy=-.5; lenx=12; leny=0;     % x is 0.50sec=500msec; y is 20 mV
% plot_scale([(ox+lenx/2) oy], [1], [lenx],'k','hours','h')
% ox=30; oy=-.5; lenx=6; leny=0;     % x is 0.50sec=500msec; y is 20 mV
% plot_scale([(ox+lenx/2) oy], [1], [lenx],'k','hours','h')


axis ([-4 39 -1.5 8.5])
ox=-3; oy=-0.5; lenx=1; leny=0;     % x is 0.50sec=500msec; y is 20 mV
plot_scale([(ox+lenx/2) oy], [1], [lenx],'k','Hz','v')
set(gca,'Visible','off')

ylevel = -1.5;
ythick = 0.2;
rectangle('Position',[0 ylevel 6 ythick],'FaceColor','k');
rectangle('Position',[6 ylevel 12 ythick],'FaceColor','w');
rectangle('Position',[18 ylevel 12 ythick],'FaceColor','k');
rectangle('Position',[30 ylevel 6 ythick],'FaceColor','w');