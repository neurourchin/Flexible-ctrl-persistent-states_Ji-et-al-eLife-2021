[hfilt1,tacr1,sfm1,TDful,CTfull] = CNNscan2(TDstat1,CTstat1,cls);
%%
hfilt = cat(3,hfilt1{1},hfilt1{2});
clust_net
%
% fiid = 309;
% figure(fiid); clf; hold all
fnm = max(crk); hct = struct('cm',[],'clo',[],'chi',[],'zp',[]);
lpi = 1;
for cli = crk
    hcl = hset(clix == cli,:);
    hctmp = nanmean(hcl,1);
    for hi = 1:size(hcl,2)
        curh = hcl(:,hi);
        ctmp = prctile(curh(~isnan(curh)),[5 95]);
        [hwi,hwj] = ind2sub(size(hfilt(:,:,1)),hi);
        hct(lpi).clo(hwi,hwj) = ctmp(1);
        hct(lpi).chi(hwi,hwj) = ctmp(2);
        [~,hct(lpi).zp(hwi,hwj)] = ttest(curh(~isnan(curh)));
    end
    hct(lpi).cm = reshape(hctmp,size(hfilt,1),size(hfilt,2));
    
    % plot the sigificant weights
    figure(fiid+lpi-1); clf;
    setfigsiz([8+(ti-1)*200 330-(lpi-1)*270 303 520])
    hbnd = ciplot(hct(lpi).clo, hct(lpi).chi);
    hct(lpi).hbnd = hbnd;
%     imagesc(hbnd')
    brmap = cmap_gen({[0.3 0.3 1],[1 0.3 0.3]},0);
    colormap(brmap);caxis([-1 1])
    ytl = 1;
    plotstandard
    box on
    drawnow

    lpi = lpi+1;
end

%%
[aucf1,rocf1]=sumauc(sfm1);
% logL = log(1-nanmean(tacr1(tacr1>.56)));
% npm = size(hcl,2); nob = size(TDful,1)*2;
% [aic,bic,ic] = aicbic(logL,npm,nob,'Normalize',true);
% [~,bic2] = aicbic(logL,nnz(hbnd),nob,'Normalize',true);
% [nanmean(aic) nanmean(bic) nanmean(bic2) nanmean(ic.aicc)]
mse1 = 1-nanmean(tacr1(tacr1>.5));
nk = size(hcl,2)+7; nob = size(TDful,1)*2;
aic = nob*log(mse1) + 2*nk;
bic = nob*log(mse1) + nk*log(nob);