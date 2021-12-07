setsavpath
DirLog
gtype = 'wt';

fdname = [gtype '_ngbgtrig_R2D'];
load([savpath fdname '.mat'],'Nmat','Nbd','nsrt')
nl1 = 120-Nbd;

fdname = [gtype '_ngbgtrig_D2R'];
load([savpath fdname '.mat'],'Nmat','Nbd','nsrt')
nl2 = 360-Nbd;

fiid = 129;
mclr = .7*ones(1,3); em = 1; mz = 5;
[bm,bci] = make_scterplt([],{nl1,nl2},mz,mclr,fiid,em);

set(gca,'ytick',-720:240:720,'yticklabel','','ylim',[-360 420])
setfigsiz([156 546 138 240])
%%
[h,p] = ranksum(nl1,nl2)
sqrt([var(nl1') var(nl2')])

if svon
    savname = [gtype '_DIFFpca_byBst'];
    saveas(gcf,[savpath2 savname '.tif'])
    saveas(gcf,[savpath2 savname '.fig'])
    saveas(gcf,[savpath2 savname '.eps'],'epsc')

end