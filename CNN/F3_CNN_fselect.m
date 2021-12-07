setsavpath
svon = 0 ;
% general params
gtlist = {'wt' 'tph1' 'pdfr1' 'tph1pdfr1' 'unc31' 'tdc1' 'ttx3unc103gf' 'mod1' 'gcy28Chm'};
cgtype = 'wt';

gtype = cgtype;
load([savpath gtype '_alldata.mat'])
load([savpath gtype '_NSMon_trigdata_9.mat'],'TDstat','CTstat');
TDstat1 = TDstat; CTstat1 = CTstat;
load([savpath gtype '_NSMoff_trigdata_9.mat'],'TDstat','CTstat');
TDstat2 = TDstat; CTstat2 = CTstat;

% use full data first
cfull = 2:10;
%% train with leave-1-out data
aucal = struct('auc',[],'roc',[]);

for cti = cfull
    cls = cfull;
    cls(cls==cti) = [];
    
    [hfilt1,tacr1,sfm1,TDful,CTfull] = CNNscan(TDstat1,CTstat1,cls);
    %
    fnm = length(hfilt1); hwm1 = []; hclo1 = hwm1; hchi1 = hwm1;
    for hi = 1:numel(hfilt1{1}(:,:,1))
        [hwi,hwj] = ind2sub(size(hfilt1{1}(:,:,1)),hi);
        curh = cat(3,hfilt1{1}(hwi,hwj,:),hfilt1{2}(hwi,hwj,:));
        hwm1(hwi,hwj) = nanmean(curh);
        ctmp = prctile(curh(~isnan(curh)),[5 95]);
        hclo1(hwi,hwj) = ctmp(1);
        hchi1(hwi,hwj) = ctmp(2);
    end

    [aucf1,rocf1]=sumauc(sfm1);
    aucal(cti).auc = aucf1; aucal(cti).roc = rocf1;
    
    figure(101); clf; hold all
    subplot 121; ciplot(hclo1, hchi1); title('NSM on')
    plotstandard
    set(gcf,'outerposition',[50 812 576 202])
    
    saveas(gcf,[savpath2 gtype '_cnnpattern_ex' num2str(cti) '.tif'])
    
    hflt1.c(cti).fullex = hfilt1;
    hflt1.c(cti).fmex = hwm1;
    hflt1.c(cti).hiex = hchi1; hflt1.c(cti).loex = hclo1;
    hflt1.c(cti).acrex = tacr1;
end
%% quantify and compare auc
aust = struct('mn',[],'ci',[]); aup = nan(1,10);
pclr = [ones(1,3)];
cp = 1; bbol = 0;
for cti = 1:10
    aucf = aucal(cti).auc;
    aust.mn(cti) = nanmean(aucf);
    aust.ci(:,cti) = bootci(100,@nanmean,aucf);
    if cti>1
        % check if siginificantly lower than full mod
        aup(cti) = ranksum(aucf,aucal(1).auc); %,'tail','left'
        [~,aupt(cti)] = ttest(aucf,aust.mn(1));
    end
    cp = cp+1;
end

rnfdr = mafdr(aup,'BHFDR',true)
% ttfdr = mafdr(aupt,'BHFDR',true)
acf = aust.ci(:,1);
%%
figure(105);clf;hold all

patch([0 10 10 0],[acf([1 1 2 2])],.8*ones(1,3),'edgecolor','none')
bbol = 1; pclr = .4*ones(1,3);
bci = aust.ci(:,2:end); bmn = aust.mn(2:end);
plot_bcibar([],bci,bmn,pclr,2,'.',.4,bbol)
plotstandard
ylim([.5 .85]); xlim([.5 cti-.5])
set(gca,'yticklabel','','ytick',[.5 .75 1])
camroll(-90)

if svon
    figure(105);
    savname = [gtype '_cnn' num2str(cls(1)) '-' num2str(cls(end)) 'l1o'];
    saveas(gcf,[savpath2 savname '.tif'])
    saveas(gcf,[savpath2 savname '.fig'])
    saveas(gcf,[savpath2 savname '.eps'],'epsc')
    
    save([savpath savname '.mat'],'aucal','hfilt1','aust','aup','aupt','rnfdr')
end