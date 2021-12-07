function behclass_histl(cdata,bvec,cx,clset,hbool)
hold all;box off
bcs = unique(bvec(bvec~=0));

for bi = 1:length(bcs)
    caf = cdata(bvec==bcs(bi));
    [hy,hx] = hist(caf,cx); hy = hy/sum(hy);
    if hbool
        plot(hy,hx,'.-','linewidth',1.5,'color',clset{bi},'markersize',12);
    else
        plot(hx,hy,'.-','linewidth',1.5,'color',clset{bi},'markersize',12);
    end
end

% hold all
% car = cdata(bvec==-1);
% [hy,hx] = hist(car,cx); hy = hy/sum(hy);
% barh(hx,hy,1,'facecolor',clset{2},'edgecolor','none','facealpha',.5);

