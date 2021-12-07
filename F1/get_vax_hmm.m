ref_gtype = 'wt';
load([savpath ref_gtype '_alldata_e2.mat'],'estTR','estE')
load([savpath gtype '_alldata.mat'],'Cdat','Tdat','Vdat','Fdx')
Xd = extract_vel_medvar_m(Vdat,Fdx);
load([savpath ref_gtype '_vax_gmfit_e2.mat'],'gmfit')
clx = cluster(gmfit,Xd);
if ~exist('ckflg','var')
ckflg = 1;
end

seqs = [];
for fi = unique(Fdx')
fid = find(Fdx == fi);
qtmp = (clx(fid))';
sq = uint8(slidingmedian([],qtmp,60,0));
seqs{fi} = sq;
end

trans = [0.85,.05,0.1; .1 .8 .1; .05 .1 0.85];
emis = [.2, .05 .7 .05;
   .6 .3 .05 .05; .07 .1 .03 .8];

rply = input('Retrain HMM? no-enter/yes-any other key: ','s');
if ~isempty(rply)
[estTR,estE] = hmmtrain(seqs,trans,emis)
end

%%
if svon
save([savpath gtype '_alldata.mat'],'Xd','clx','seqs','bstates','Bst','Bst2','estTR','estE','-append')
disp([gtype '_alldata.mat saved'])
end