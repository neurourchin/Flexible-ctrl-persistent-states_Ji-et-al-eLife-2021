
clear
cnmvec = {'NSM','AIY','RIB','AVB','RME','RIA','ASI','AIA','AVA','RIF'};

setsavpath
DirLog

fgtype = {'wt','tph1','mod1','pdfr1','pdfracy1','tph1pdfr1'};
svon = 0;
%%
gi = 1;
cd1 = cell(1,6); cd2 = cd1;
fidd = 191;
clear bn cn; %cn{2} = -2000:100:2200;
if fidd<=190
    ylm = [-.1 1.8]; %setfigsiz([-30 200 328 291])
    cn{1} = -.15:.075:2.1;
else
    ylm = [-.1 1.2]; %setfigsiz([-30 100 328 291])
    cn{1} = -.15:.05:2.1;
end
cn{2} = cn{1};
% xlm = [-2000 2100];
setfigsiz([-30 200 689 435])
xlm = ylm;
rbmap;

gtype = fgtype{gi};
clear Cdat Bst2 Vdat Bst
if fidd<=190
    load([savpath gtype '_alldata_nostrnrm.mat']) 
else
    load([savpath gtype '_alldata.mat'])
end
%
coi = [1 4];
clm = [-7.5 -3];
clm2 = [0.000 0.025];
dlg = 1;
pst = struct('rm',[],'dw',[]);
fids = find(Fdx>0);
cdata = Cdat(fids,:);
cdata(cdata==0) = nan;
fdata = Fdx(fids);
vdata = Vdat(fids)/20000;
bdata = Bst2(fids);
xth = multithresh(cdata(:,1));
yth = multithresh(cdata(:,4));

figure(fidd+gi-1);clf;hold all
rc1 = Cdat(Bst2==1,coi(1)); 
rc2 = Cdat(Bst2==1,coi(2));
dli = rc1==0|rc2==0;
rc1(dli) = []; rc2(dli) = []; rc21=rc2;
[r,p] = corr(rc1,abs(rc2),'type','spearman');
[rf,pf] = corr(rc1(rc2>0),rc2(rc2>0),'type','spearman');
[rr,pr] = corr(rc1(rc2<0),abs(rc2(rc2<0)),'type','spearman');
pst.dw = [pst.dw;[r p rf pf rr pr]];
subplot 121;cla;hold all
hp = make2dhistp(rc2,rc1,cn,dlg);
plot([0 0],ylm,'k:','linewidth',1)
ytl = 1; plotstandard
set(gca,'xlim',xlm,'ylim',ylm); axis square
if dlg
    caxis(clm)
else
    caxis(clm2)
end
colormap(rbmp)
plot([xth xth;-1 2]',[-1 2;yth yth]','k:','linewidth',1.5)
set(gca,'xtick',0:.5:1,'ytick',0:.5:1,'yticklabel','')
box off
title('Dwelling')

rc1 = Cdat(Bst2==2,coi(1)); % &Bst<3
rc2 = Cdat(Bst2==2,coi(2));
dli = rc1==0|rc2==0;
rc1(dli) = []; rc2(dli) = [];
[r,p] = corr(rc1,abs(rc2),'type','spearman');
[rf,pf] = corr(rc1(rc2>0),rc2(rc2>0),'type','spearman');
[rr,pr] = corr(rc1(rc2<0),abs(rc2(rc2<0)),'type','spearman');
pst.rm = [pst.rm;[r p rf pf rr pr]];
subplot 122;cla;hold all
hp = make2dhistp(rc2,rc1,cn,dlg);
plot([0 0],ylm,'k:','linewidth',1)
plotstandard
set(gca,'xlim',xlm,'ylim',ylm);  axis square
if dlg
    caxis(clm)
else
    caxis(clm2)
end
colormap(rbmp)
plot([xth xth;-1 2]',[-1 2;yth yth]','k:','linewidth',1.5)
set(gca,'xtick',0:.5:1,'ytick',0:.5:1,'yticklabel','')
box off
title('Roaming')
