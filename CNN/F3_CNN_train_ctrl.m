setsavpath
svon = 0 ;
% general params
gtlist = {'wt' 'tph1' 'pdfr1' 'tph1pdfr1' 'unc31' 'tdc1' 'ttx3unc103gf' 'mod1' 'gcy28Chm'};
cgtype = 'wt';

gtype = cgtype;
load([savpath gtype '_alldata.mat'])
load([savpath gtype '_NSMon_trigdata.mat'],'TDstat','CTstat');
TDstat1 = TDstat; CTstat1 = CTstat;
load([savpath gtype '_NSMoff_trigdata.mat'],'TDstat','CTstat');
TDstat2 = TDstat; CTstat2 = CTstat;

% use full data first
cfull = 2:10;
cls = cfull;
%% train with authentic data
[hfilt1,tacr1,sfm1,TDful,CTfull] = CNNscan(TDstat1,CTstat1,cls);
%
fnm = length(hfilt1); hwm1 = []; hclo1 = hwm1; hchi1 = hwm1; 
for hi = 1:numel(hfilt1{1}(:,:,1))
%     for fi = 1:fnm
        [hwi,hwj] = ind2sub(size(hfilt1{1}(:,:,1)),hi);
        curh = cat(3,hfilt1{1}(hwi,hwj,:),hfilt1{2}(hwi,hwj,:));
        hwm1(hwi,hwj) = nanmean(curh);
        ctmp = prctile(curh(~isnan(curh)),[5 95]);
        hclo1(hwi,hwj) = ctmp(1);
        hchi1(hwi,hwj) = ctmp(2);
%     end
end
%
[aucf1,rocf1]=sumauc(sfm1);

figure(101); clf; hold all
subplot 131; ciplot(hclo1, hchi1); title('NSM on')
plotstandard
%% train with scrambled data
[hfilt_c,tacr_c,sfmc,TDfulc,CTfullc] = CNNscan_ctrl(TDstat1,CTstat1,cls);
%
fnm = length(hfilt_c); hwmc = []; hcloc = hwmc; hchic = hwmc; 
for hi = 1:numel(hfilt_c{1}(:,:,1))
%     for fi = 1:fnm
        [hwi,hwj] = ind2sub(size(hfilt_c{1}(:,:,1)),hi);
        curh = cat(3,hfilt1{1}(hwi,hwj,:),hfilt_c{2}(hwi,hwj,:));
        hwmc(hwi,hwj) = nanmean(curh);
        ctmp = prctile(curh(~isnan(curh)),[5 95]);
        hcloc(hwi,hwj) = ctmp(1);
        hchic(hwi,hwj) = ctmp(2);
%     end
end
%
[aucfc,rocfc]=sumauc(sfmc);

figure(101); hold all
subplot 132; ciplot(hcloc, hchic); title('Ctrl')

if svon
    figure(101);
    savname = [gtype '_cnnpat_' num2str(cls(1)) '-' num2str(cls(end))];
    saveas(gcf,[savpath2 savname '.tif'])
    saveas(gcf,[savpath2 savname '.fig'])
    saveas(gcf,[savpath2 savname '.eps'],'epsc')
    
    savname = [gtype '_cnnpat_' num2str(cls(1)) '-' num2str(cls(end)) 'dat'];
    save([savpath savname '.mat'],'tacr1','hfilt1','hfilt_c','hwm1','hwmc','hclo1','hchi1','hcloc','hchic')
end
%% train with SVM
[chf,tacf,sfmf,~,~] = SVMscann(TDstat1,CTstat1,cls);
chf = permute(chf,[2 1 3]);
% summarize weights
chm = []; chml = chm; chmh = chm; 
for hi = 1:numel(chf(:,:,1))
%     for fi = 1:fnm
        [hwi,hwj] = ind2sub(size(chf(:,:,1)),hi);
        curh = chf(hwi,hwj,:);
        chm(hwi,hwj) = nanmean(curh);
        ctmp = prctile(curh(~isnan(curh)),[5 95]);
        chml(hwi,hwj) = ctmp(1);
        chmh(hwi,hwj) = ctmp(2);
%     end
end
%
[aucf,rocf]=sumaucn(sfmf);

figure(101); hold all
subplot 133; cla;ciplot(chml, chmh); title('SVMl')
set(gcf,'outerposition',[50 512 576 202])

if svon
    figure(101);
    savname = [gtype '_svmpat_' num2str(cls(1)) '-' num2str(cls(end))];
    saveas(gcf,[savpath2 savname '.tif'])
    saveas(gcf,[savpath2 savname '.fig'])
    saveas(gcf,[savpath2 savname '.eps'],'epsc')
    
    savname = [gtype '_svmpat_' num2str(cls(1)) '-' num2str(cls(end)) 'dat'];
    save([savpath savname '.mat'],'tacf','chf','chm','chml','chmh','aucf','rocf','hchic')
end

%% train with GLM
[gw,tacg,sfmg,~,~] = GLMscan(TDstat1,CTstat1,cls);
% gw = permute(gw,[2 1 3]);
% summarize weights
% ghm = []; ghml = ghm; ghmh = ghm; 
% for hi = 1:numel(chf(:,:,1))
% %     for fi = 1:fnm
%         [hwi,hwj] = ind2sub(size(chf(:,:,1)),hi);
%         curh = gw(hwi,hwj,:);
%         ghm(hwi,hwj) = nanmean(curh);
%         ctmp = prctile(curh(~isnan(curh)),[5 95]);
%         ghml(hwi,hwj) = ctmp(1);
%         ghmh(hwi,hwj) = ctmp(2);
% %     end
% end
% %
[aucg,rocg]=sumaucn(sfmg);

% figure(101); hold all
% subplot 133; cla;ciplot(ghml, ghmh); title('GLM')
mean(aucg)

if svon
    figure(101);
    savname = [gtype '_svmpat_' num2str(cls(1)) '-' num2str(cls(end))];
    saveas(gcf,[savpath2 savname '.tif'])
    saveas(gcf,[savpath2 savname '.fig'])
    saveas(gcf,[savpath2 savname '.eps'],'epsc')
    
    savname = [gtype '_glmpat_' num2str(cls(1)) '-' num2str(cls(end)) 'dat'];
    save([savpath savname '.mat'],'tacf','chf','chm','chml','chmh','aucf','rocf','hchic')
end

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