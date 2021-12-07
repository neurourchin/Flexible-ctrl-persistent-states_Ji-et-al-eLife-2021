dset = fct.dat;
[pmat1,~] = pwrksm(dset);
pv.fct = pmat1;
figure(fid);clf;hold all
[bm,bci] = make_barplt(dx,dset,pclr,fid,bw,2);
% title('Fraction time roaming')
set(gca,'ylim',[0 .5],'ytick',0:.25:.5,'yticklabel','')
set(gcf,'outerposition',[105 641 140 235])


dset = {stdurs(1).dd stdurs(2).dd stdurs(3).dd stdurs(4).dd};
[pmat2,~] = pwrksm(dset);
pv.ddur = pmat2;
figure(fid+1);clf;hold all
[bm,bci] = make_barplt(dx,dset,pclr,fid+1,bw,2);
% title('Dwelling state duration')
set(gca,'ylim',[0 2700],'ytick',0:900:2700,'yticklabel','')
set(gcf,'outerposition',[105 401 140 235])

dset = {stdurs(1).rd stdurs(2).rd stdurs(3).rd stdurs(4).rd};
[pmat3,~] = pwrksm(dset);
pv.rdur = pmat3
figure(fid+2);clf;hold all
[bm,bci] = make_barplt(dx,dset,pclr,fid+2,bw,2);
% title('Roaming state duration')
set(gca,'ylim',[0 800],'ytick',0:360:800,'yticklabel','')
set(gcf,'outerposition',[105 141 140 235])

pcp = [pmat1;pmat2;pmat3];
pfdr = mafdr(pcp(:),'BHFDR',true);
pfdm = reshape(pfdr,[3*length(pmat1) length(pmat1)])