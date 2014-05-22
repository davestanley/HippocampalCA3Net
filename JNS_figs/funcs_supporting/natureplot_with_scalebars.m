% plot_healthy_on = 1;
% plot_healthy_on = 0;

if plot_healthy_on
    currpm = pm1;
    currpmz = pmz1;
    currerr = pm_err1;
else
    currpm = pm2;
    currpmz = pmz2;
    currerr = pm_err2;
end

figure;
set (gcf, 'Position',[524 339 560*3/3 420*4/3]*font_scaling,'Color','w');
pm_shift = currpm - repmat(mean(currpm),size(currpm,1),1);
pm_shift2 = [pm_shift(:,1)+4 pm_shift(:,2)+2 pm_shift(:,3)+2 pm_shift(:,4)+0];
% pm_shift2 = pm_shift2 + abs(min(min(pm_shift2(:,[1 3 4])))) + 0.5;
% pm_shift2 = pm_shift2 + abs(min(min(pm_shift2(:,:)))) + 0.5;
% pm_shift2 = pm_shift;

currpmz = currpmz(:,1);
hold on; errorbar(currpmz, pm_shift2(:,1),currerr(:,1),'b','LineWidth',2);
if plot_healthy_on;
    hold on; errorbar(currpmz, pm_shift2(:,2),currerr(:,2),'g--','Color',[0 0.5 0],'LineWidth',2); end
hold on; errorbar(currpmz, pm_shift2(:,3),currerr(:,3),'r','LineWidth',2);
hold on; errorbar(currpmz, pm_shift2(:,4),currerr(:,4),'c','Color',[0 0.75 0.75],'LineWidth',2);

% ox=6; oy=-.5; lenx=12; leny=0;     % x is 0.50sec=500msec; y is 20 mV
% plot_scale([(ox+lenx/2) oy], [1], [lenx],'k','hours','h')
% ox=30; oy=-.5; lenx=6; leny=0;     % x is 0.50sec=500msec; y is 20 mV
% plot_scale([(ox+lenx/2) oy], [1], [lenx],'k','hours','h')


if plot_healthy_on
    axis ([-4 39 -1.5 6.5])
    ox=-3; oy=-0.5; lenx=1; leny=0;     % x is 0.50sec=500msec; y is 20 mV
    plot_scale([(ox+lenx/2) oy], [1], [lenx],'k','Hz','v')
else
    axis ([-4 39 -1.5 6.5])
    ox=-3; oy=-0.5; lenx=1; leny=0;     % x is 0.50sec=500msec; y is 20 mV
    plot_scale([(ox+lenx/2) oy], [1], [lenx],'k','Hz','v')
end
set(gca,'Visible','off')

ylevel = -1.5;
if plot_healthy_on; ythick = 0.2;
else; ythick = 0.2; end
rectangle('Position',[0 ylevel 6 ythick],'FaceColor','k');
rectangle('Position',[6 ylevel 12 ythick],'FaceColor','w');
rectangle('Position',[18 ylevel 12 ythick],'FaceColor','k');
rectangle('Position',[30 ylevel 6 ythick],'FaceColor','w');