


% Produces three plots  in the same figure
%

function plot3subs (xy1, xy2, xy3, n1, n2, n3)
axminy = -65.5;
axmaxy = -64.5;
axminx = 0;
axmaxx = 60;

subplot (311)
plot(xy1(:,1),xy1(:,2));
axis ([axminx axmaxx axminy axmaxy]);
title (n1);


subplot (312)
plot(xy2(:,1),xy2(:,2));
axis ([axminx axmaxx axminy axmaxy]);
title (n2);


subplot (313)
plot(xy3(:,1),xy3(:,2));
axis ([axminx axmaxx axminy axmaxy]);
title (n3);

end
