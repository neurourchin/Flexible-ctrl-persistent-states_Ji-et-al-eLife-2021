setsavpath

gtype = {'wt','wtld','aiaunc','pdfr1','tph1'};
svon = 0;
%% plot wt against ld ctrl
pclr = {.14*[1 1 1],.4*ones(1,3),.5*[0 1 0],[0 0 1],[.85 .5 0]};
mclr = pclr; gl = length(gtype);
mw = 20; dth = 500; fst = 20; ds = 20; dx = 50;
drpp = nan(1,length(gtype)); dcp = drpp;
chrt = cell(1,gl); chrtm = drpp;
chxal = cell(1,length(gtype)); plset = [];
tpts = [60 105];
crn1 = (1:30)+tpts(1)*3; crn2 = (1:30)+tpts(2)*3;

fid = 38; fp = 1;

for gi = 5%:(length(gtype))
    plclr = pclr{gi};
    mlclr = plclr;
    chdat = []; spdat = [];
    if gi==4; dth = 750; else dth = 500; end
    
    load([bpath gtype{gi} '_fuldata.mat'])
    toi = 1;
    state_trigg_gen
    
    plset = [plset;plclr];
    if gi == 1; plclr = .35*ones(1,3); end
    % ctx drop qunatification
    chxful = [chxmat(1).ch;chxmat(2).ch];
    chxal{gi} = chxful;
    %     chxful = matsmooth(chxm,2,15,-1);
    chd = {chxful(:,crn1),chxful(:,crn2)};
    chrt{gi} = nanmean(chd{2},2)-nanmean(chd{1},2);
    %     chrtci(:,gi) = bootci(100,@nanmean,chrt{gi});
    cm = nanmean(chrt{gi});
    cse = nanstd(chrt{gi});
    chrtm(gi) = nanmean(chrt{gi});
    chrtci(:,gi) = [cm-cse;cm+cse];
    
    if gi>1
        drpp(gi) = ranksum(chrt{1},chrt{gi},'tail','left')
    end
        dcp(gi) = ranksum(chd{1}(:),chd{2}(:),'tail','right')
%     end

    if gi==1
        wchxmat = chxmat;
    end
end
bw = .35;
figure(fid); clf; hold all
plot_bcibar([],chrtci,chrtm,plset,[],[],bw,1)
plotstandard
set(gca,'xlim',[.25 gl+.75],'ytick',[0 .05 .1],'yticklabel','') % 'ylim',[0 .12],
set(gcf,'outerposition',[100 761 281 220])

fdrpp = mafdr(drpp(2:end),'BHFDR',true)
fdcp = mafdr(dcp,'BHFDR',true)
