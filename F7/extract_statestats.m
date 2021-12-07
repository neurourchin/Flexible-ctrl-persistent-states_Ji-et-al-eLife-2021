setsavpath

gtype = {'wtld','wthd','aiald','aiahd'};
%% segment and quantify state stats
fctm = nan(1,length(gtype)); fctci = [fctm;fctm];
stdurs(2) = struct('rdurs',[],'ddurs',[]);

for gi = 1:length(gtype)
    curdf = [dbpath gtype{gi} '_hlddata.mat'];
    load(curdf)
    
    stmat = xgt.states;
    % fraction time in state
    for bi = 1:200
        sl = size(stmat,1);
        tid = randperm(sl,round(.5*sl));
        stbm = stmat(tid,:);
        xtt = sum(~isnan(stbmat(:)));
        xtr = sum((stbmat(:)==2));
        xtd = sum((stbmat(:)==1));
        xft(bi) = xtr/xtt;
    end
    fctm(gi) = nanmean(xft);
    fctci(:,gi) = (prctile(xft,[2.5 97.5]))';
    
    % state duration hist & stats
    ddurs = []; rdurs = [];
    for xi = 1:size(stmat,1)
        dvc = stmat(xi,:)==1; rvc = stmat(xi,:)==2;
        dp = regionprops(dvc,'area','pixelidxlist');
        da = cat(1,dp.Area);
        if ~isempty(da)
            if dp(1).PixelIdxList(1)==1
                da(1) = [];
            elseif dp(end).PixelIdxList(end)==length(dvc)
                da(end) = [];
            end
        end
        ddurs = [ddurs; da];
        
        rp = regionprops(rvc,'area','pixelidxlist');
        ra = cat(1,rp.Area);
        if ~isempty(ra)
            if rp(1).PixelIdxList(1)==1
                ra(1) = [];
            elseif rp(end).PixelIdxList(end)==length(rvc)
                ra(end) = [];
            end
        end
        rdurs = [rdurs; ra];
    end
    
    stdurs(gi).rd = rdurs; stdurs(gi).dd = ddurs;
    
    figure(65);clf;hold all
    subplot 211; hist(ddurs,30)
    subplot 212; hist(rdurs,30)
    
end