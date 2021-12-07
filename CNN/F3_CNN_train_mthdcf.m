setsavpath
svon = 0 ;
% general params
gtlist = {'wt' 'tph1' 'pdfr1' 'tph1pdfr1' 'unc31' 'tdc1' 'ttx3unc103gf' 'mod1' 'gcy28Chm'};
cgtype = 'wt';

gtype = cgtype;
load([savpath gtype '_alldata.mat'])
load([savpath gtype '_NSMon_trigdata.mat'],'TDstat','CTstat');
TDstat1 = TDstat; CTstat1 = CTstat;

% use full data first
cfull = 2:10;
cls = cfull;

ldname = [gtype '_cnn' num2str(cls(1)) '-' num2str(cls(end)) 'vsCtrl_rocauc'];
save([savpath ldname '.mat'],'aucf1','rocf1','aucfc','rocfc','aum1','auci1','aumc','aucic')

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
[aucf,rocf]=sumauc(sfmf);

figure(101); hold all
subplot 122; cla;ciplot(chml, chmh); title('SVMl')
set(gcf,'outerposition',[50 812 576 202])

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
gw = permute(gw,[2 1 3]);
% summarize weights
ghm = []; ghml = ghm; ghmh = ghm; 
for hi = 1:numel(chf(:,:,1))
%     for fi = 1:fnm
        [hwi,hwj] = ind2sub(size(chf(:,:,1)),hi);
        curh = gw(hwi,hwj,:);
        ghm(hwi,hwj) = nanmean(curh);
        ctmp = prctile(curh(~isnan(curh)),[5 95]);
        ghml(hwi,hwj) = ctmp(1);
        ghmh(hwi,hwj) = ctmp(2);
%     end
end
%
[aucf,rocf]=sumauc(sfmg);

figure(101); hold all
subplot 122; cla;ciplot(ghml, ghmh); title('SVMl')
set(gcf,'outerposition',[50 812 576 202])

if svon
    figure(101);
    savname = [gtype '_svmpat_' num2str(cls(1)) '-' num2str(cls(end))];
    saveas(gcf,[savpath2 savname '.tif'])
    saveas(gcf,[savpath2 savname '.fig'])
    saveas(gcf,[savpath2 savname '.eps'],'epsc')
    
    savname = [gtype '_svmpat_' num2str(cls(1)) '-' num2str(cls(end)) 'dat'];
    save([savpath savname '.mat'],'tacf','chf','chm','chml','chmh','aucf','rocf','hchic')
end

%% quantify and compare test accuracies between auth and scrmb
aust = struct('mn',[],'ci',[]); aup = nan(1,10);
pclr = [ones(1,3)];
cp = 1; bbol = 0;

aum1 = nanmean(aucf1);
auci1 = bootci(100,@nanmean,aucf1);

aumc = nanmean(aucfc);
aucic = bootci(100,@nanmean,aucfc);

aumv = nanmean(aucf);
auciv = bootci(100,@nanmean,aucf);

bci = [auci1 aucic auciv]; bmn = [aum1 aumc aumv]; pclr = [.1*ones(1,3);1 1 1;.35*ones(1,3)];

bbol = 1;
figure(102);clf;hold all
plot_bcibar([],bci,bmn,pclr,2,[],[],bbol)
plotstandard
set(gca,'ylim',[0 1],'xlim',[.25 3.75],'xtick',1:3,'yticklabel','')
set(gcf,'outerposition',[57 530 126 220])

if svon
    figure(102);
    savname = [gtype '_cnn' num2str(cls(1)) '-' num2str(cls(end)) '_cf'];
    saveas(gcf,[savpath2 savname '.tif'])
    saveas(gcf,[savpath2 savname '.fig'])
    saveas(gcf,[savpath2 savname '.eps'],'epsc')
    
    save([savpath savname '.mat'],'aucf1','rocf1','aucfc','rocfc','aum1','auci1','aumc','aucic')
end