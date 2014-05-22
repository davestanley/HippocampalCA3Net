

% Produces three plots of power spectra in the same figure
%

function power3subs (xy1, xy2, xy3, n1, n2, n3)
axminy = -65.5;
axmaxy = -64.5;
axminx = 0;
axmaxx = 60;

subplot (311)
loglog(xy1(:,1), abs(xy1(:,2)).^2 );
% axis ([axminx axmaxx axminy axmaxy]);
title (n1);

subplot (312)
loglog(xy2(:,1), abs(xy2(:,2)).^2 );
% axis ([axminx axmaxx axminy axmaxy]);
title (n2);

subplot (313)
loglog(xy3(:,1), abs(xy3(:,2)).^2 );
% axis ([axminx axmaxx axminy axmaxy]);
title (n3);

end
