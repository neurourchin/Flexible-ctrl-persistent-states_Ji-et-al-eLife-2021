function behclass_hist(cdata,bvec,cx,clset)
hold all;box off
bcs = unique(bvec(bvec~=0));

for bi = 1:length(bcs)
    caf = cdata(bvec==bcs(bi));
    [hy,hx] = hist(caf,cx); hy = hy/sum(hy);
    barh(hx,hy,1,'facecolor',clset{bi},'edgecolor','none','facealpha',.5);
end

% hold all
% car = cdata(bvec==-1);
% [hy,hx] = hist(car,cx); hy = hy/sum(hy);
% barh(hx,hy,1,'facecolor',clset{2},'edgecolor','none','facealpha',.5);

