setsavpath
svon = 0 ;
% general params
gtlist = {'wt' 'tph1' 'pdfr1' 'tph1pdfr1' 'unc31' 'tdc1' 'ttx3unc103gf' 'mod1' 'gcy28Chm'};
cgtype = 'wt';

gtype = cgtype;
load([savpath gtype '_alldata.mat'])

clrs = getstateclr;
clrs2 = min(1,(clrs+.4));
clset = {clrs(2,:),clrs(1,:)};
clset2 = {clrs2(2,:),clrs2(1,:)};

GLM_locpred
GLM_behpred_rdroc
%%
figure(199);clf;hold all
generate_discts_patch((btst(:))',tdst',clset,[1.8 2],.7)
hold all
generate_discts_patch((gdt(:))',tdst',clset2,[1.5 1.7],.7)

plot(tdst,lsty+.2,'k','linewidth',.5); 
plot(tdst,ltpred+.2,'r','linewidth',1)
plot(tdst([1 end]),[0 0]+.2,'k:','linewidth',1)

plot(tdst,Cdat(Fdx==ftsi,1)-2.2)
plot(tdst,Cdat(Fdx==ftsi,9)-2.2)

xlim(tdst([1 end-250]))
ylim([-2.4 2])
set(gca,'yticklabel','','xticklabel','','xtick',0:600:tdst(end))
setfigsiz([42 371 593 320])
set(gca,'tickdir','out','ticklength',[.02 .02],...
    'ytick',[-2.2 -1.2 (-1:2)+.2])

savfig(savpath2,'F1S_locopred')
%%
cmap = cmap_gen({[0.2 0.2 1],[1 .4 .4]},1);
prn = 1;
xed = -1:.05:1; yed = xed;
figure(10);clf;hold all
lx = [trny;lsty];
ly = [lpred;ltpred];
% transparentScatter(lx,ly,.02,.05,'b')
make2dhist(lx,ly,{xed,yed})
plot([0 0],prn*1*[-1 1],'k--');
plot(prn*1*[-1 1],[0 0],'k--')
ylim([-1 1]);xlim(prn*[-1 1])
colormap(cmap)
caxis([10 200])

[rho,p] = corr(lx,ly,'type','Spearman')
rmse = sqrt(mean((lx-ly).^2))
% [b,stb] = robustfit(lx,ly);

% [b,~,~,~,stats] = regress(ly,[ones(length(lx),1) lx])
% yrl = xed*b(2)+b(1);
% plot(xed,yrl,'y')
ytl = 1;
plotstandard
savfig(savpath2,'F1S_lv_pred')
%%
cem = cerr;
make_barplt([],{cem(:,2)/5,cem(:,1)/3},clset,89,[],1)
plotstandard
savfig(savpath2,'F1S_bt_pred')
