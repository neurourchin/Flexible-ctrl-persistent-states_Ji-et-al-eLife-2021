% clear
DirLog
cnmvec = {'NSM','AIY','RIB','AVB','RME','RIA','ASI','AIA','AVA','RIF'};

setsavpath
%%
vwa = [-107.6 17.9]; % [-65.6 10.8]
gtype = 'wt';
load([savpath gtype '_alldata.mat'])
load([savpath gtype '_NSM_triggstat.mat'])
fids = find(Fdx>0);
cdata = Cdat(fids,:);
fidata = Fdx(fids);
vdata = Vdat(fids);
nlab = nsm_clust(fids);
vlab = vax_clust(fids);

cls = 1:10; %cls(cls == 4) = [];
pdat = cdata(:,cls);
dt = 60;

cvals = vdata;
% cvals = vlab;
cvals = cdata(:,1);

[pc,score,latent,explnd] = runPCA(pdat,0,0,cvals);
%% project NSM activation dynamics on PC space
foi = 15; coi = 1;

trig_PCA_traj
trig_PCA_traj_direct

trig_PCA_traj_wb

wpl = pl; wprm = prm; wpom = pom;
%% tph-1Chrimson
gtype = 'tph1Chm';

load([savpath gtype '_alldata.mat'])
load([savpath gtype '_NSM_triggstat.mat'])

fids = find(Fdx>0);
cdata = Cdat(fids,1:10);
fidata = Fdx(fids);
vdata = Vdat(fids);
% nlab = nsm_clust(fids);
% vlab = vax_clust(fids);
% cvals = vdata/20000;
% cvals = vlab;
cvals = cdata(:,1);

pdat = cdata(:,cls);
% project opto response dynamics on PC space
foi = 18;
trig_opto_traj
trig_opto_traj_wb
