setsavpath

gtype = {'wtld','aiald','wthd','aiahd'};
svon = 0;
%% segment and quantify state stats
clear fct stdurs

for gi = 1:length(gtype)
    curdf = [bpath gtype{gi} '_hlddata.mat'];
    load(curdf)
    
    stmat = xgt.states;
    % fraction time in state
    for bi = 1:200
        sl = size(stmat,1);
        tid = randperm(sl,round(.5*sl));
        stbm = stmat(tid,:);
        xtt = sum(~isnan(stbm(:)));
        xtr = sum((stbm(:)==2));
        xtd = sum((stbm(:)==1));
        xft(bi) = xtr/xtt;
    end
    fct.dat{gi} = xft;
    fct.mean(gi) = nanmean(xft);
    fct.ci(:,gi) = (prctile(xft,[2.5 97.5]))';
    
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

end

%% run tests
fid = 49;
dx = [.65 1.35 2.65 3.35]; bw = .45;
pclr = {0*[1 1 1],[0 .5 0],0*[1 1 1],[0 .5 0]}; 


dset = fct.dat;
[pmat1,~] = pwrksm(dset);
pv.fct = pmat1;
figure(fid);clf;hold all
[bm,bci] = make_barplt(dx,dset,pclr,fid,bw,2);
% title('Fraction time roaming')
set(gca,'ylim',[0 .5],'ytick',0:.25:.5,'yticklabel','')
set(gcf,'outerposition',[105 641 140 235])

%%
dset = {stdurs(1).dd stdurs(2).dd stdurs(3).dd stdurs(4).dd};
[pmat2,~] = pwrksm(dset);
pv.ddur = pmat2;
figure(fid+1);clf;hold all
[bm,bci] = make_barplt(dx,dset,pclr,fid+1,bw,2);
% title('Dwelling state duration')
set(gca,'ylim',[0 2700],'ytick',0:900:2700,'yticklabel','')
set(gcf,'outerposition',[105 401 140 235])

dset = {stdurs(1).rd stdurs(2).rd stdurs(3).rd stdurs(4).rd};
[pmat3,~] = pwrksm(dset);
pv.rdur = pmat3
figure(fid+2);clf;hold all
[bm,bci] = make_barplt(dx,dset,pclr,fid+2,bw,2);
% title('Roaming state duration')
set(gca,'ylim',[0 800],'ytick',0:360:800,'yticklabel','')
set(gcf,'outerposition',[105 141 140 235])

pcp = [pmat1;pmat2;pmat3];
pfdr = mafdr(pcp(:),'BHFDR',true);
pfdm = reshape(pfdr,[3*length(pmat1) length(pmat1)])
