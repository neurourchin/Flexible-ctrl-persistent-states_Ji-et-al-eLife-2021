% clear
DirLog
cnmvec = {'NSM','AIY','RIB','AVB','RME','RIA','ASI','AIA','AVA','RIF'};

setsavpath
%%
load([savpath 'wt_alldata.mat'])
load([savpath 'wt_NSMon_trigdata.mat'])
cls = 2:10; 
fids = find(Fdx>0);
cdata = Cdat(fids,:);
fidata = Fdx(fids);
vdata = Vdat(fids);
nlab = nsm_clust(fids);
vlab = vax_clust(fids);

pdat = cdata(:,cls);
% for ci = 1:10
%     pdat(:,ci) = smooth(cdata(:,ci),15);
% end

cvals = vdata;
% cvals = vlab;
cvals = cdata(:,1);

[pc,score,latent,explnd] = runPCA(pdat,0,-1,cvals);

trig_PCA_traj
