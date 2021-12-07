setsavpath
DirLog
cnmvec = {'NSM','AIY','RIB','AVB','RME','RIA','ASI','AIA','AVA','RIF'};
cvc = {.2*ones(1,3),.9*[0 0 1]};
svon = 0;
foi = 27;
%%
gtype = 'wt';
load([savpath gtype '_alldata.mat'])
load([savpath gtype '_NSM_triggstat.mat'])

fids = find(Fdx>0);
cdata = Cdat(fids,:);
fidata = Fdx(fids);
vdata = Vdat(fids);
nlab = nsm_clust(fids);
vlab = vax_clust(fids);

bnm = 50; dt = 30;
tpre = 240; tpost = 900;
if ~exist('ncmap','var')
    ncmap = jet(100);
end

varout = nsmtrigger_on(NTR,vdata,vdata,fidata,nsm_gmfit,tpre,tpost);
TD_on = varout.tdon;

wspdat = abs(TD_on(1).vals); 
cout = cal_matmean(wspdat,1,1);
mf = 3;
wspm = medfilt1(cout.mean,mf); wspcl = medfilt1(cout.ci(1,:),mf);
wspch = medfilt1(cout.ci(2,:),mf);
figure(foi);clf; hold all
plot_bci([],[wspcl(:) wspch(:)]',(wspm(:))',cvc{1},[],[])

%%
gtype = 'gcy28ChN'; %'gcy28Chmful';
load([savpath gtype '_alldata.mat'])
load([savpath gtype '_NSM_triggstat.mat'])

fids = find(Fdx>0);
cdata = Cdat(fids,:);
fidata = Fdx(fids);
vdata = Vdat(fids);
nlab = nsm_clust(fids);
vlab = vax_clust(fids);

bnm = 50; dt = 30;
tpre = 600; tpost = 600;
if ~exist('ncmap','var')
    ncmap = jet(100);
end

dw = 5;
cnd = TD_on(1).vals;
cout = cal_matmean_ds(cnd,1,dw,1);
mf = 1;
spm = medfilt1(cout.mean,mf); spcl = medfilt1(cout.ci(1,:),mf);
spch = medfilt1(cout.ci(2,:),mf);

%
cvc = {.2*ones(1,3),.9*[0 0 1]};

figure(foi);clf; hold all
plot_bci(1:length(spm),[spcl(:) spch(:)]',(spm(:))',[.4 .47 .64],cvc{2},[])

% plot(tpre*[1 1],get(gca,'ylim'),'k:','linewidth',1.5)
% plot((tpre+120)*[1 1],get(gca,'ylim'),'k:','linewidth',1.5)
% 
% plotstandard
% set(gca,'xtick',[0:240:(tpre+tpost) (tpre+tpost)],'ytick',0:0.25:2)

%% save data for direct plotting
if svon
savname = ['wt_' gtype '_spdresponse'];
saveas(gcf,[savpath2 savname '.tif'])
saveas(gcf,[savpath2 savname '_optotranspca.fig'])
saveas(gcf,[savpath2 savname '_optotranspca.eps'],'epsc')

save([savpath savname '.mat'],'wspdat','spdat','wspm','spm','wspcl','spcl','wspch','spch')
end