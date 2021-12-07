%% plot pre-border crossing speed dynamics as function of time
% first gather data from all pre-xing track segments
tmw = 180; smw = 60;
sppmat = nan(size(xgt.trx,1),size(xgt.trx,2));
stpmat = sppmat;
dpmat = sppmat;

for ti = 1:length(xgt.xfr)
    if isempty(find(~isnan(xgt.d2a(ti,:)), 1)) % filter for pre-xing tracks
        if ~isempty(find(~isnan(xgt.trxb(ti,:)), 1)) % xed
            bfid = xgt.xfrm(ti,~isnan(xgt.xfrm(ti,:)));
            sppmat(ti,bfid) = xgt.spd(ti,bfid);
            stpmat(ti,bfid) = xgt.states(ti,bfid);
            dpmat(ti,bfid) = xgt.d2bdb(ti,(end-length(bfid)+1):end);
        else % non xing on LD side
            sppmat(ti,:) = xgt.spd(ti,:);
            stpmat(ti,:) = xgt.states(ti,:);
            dpmat(ti,:) = xgt.d2b(ti,:);
        end
    end
end
    
% sppmat(dpmat>dsth) = nan; stpmat(dpmat>dsth) = nan;

spp = cal_matmean(sppmat,1,1);
stp = cal_matmean(stpmat,1,1);

spid = find(~isnan(spp.ci(1,:)));
spcl = spp.ci(1,spid); [~,spclm] = tilingmedianpb([],spcl,tmw);
spch = spp.ci(2,spid); [~,spchm] = tilingmedianpb([],spch,tmw);
spdm = spp.mean(spid); [~,spdmm] = tilingmedianpb([],spdm,tmw);

% spclm = (smooth(spclm,smw))';spchm = (smooth(spchm,smw))'; spdmm = (smooth(spdmm,smw))';

subplot 121; hold all
plot_bci(spid,[spclm;spchm],spdmm,mlclr,plclr)
ylim([0.01 .06]); 
set(gca,'xtick',[0 3600 10800 21600 32400 43200 54000],'ytick',[.02 .04 .06],'yticklabel','')
xlim([3000 32400])
plotstandard

spid2 = find(~isnan(stp.ci(1,:)));
spcl = stp.ci(1,spid2)-1; [~,spclm2] = tilingmedianpb([],spcl,tmw);
spch = stp.ci(2,spid2)-1; [~,spchm2] = tilingmedianpb([],spch,tmw);
spdm = stp.mean(spid2)-1; [~,spdmm2] = tilingmedianpb([],spdm,tmw);

% spclm2 = (smooth(spclm2,smw))';spchm2 = (smooth(spchm2,smw))'; spdmm2 = (smooth(spdmm2,smw))';

subplot 122; hold all
plot_bci(spid2,[spclm2;spchm2],spdmm2,mlclr,plclr)
ylim([0 .5]); 
set(gca,'xtick',[0 3600 10800 21600 32400 43200 54000],'ytick',[0 .25 .5],'yticklabel','')
xlim([3000 32400])
plotstandard
% saveas(gcf,[savpath2 tf.name(1:(end-15)) 'sp_st_ctrl.tif'])

set(gcf,'outerposition',[0 665 513 280])
