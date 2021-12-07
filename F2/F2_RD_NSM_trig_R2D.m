setsavpath
DirLog

fgtype = {'wt','tph1','mod1','pdfr1','tph1pdfr1','tph1i','pdfracy1'};
svon = 0;

gtype = 'wt';
load([savpath gtype '_alldata.mat'])
%%
Nmat = [];Nbd = [];
foi = unique(Fdx); 
%
fiid = 130;
for fi = (foi(:))'
    %%
    cdats = Cdat(Fdx==fi,1);
    vdats = Vdat(Fdx==fi,1);
    bt2 = Bst2(Fdx==fi);
    nnt = Nst(Fdx==fi);
    
    [btdurs,btidx,btseg] = idx2bseg(bt2);
    trigidx = btseg(:,1);
    dli = trigidx<=3|(trigidx>=(length(cdats)-5));
    trigidx(dli) = [];
    ntwin = [-360 360];
    ntmat = trig_general(cdats,trigidx,ntwin);
    nbmat = trig_general(nnt,trigidx,ntwin);
    for ni = 1:size(ntmat,1)
        np = regionprops(nbmat(ni,:)>0,'PixelIdxList');
        np1 = [];
        for pii = 1:length(np)
            np1(pii) = np(pii).PixelIdxList(1);
        end
        nrd = findnearestneighbor(abs(ntwin(1)),np1);
        Nbd = [Nbd np1(nrd(1))];
    end
    Nmat = [Nmat;ntmat];
end
%
ytl = 0;
[nin,nsrt] = sort(Nbd,'descend');
ymx = size(Nmat,1);
figure(fiid+1); clf; hold all
setfigsiz([76 422 172 363])
subplot(5,1,2:5);cla;hold all
imagesc(Nmat(nsrt,:)); hold all
% imagesc(Nmat); hold all
caxis([-.05 1.5])
plot(abs(ntwin(1))+[1 1],[0 ymx+.5],'k:','linewidth',1.5)
for ni = 1:ymx
    plot(nin(ni)*[1 1],ni+[-.5 .5],'k','linewidth',1) % Nbd nin
end
colormap jet
xlim([0 sum(abs(ntwin))+1.5]);ylim([0.5 ymx+.5])
plotstandard
set(gca,'xtick',0:120:2400)
%
subplot 511;cla;hold all
nmo = cal_matmean(Nmat,1,1);
bx = [];
bci = nmo.ci; bmn = nmo.mean;
pclr = 'k'; mclr = []; lstl = [];
plot_bci(bx,bci,bmn,pclr,mclr,lstl)
xlim([0 sum(abs(ntwin))+1.5]);ylim([0 .8])
plot(abs(ntwin(1))+[1 1],[0 1],'k:','linewidth',1.5)
plotstandard
set(gca,'xtick',0:120:2400) 

if svon
    %%
    savname = [gtype '_ngbgtrig_R2D'];
    saveas(gcf,[savpath2 savname '.tif'])
    saveas(gcf,[savpath2 savname '.fig'])
    saveas(gcf,[savpath2 savname '.eps'],'epsc')
    
    save([savpath savname '.mat'],'Nmat','Nbd','nsrt')
end
% % figure(2);clf;hold all;subplot 211;hold all;plot(cdats);plot(nnt)
% % subplot 212;cla;hold all;plot(vdats);yyaxis right;plot(bt2)