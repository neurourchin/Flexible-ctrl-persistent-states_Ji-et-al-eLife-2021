cnmvec = {'NSM','AIY','RIB','AVB','RME','RIA','ASI','AIA','AVA','RIF'};
setsavpath
gset = {'tph','mod','pdfr'};
corder = [1 4 2 3 5 6 7 8 9 10 11];
clst = {.7*ones(1,3),[.8 0.3 .3],[0.2 .6 0.2]};
pmat = [];
rn1 = 598:599; rn2 = 659:660;

for gi = 3%:length(gset)
    gtype = [gset{gi} 'opctl'];
    load([savpath gtype '_NSM_triggstat.mat'])
    tdcl = TD_on;
    gtype = [gset{gi} '1opt'];
    load([savpath gtype '_NSM_triggstat.mat'])
    tdo = TD_on;
    
    for ci = 1:length(TD_on)
        px1 = abs(tdcl(ci).vals(:,rn1)); px2 = abs(tdcl(ci).vals(:,rn2));
        [pc,~] = ranksum(px1(:),px2(:));
        px1 = tdo(ci).vals(:,rn1); px2 = tdo(ci).vals(:,rn2);
        [po,~] = ranksum(px1(:),px2(:));
        pmat(ci,:) = [po,pc];
    end
end
pmp = mafdr(pmat(:),'BHFDR',true);
pmp = reshape(pmp,size(pmat))
%%
if svon
svname = [gtype '_opto_cgcf.mat'];
save([savpath,svname],'pmat','pmp','rn1','rn2')
end