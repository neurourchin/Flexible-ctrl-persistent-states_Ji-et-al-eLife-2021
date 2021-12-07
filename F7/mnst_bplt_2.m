%% plot pre-border crossing speed dynamics as function of time
% first gather data from all pre-xing track segments
tmw = 720; smw = 60;
sppmat = nan(size(xgt.trx,1),size(xgt.trx,2));
stpmat = sppmat;
dpmat = sppmat;
tpr = 90*60; ted = 120*60;
bw = .6;

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
    
stdat = stpmat(:,(tpr*3):(ted*3))-1;
stm = nanmean(stdat(:)); 
stci = bootlrg(stdat(:),'mean',.2,100);
