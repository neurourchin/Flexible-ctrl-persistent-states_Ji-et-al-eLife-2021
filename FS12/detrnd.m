function [xo,yo] = detrnd(x,y,dn)
if isempty(x)
    x = 1:length(y);
end
nid = find(~isnan(y));
xo = x(nid);
yd = y(nid);
switch dn
    case 1
yt = fit(xo(:),yd(:),'exp1');
    case 2
yt = fit(xo(:),yd(:),'exp2');
    case 3
yt = fit(xo(:),yd(:),'poly1');
end

ytr = feval(yt,xo);
ytr = (ytr/(ytr(1)))';
yo = yd./ytr;