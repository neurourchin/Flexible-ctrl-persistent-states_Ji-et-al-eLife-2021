setsavpath
svon = 0 ;
% general params
gtlist = {'wt' 'tph1' 'pdfr1' 'tph1pdfr1' 'unc31' 'tdc1' 'ttx3unc103gf' 'mod1' 'gcy28Chm'};
cgtype = 'wt';

gtype = cgtype;
load([savpath gtype '_alldata.mat'])
load([savpath gtype '_NSM_triggstat.mat']) 
cls = [2:10];
svon = 0;
%% scan through temporal resolutions
trset = [15 40 60 75 90];
fnm = 2; 
tpre = 120; tpost = 0;
clear cmdl

for ti = 1:length(trset)
    t_res = trset(ti);   
    fwn = floor(tpre/t_res);
    cmdl(ti).fspc = [t_res fwn];
        
    TDstat1 = extract_trigstat2(TD_on,t_res,fwn);
    CTstat1 = extract_trigstat2(CT_on,t_res,fwn);
    
    fiid = 10*ti;
    train_net_routine
    cmdl(ti).acr = tacr1;
    cmdl(ti).fltrw = hfilt1;
    cmdl(ti).fltp = hct;
    cmdl(ti).mfilt = hbnd;
    cmdl(ti).auc = aucf1;
    cmdl(ti).roc = rocf1;
    cmdl(ti).aic = aic;
    cmdl(ti).maic = nanmean(aic);
    cmdl(ti).bic = bic;
    cmdl(ti).mbic = nanmean(bic);
    cmdl(ti).bic2 = bic2;
    cmdl(ti).mbic2 = nanmean(bic2);
    cmdl(ti).aicc = ic.aicc;
    cmdl(ti).maicc = nanmean(ic.aicc);
      
    if svon
        figure(fiid)
        savname = [gtype '_nsmon9nn_res' num2str(t_res)];
        saveas(gcf,[savpath2 savname '.tif'])
        saveas(gcf,[savpath2 savname '.fig'])
        saveas(gcf,[savpath2 savname '.eps'],'epsc')
        
        save([savpath savname '.mat'],'tacr1','hfilt1',...
            'hct','hbnd','aucf1','rocf1','aic','bic','ic')
    end
end

%% plot and compare model performances
% % aum = []; auci = [];
% % for mi = 1:length(cmdl)
% % cmdl(ti).pf.auc = aucf1;
% % aum = ca
% % end

clrs = rand(1,3);
figure(120);clf;hold all
subplot 411
aucf = {cmdl(:).auc}; 
make_barplt([],aucf,clrs,[],[],1)
subplot 412
aicf = {cmdl(:).aic};
make_barplt([],aicf,clrs,[],[],1)
subplot 413
bicf = {cmdl(:).bic};
make_barplt([],bicf,clrs,[],[],1)
hold all;
bic2f = {cmdl(:).bic2};
make_barplt([],bic2f,clrs,[],[],1)
subplot 414
aiccf = {cmdl(:).aicc};
make_barplt([],aiccf,clrs,[],[],1)
%% quantify and compare test accuracies between auth and scrmb
aust = struct('mn',[],'ci',[]); aup = []; aupt = aup; clear auc
aum1 = nanmean(aucf1);
auci1 = bootci(100,@nanmean,aucf1);

aumc = nanmean(aucfc);
aucic = bootci(100,@nanmean,aucfc);

aumv = nanmean(aucf);
auciv = bootci(100,@nanmean,aucf);

aumg = nanmean(aucg);
aucig = bootci(100,@nanmean,aucg);

aup(1) = ranksum(aucfc,aucf1);
[~,aupt(1)] = ttest(aucfc,aucf1);
aup(2) = ranksum(aucf,aucf1);
[~,aupt(2)] = ttest(aucf,aucf1);
aup(3) = ranksum(aucg,aucf1);
[~,aupt(3)] = ttest(aucg,aucf1);
rnfdr = mafdr(aup,'BHFDR',true)

bci = [auci1 aucic auciv aucig]; bmn = [aum1 aumc aumv aumg];
auc.cn = aucf1; auc.ctl = aucfc; auc.svm = aucmv; auc.glm = aucg;
auc.mn = bmn; auc.ci = bci;

pclr = [.1*ones(1,3);1 1 1;.4*ones(1,3);.5*ones(1,3)];
bbol = 1;
figure(102);clf;hold all
plot_bcibar([],bci,bmn,pclr,2,[],[],bbol)
plotstandard
set(gca,'ylim',[0 1],'xlim',[.25 length(bmn)+.75],'ytick',0:.25:1,'xtick',1:length(bmn),'yticklabel','')
set(gcf,'outerposition',[57 530 126 220])

if svon
    figure(102);
    savname = [gtype '_cnn' num2str(cls(1)) '-' num2str(cls(end)) '_mcf'];
    saveas(gcf,[savpath2 savname '.tif'])
    saveas(gcf,[savpath2 savname '.fig'])
    saveas(gcf,[savpath2 savname '.eps'],'epsc')
    
    save([savpath savname '.mat'],'auc','aup','aupt','rnfdr')
end