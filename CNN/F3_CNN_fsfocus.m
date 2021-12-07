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

%% train leaving triplet data out
cfull = 2:10;
auex3 = struct('auc',[],'roc',[]);
coi = [2 8 9]; crt = [3:7 10]; cst = nchoosek(crt,3);
csts = [coi;cst];

for cti = 1:size(csts,1)
    cex = csts(cti,:);
    cls = cfull;
    cls(ismember(cls,cex)) = [];
    
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
    auex3(cti).auc = aucf1; auex3(cti).roc = rocf1;
    
    hflt1.e3(cti).fullex = hfilt1;
    hflt1.e3(cti).fmex = hwm1;
    hflt1.e3(cti).hiex = hchi1; hflt1.c(cti).loex = hclo1;
    hflt1.e3(cti).acrex = tacr1;
end

% train with only triplet
aukp3 = struct('auc',[],'roc',[]);
cls = coi;

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
aukp3.auc = aucf1; aukp3.roc = rocf1;

hflt1.k3.fullex = hfilt1;
hflt1.k3.fmex = hwm1;
hflt1.k3.hiex = hchi1; hflt1.c(cti).loex = hclo1;
hflt1.k3.acrex = tacr1;

%% quantify and compare auc
wtname = [gtype '_cnn2-10l1o'];
load([savpath wtname '.mat'],'aucal','aust')
waust = aust; clear aust

aust = struct('mn',[],'ci',[]); aup = nan(1,10);
pclr = [ones(1,3)];
cp = 1; bbol = 0;
for cti = 1:size(csts,1)
    aucf = auex3(cti).auc;
    aust.mn(cti) = nanmean(aucf);
    aust.ci(:,cti) = bootci(100,@nanmean,aucf);
        % check if siginificantly lower than full mod
        aup(cti) = ranksum(aucf,aucal(1).auc);
        [~,aupt(cti)] = ttest(aucf,waust.mn(1));
    cp = cp+1;
end

cti = cti+1;
aucf = aukp3.auc;
aust.mn(cp) = nanmean(aucf);
aust.ci(:,cp) = bootci(100,@nanmean,aucf);
% check if siginificantly lower than full mod
aup(cti) = ranksum(aucf,aucal(1).auc);
[~,aupt(cti)] = ttest(aucf,waust.mn(1));

rnfdr = mafdr(aup,'BHFDR',true)
% ttfdr = mafdr(aupt,'BHFDR',true)
acf = waust.ci(:,1);
%%
figure(105);clf;hold all
bbol = 1; pclr = [[0 0 1];.4*ones(20,3);[1 0 0]];
bci = aust.ci; bmn = aust.mn;
patch([0 (length(bmn)+1)*ones(1,2) 0],acf([1 1 2 2]),.8*ones(1,3),'edgecolor','none')
plot_bcibar([],bci,bmn,pclr,2,'.',.4,bbol)
plotstandard
ylim([.5 .85]); xlim([.5 cti+.5])
set(gca,'yticklabel','','ytick',[.5 .75 1])
% camroll(-90)

if svon
    figure(105);
    savname = [gtype '_cnn' num2str(cls(1)) '-' num2str(cls(end)) '_ffocus'];
    saveas(gcf,[savpath2 savname '.tif'])
    saveas(gcf,[savpath2 savname '.fig'])
    saveas(gcf,[savpath2 savname '.eps'],'epsc')
    
    save([savpath savname '.mat'],'auex3','aukp3','hfilt1','aust','waust','aup','aupt','rnfdr')
end