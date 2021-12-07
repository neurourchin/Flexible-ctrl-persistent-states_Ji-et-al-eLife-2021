% clear
DirLog
cnmvec = {'NSM','AIY','RIB','AVB','RME','RIA','ASI','AIA','AVA','RIF'};

setsavpath
svon = 0;
%%
vwa = [-107.6 17.9]; 
gtype = 'wt';
load([savpath gtype '_alldata.mat'])
load([savpath gtype '_NSM_triggstat.mat'])
fids = find(Fdx>0);
cdata = Cdat(fids,:);
fidata = Fdx(fids);
vdata = Vdat(fids);
nlab = nsm_clust(fids);
vlab = vax_clust(fids);

cls = 1:10; 
cdat = cdata(:,cls);
dt = 60;
%% crosscorrelation with axial velocity and speed
cn = size(cdat,2);
xcfv = cell(1,cn); xcfp = cell(1,cn);

for fi=(unique(fidata))'
    dli = find(fidata==fi);
    
    for ci = 1:cn
        curx = cdat(dli,ci);
        cury = vdata(dli);
        inds = ~isnan(curx)&~isnan(cury);
        [xcf,lags] = crosscorr(curx(inds),cury(inds),120);
        xcfv{ci} = [xcfv{ci} xcf];
        
        cury = abs(vdata(dli));
        inds = ~isnan(curx)&~isnan(cury);
        [xcf,lags] = crosscorr(curx(inds),cury(inds),120);
        xcfp{ci} = [xcfp{ci} xcf];
    end
end

% compute mean and ci
XP = struct('cm1',[],'cci1',[],'cm2',[],'cci2',[]);
for ci = 1:cn
    % prob xcorr with vax
    cd1 = xcfv{ci};
    cm1 = nanmean(cd1,2);
    cci1 = nan(2,size(cd1,1));
    for pri = 1:size(cd1,1)
        cci1(:,pri) = bootci(100,@nanmean,cd1(pri,:));
    end

    
    % probe xcorr with axial sd
    cd1 = xcfp{ci};
    cm2 = nanmean(cd1,2);
    cci2 = nan(2,size(cd1,1));
    for pri = 1:size(cd1,1)
        cci2(:,pri) = bootci(100,@nanmean,cd1(pri,:));
    end

    XP(ci).cm1 = cm1; XP(ci).cci1 = cci1;
        XP(ci).cm2 = cm2; XP(ci).cci2 = cci2;

end
%% compute p values
psrt = nan(2,cn); 
for ci = 1:cn
    cdt = xcfv{ci}; cdm = XP(ci).cm1;
    [~,mi] = max(abs(cdm));
    psrt(1,ci) = signrank(cdt(mi,:));
    
     cdt = xcfp{ci}; cdm = XP(ci).cm2;
    [~,mi] = max(abs(cdm));
    psrt(2,ci) = signrank(cdt(mi,:));    
end

pfdr = mafdr([psrt(1,:) psrt(2,:)],'bhfdr',true)
%% plot xcorr for just the first 4 pcs, display mutual info for other PCs
figure(22); clf; hold all
set(gcf,'outerposition',[10 100 250 920])
% clst = get(gca,'colororder');
clrs = getstateclr;
clst = [0 .5 0;.8 .45 0];
xrn = lags([61 end-60]);

for ci = 1:cn
    subplot(cn,2,2*(ci-1)+1); cla;hold all
    plot(lags,zeros(size(lags)),'k:','linewidth',1.5)
    plot([0 0],[-1 1],'k:','linewidth',1.5)
    plot_bci(lags,XP(ci).cci1,XP(ci).cm1,clst(1,:),[],[])
    xlim(xrn); ylim(.6*[-1 1]); 
    plotstandard
    set(gca,'xtick',[-120 -60 0 60 120],'ytick',-1:.5:1,...
        'xticklabel','','yticklabel','','ticklength',.035*[1 1])
    
    subplot(cn,2,2*ci); cla;hold all
    plot(lags,zeros(size(lags)),'k:','linewidth',1.5)
    plot([0 0],[-1 1],'k:','linewidth',1.5)
    plot_bci(lags,XP(ci).cci2,XP(ci).cm2,clst(2,:),[],[])
    xlim(xrn); ylim(.6*[-1 1]); 
    plotstandard
    set(gca,'xtick',[-120 -60 0 60 120],'ytick',-1:.5:1,...
        'xticklabel','','yticklabel','','ticklength',.035*[1 1])
end
%%
if svon
    savname = [savpath2 gtype '_nnvpxcr'];
    saveas(gcf,[savname '.tif'])
    saveas(gcf,[savname '.fig'])
    saveas(gcf,[savname '.eps'],'epsc')
    
    save([savpath gtype '_nnvpxcr_psrt.mat'],'psrt','xcfv','xcfp','XP')
end