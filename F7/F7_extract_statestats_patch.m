setsavpath

gtype = {'wtld','wt','aiaunc','pdfr1','tax4'};
svon = 0;
%% segment and quantify state stats
clear fct stdurs grcx
cmf = 1;

for gi = 1:length(gtype)
    curdf = [bpath gtype{gi} '_fuldata.mat'];
    load(curdf)
    %%
    stmat = xgt.stb; cxmat = xgt.chxb;
    spmat = xgt.sp2bdb; dbmat = xgt.d2bdb;
    cxrdat = []; cxre = [];
    
    % state duration hist & stats
    ddurs = []; rdurs = [];
    for xi = 1:size(stmat,1)
        dvc = stmat(xi,:)==1; rvc = stmat(xi,:)==2;
        chc = cxmat(xi,:); spc = spmat(xi,:);
        dbc = dbmat(xi,:);
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
        
        % extended analysis on indiividual roaming states
        for ri = 1:length(rp)
            rid = rp(ri).PixelIdxList; raa = rp(ri).Area;
            cd = chc(rid); sd = spc(rid); dd = dbc(rid);
            cxo = cal_matmean_ds(cd,[],cmf,0);
            spo = cal_matmean_ds(sd,[],cmf,0);
            dbo = cal_matmean_ds(dd,[],cmf,0);
            cxrdat = [cxrdat;[cxo.mean(:) spo.mean(:) dbo.mean(:) raa*ones(length(cxo.mean),1)]];
            
            % rm end cx/spd stats
            ctmp = cxo.mean<.05;
            if ctmp(end)
                cp = regionprops(ctmp,'Area');
                cedr = cp(end).Area;
            else
                cp = regionprops((1-ctmp),'Area');
                cedr = cp(end).Area;
            end
            cxre = [cxre;cxo.mean(end) cedr spo.mean(end) dbo.mean(end)];
        end
    end
    %%
    stdurs(gi).rd = rdurs; stdurs(gi).dd = ddurs;
    grcx(gi).cxr = cxrdat; grcx(gi).cxre = cxre;
    
    % visualize results
    figure(38+gi);clf;hold all
    subplot 141; hist(grcx(gi).cxre(:,1))
    subplot 142; make2dhist(grcx(gi).cxre(:,1),grcx(gi).cxre(:,2),20)
    subplot 143; make2dhist(grcx(gi).cxre(:,1),grcx(gi).cxre(:,3),20)
    subplot 144; make2dhist(grcx(gi).cxre(:,1),grcx(gi).cxre(:,4),20)
end

%% run tests
fid = 49;
dx = [.65 1.35 2.25 3]; bw = .5;
pclr = {.24*[1 1 1],[.6 .6 0],.5*[0 1 0],[.4 .6 0]};

stdurtests