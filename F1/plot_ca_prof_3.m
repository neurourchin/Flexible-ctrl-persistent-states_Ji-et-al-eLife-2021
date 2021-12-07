cnum = size(cdata,2);
plnum = cnum;
pli = 1;
% clset = {[.93 .69 .13],[.49 .18 .56],[.4 .67 .19]};
clrs = getstateclr;
clset = {clrs(2,:),clrs(1,:)};
vclrs = getvclrs;
if max(abs(vdata))>1
vsm = (medfilt1(vdata,33))/20000;
else
    vsm = (medfilt1(vdata,33));
end

vsm(vsm>vth) = vth; vsm(vsm<-vth) = -vth;
ch = 1.8;
yrnm = [-.2 length(corder)*ch+2];

figure(125);clf;hold all
set(gcf,'outerposition',[13 42 500 782])
colorline_general([vsm' vth],[catime' catime(length(catime))+.0001],...
    vclrs{1},vclrs{2},[-.5 yrnm(2)-2])

for ci = corder(end:-1:1)
    cdat = cdata(:,ci);
    cmax = prctile(cdat(~isnan(cdat)),99.95);

    plot(catime,cdat+(pli-1)*ch,'-','color','k','linewidth',1.5) % [0 .3 0]
    pli = pli+1;
    
end


generate_discts_patch((btdata(:))',catime',clset,[yrnm(2)-1 yrnm(2)],.7)

set(gca,'xtick',0:300:catime(end),'xticklabel',{'0','','10','','20','','30','','40','','50'},'xlim',...
    [catime(1) catime(end)],'tickdir','out','ticklength',[.015 .015],'fontsize',12,...
    'ytick',[0 1],'ylim',yrnm)
set(gca,'yticklabel','','xticklabel','')

