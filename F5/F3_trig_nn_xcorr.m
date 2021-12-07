cnmvec = {'NSM','AIY','RIB','AVB','RME','RIA','ASI','AIA','AVA','RIF'};

setsavpath
DirLog

gtype = 'wt';
load([savpath gtype '_alldata.mat'])
load([savpath gtype '_NSM_triggstat.mat'])
%%
cls = [1:10];

fids = find(Fdx>0);
cdata = Cdat(fids,:);
fidata = Fdx(fids);
vdata = Vdat(fids);
%%
tpre = 600+1; tpost = 300+1;
if ~exist('ncmap','var')
    ncmap = jet(100);
end

varout = nsmtrigger_on(NTR,cdata,vdata,fidata,nsm_gmfit,tpre,tpost);
T_on = varout.tdon;

%% smooth triggered data
tmw = 50;
tn = size(T_on(1).vals,1);
tl = size(T_on(1).vals,2);
Tm = cell(1,length(T_on));

for ci = 1:length(T_on)
    for ti = 1:tn
        tdat = T_on(ci).vals(ti,:);
        tdm = slidingmean([],tdat,tmw,-1);
        Tm{ci}(ti,:) = tdm;
    end    
end
%%
if ~exist('ncmap','var')
    ncmap = jet(100);
end
pd = [3 2 8 9 1]; 
flst = [40 41];
stclr = getstateclr;
xi = 1;

foi = flst(1);
figure(foi); clf; hold all
c1 = pd(1); c2 = pd(3);
xclr = stclr(1,:);
nn_xcorr_ts
plotstandard
set(gca,'xtick',xnon+[-60:30:60],'ytick',0:.25:.7,'ylim',[-.05 .65])
set(gcf,'outerposition',[56 734 235 272])
xcfset{xi} = xcmat;

foi = flst(1);
figure(foi); hold all
c1 = pd(2); c2 = pd(3);
xclr = stclr(1,:)+[.06 0.3 .13];%+[.2 0 .2];
nn_xcorr_ts
plotstandard
set(gca,'xtick',xnon+[-60:30:60],'ytick',0:.25:.7,'ylim',[-.05 .65])
set(gcf,'outerposition',[56 734 235 272])
xcfset{xi+1} = xcmat;
%%
foi = flst(2);
figure(foi); clf; hold all
c1 = pd(end); c2 = pd(3);
xclr = stclr(2,:);
nn_xcorr_ts
plotstandard
set(gca,'xtick',xnon+[-60:30:60],'ytick',0:.25:.5,'ylim',[-.15 .5])
set(gcf,'outerposition',[56 434 235 272])
xcfset{2} = xcmat;
