%% load data at different time resolutions
dtst = [2 10 20 40 60]/2; dtn = length(dtst);
for dti = 1:dtn
    dt = dtst(dti);
    load([savpath gtype '_statetrans_3nn_' num2str(dt) 's.mat'],'T_on','tpre','tpost','TP')
    pred{dti} = TP.prepc; posd{dti} = TP.pospc; prec{dti} = TP.preca; posc{dti} = TP.posca;
    prmst{dti}= TP.prem; pomst{dti} = TP.posm; prcst{dti} = TP.nsmpre; pocst{dti} = TP.nsmpos;
end

cnm = length(T_on); trn = size(T_on(1).vals,1);
prg = prn(1):pon(end);

%%
foi = 30;
dti = 1; % use 1s res
coi = [3 8 9 1];

% generate full data scatter
nnxc = cell(1,6);
for fi = unique(Fdx')
    fids = find(Fdx==fi&Vdat>.02);
    cdat = Cdat(fids,coi);
    fidat = Fdx(fids);
    vdat = Vdat(fids);
    nlb = nsm_clust(fids);
    vlb = vax_clust(fids);
    
    ctm = cell(1,length(coi));
    for ci = 1:length(coi)
        [~,ctmp] = tilingmean(1:length(vdat),cdat(:,ci),dtst(2)*2);
        ctm{ci} = ctmp;
    end
    
    ppx = ctm{1}; ppy = ctm{2}; ppz = ctm{3}; ppc = ctm{4};
    
    pid = find(~isnan(ppx)&~isnan(ppy));
    [xcf,lags] = crosscorr(ppx(pid),ppy(pid),30);
    nnxc{1} = [nnxc{1};xcf];
    
    pid = find(~isnan(ppx)&~isnan(ppz));
    [xcf,lags] = crosscorr(ppx(pid),ppz(pid),30);
    nnxc{2} = [nnxc{2};xcf];
    
    pid = find(~isnan(ppy)&~isnan(ppz));
    [xcf,lags] = crosscorr(ppy(pid),ppz(pid),30);
    nnxc{3} = [nnxc{3};xcf];
    
    pid = find(~isnan(ppx)&~isnan(ppc));
    [xcf,lags] = crosscorr(ppx(pid),ppc(pid),30);
    nnxc{4} = [nnxc{4};xcf];
    
    pid = find(~isnan(ppx)&~isnan(ppc));
    [xcf,lags] = crosscorr(ppy(pid),ppc(pid),30);
    nnxc{5} = [nnxc{5};xcf];
    
    pid = find(~isnan(ppx)&~isnan(ppc));
    [xcf,lags] = crosscorr(ppz(pid),ppc(pid),30);
    nnxc{6} = [nnxc{6};xcf];

end

figure(foi+1);clf; hold all
for ni = 1:6
    nxp(ni) = cal_matmean(nnxc{ni},1);
    subplot(2,3,ni); hold all
    plot_bci([],nxp(ni).ci,nxp(ni).mean,.5*[1 1 1],[])
    title(num2str(ni))
    set(gca,'xtick',0:15:60,'xticklabel',{'-30' '' '0' '' '30'})
end
clear nxp
% figure(foi);clf;hold all
%  scatter3(ctm{1},ctm{2},ctm{3},18,.5*ones(1,3),'filled')
%%
trn1 = 200:300; trn2 = 1:100;
nnxc = cell(1,6);
for tri = 1:tn
    
    ppx = [pred{dti}(tri,trn1,coi(1)) posd{dti}(tri,trn2,coi(1))];
    ppy = [pred{dti}(tri,trn1,coi(2)) posd{dti}(tri,trn2,coi(2))];
    ppz = [pred{dti}(tri,trn1,coi(3)) posd{dti}(tri,trn2,coi(3))];
    ppc = [prec{dti}(tri,trn1) posc{dti}(tri,trn2)];
    %     ppt = (trng)/10;
    
    pid = find(~isnan(ppx)&~isnan(ppy));
    [xcf,lags] = crosscorr(ppx(pid),ppy(pid),30);
    nnxc{1} = [nnxc{1};xcf];
    
    pid = find(~isnan(ppx)&~isnan(ppz));
    [xcf,lags] = crosscorr(ppx(pid),ppz(pid),30);
    nnxc{2} = [nnxc{2};xcf];
    
    pid = find(~isnan(ppy)&~isnan(ppz));
    [xcf,lags] = crosscorr(ppy(pid),ppz(pid),30);
    nnxc{3} = [nnxc{3};xcf];
    
    pid = find(~isnan(ppx)&~isnan(ppc));
    [xcf,lags] = crosscorr(ppx(pid),ppc(pid),30);
    nnxc{4} = [nnxc{4};xcf];
    
    pid = find(~isnan(ppx)&~isnan(ppc));
    [xcf,lags] = crosscorr(ppy(pid),ppc(pid),30);
    nnxc{5} = [nnxc{5};xcf];
    
    pid = find(~isnan(ppx)&~isnan(ppc));
    [xcf,lags] = crosscorr(ppz(pid),ppc(pid),30);
    nnxc{6} = [nnxc{6};xcf];
end

%
figure(foi+1);hold all
for ni = 1:6
    nxp(ni) = cal_matmean(nnxc{ni},1);
    subplot(2,3,ni); hold all
    plot_bci([],nxp(ni).ci,nxp(ni).mean,[0 0 1],[])
    title(num2str(ni))
    set(gca,'xtick',0:15:60,'xticklabel',{'-30' '' '0' '' '30'})
    
    plot([30 30],get(gca,'ylim'),'k:')
    plot(get(gca,'xlim'),[0 0],'k:')
end

