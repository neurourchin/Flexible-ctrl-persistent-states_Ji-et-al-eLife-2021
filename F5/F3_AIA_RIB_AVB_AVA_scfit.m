% clear
DirLog
cnmvec = {'NSM','AIY','RIB','AVB','RME','RIA','ASI','AIA','AVA','RIF'};

setsavpath

gtype = 'wt';
load([savpath gtype '_alldata.mat'])
load([savpath gtype '_NSM_triggstat.mat'])

svon = 0;
%%
cid = 3; cls = [1:10];

fids = find(Fdx>0);
cdata = Cdat(fids,:);
fidata = Fdx(fids);
vdata = Vdat(fids);
clx = nsm_clust(fids);
cln = max(clx);

dti = 5; % use 30s res
tres = 300;
foi = 40;
%% prepare peri-event datasets
tpre = 480; tpost = 0; % 4min pre
dst = 30;

varout = nsmtrigger_onflex(NTR,cdata,vdata,fidata,nsm_gmfit,tpre,tpost);
TD_on = varout.tdon;
CT_on = varout.cton;
cnm = length(TD_on);

% now downsample data in 10s increments
[~,TDs] = tddownsmpl(TD_on,dst);
[~,CTs] = tddownsmpl(CT_on,dst);

% group data into 3 windows 1-30s, 90-120, 150-180, make sure to exclude 0s
% before calc stats
tsl = size(TDs(1).vals,2);
woi = {13:16}; 
clear tdgp
tdgp(cnm) = struct('gp',struct('dat',[]));
for wi = 1:length(woi)
    for ci = 1:cnm
        TDs(ci).vals(TDs(ci).vals==0) = nan;
        ttmp = TDs(ci).vals(:,woi{wi});
        ttmp(ttmp==0) = nan;
        tdgp(ci).gp(wi).dat = ttmp;
    end
end

% generate scatterhist plots
cset = [3 4 8 9 1];
c1 = cset(3); c2 = cset(2);

stclr = getstateclr;
clmat = [stclr(1,:); clr(1,:)];
clmat = [stclr(1,:); [0 .65 0]];

nnscat_fit_n