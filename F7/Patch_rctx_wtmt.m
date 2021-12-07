setsavpath

set_gdirs

gtype = {'wt','tax4','aiaunc','pdfr1','tph1'};
svon = 0;
%% combine data based on genotype and make plots
pclr = {.14*[1 1 1],[.64 .08 .18],.5*[0 1 0],[0 0 1],[.85 .5 0]};

mw = 20; dth = 650; fst = 20; ds = 20; dx = 50;
chrm = nan(1,length(gtype)); chre = chrm; chrci = [chrm;chrm];
ops = statset('UseParallel',true); plset = [];

fi1 = 45;fi2 = fi1+1;
for gi = 5%:length(gtype)
    go = load([bpath gtype{gi} '_fuldata.mat']);
    xgt = go.xgt;
    plset = [plset;pclr{gi}];
    
    toi = 1;
    state_trigg_gen_spl
    chdat2 = [cxmat1(stmat1==2&dsmat1<dth) cxmat2(stmat2==2&dsmat2<dth)]; % ctx during roaming
    
    % compute and compare overall chemotaxis bias across genotypes
    chrm(gi) = nanmean(chdat2);
    cl2 = length(chdat2);
    chre(gi) = nanstd(chdat2)/sqrt(length(chdat2));
    chrci(:,gi) = bootlrg(chdat2,'mean',.1,100);
end

bw = .35;
figure(fi2); clf; hold all
plot_bcibar([],chrci,chrm,plset,[],[],bw,1)
plotstandard
set(gca,'xlim',[.25 gl+.75],'ylim',[0 .12],'ytick',[0 .05 .1],'yticklabel','')
set(gcf,'outerposition',[100 761 313 220])

