function [N,xm,ym,h] = make2ddhist(x,y,xeds,yeds,mth)
if isempty(yeds);yeds = xeds; end
switch mth
    case 1
        [xm,ym] = meshgrid(xeds(2:end),yeds(2:end));
        [N,Xeds,Yeds] = histcounts2(xset{2},yset{2},xeds,yeds);
        N = N/sum(N(:));
        h = pcolor(xm,ym,N');
        h.LineStyle = 'none';
        
    case 2
        h = histogram2(x,y,xeds,yeds,'DisplayStyle','tile','ShowEmptyBins','on','EdgeColor','none');
end
