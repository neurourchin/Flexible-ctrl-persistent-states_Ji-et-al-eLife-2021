strd = 5; wl = 60; 
% calculate xcorr
xstr = [400 540 620];
wn = length(xstr);
wpr = floor((tpre-3*wl/4)/strd);

%
xcmat = cell(1,wn);
for tri = 1:tn
    for wi = 1:wn
        dwin = xstr(wi)+(0:(wl-1));
        dwin = min(dwin,tl); dwin = unique(dwin);
        tx = Tm{c1}(tri,dwin); ty = Tm{c2}(tri,dwin);
        tx = tx-prctile(tx,5);
                [xcf,lags] = crosscorr(tx,ty,cw);
                xcmat{wi} = [xcmat{wi}; xcf]
    end
end
%
clear xci xcm xse xtm xte xtg
wx = [480 580 680];
xmmt = cell(1,wn);
for wi = 1:wn
    if ~isempty(xcmat{wi})
        wout = cal_matmean(xcmat{wi},1,0);
        xcm(wi,:) = wout.mean;
        xmx = [wout.mean+wout.se;wout.mean-wout.se];
        xmo = max(abs(wout.mean),[],1);
        [~,xmi] = max(xmo);
        xse(wi,:) = wout.se;
        xtm(wi) = wout.mean(xmi);
        xte(wi) = wout.se(xmi);
        xtg(wi) = lags(xmi);
        xmmt{wi} = xcmat{wi}(:,xmi);
    else
        xcm(wi) = nan;
        xse(wi) = nan;
    end
end

rp = [];
[rp(1),~] = ranksum(xmmt{2},xmmt{1});
[rp(2),~] = ranksum(xmmt{3},xmmt{1});
%% plotting
 errorbar([480 580 680],xtm,xte,'ko-','linewidth',1)
 
 clm = [.87 .49 0; [.1 .6 .15]; [0 0 1]];

 for wi = 1:wn
     
    errorbar(wx(wi),xtm(wi),xte(wi),'o-','color',clm(wi,:),'linewidth',1.5,'markerfacecolor',clm(wi,:)) 
    plot([-400 800],[0 0],'k:','linewidth',1)
    set(gca,'xlim',[440 720],'ylim',[-.25 .75],'xtick',wx,'ytick',-1:.5:1,...
        'xticklabel','','yticklabel','','ticklength',.035*[1 1],'tickdir','out')
 if c1==9; ylim([-.6 .4]); end
 end
