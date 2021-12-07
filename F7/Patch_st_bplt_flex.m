setsavpath
gtype = {'wt','wtld','tax4','aiaunc','pdfr1','tph1'};
svon = 0;
% pclr = {.2*[1 1 1],[0 0 1],[.5 .5 0],[0.5 0 .5]};
%% combine data based on genotype and make plots
% pclr = {.24*[1 1 1],.5*[0 1 0],[1 .6 .78],[.64 .08 .18]};
% mclr = {.24*[1 1 1],.5*[0 1 0],[1 .6 .78],[.64 .08 .18]};
pclr = {.14*[1 1 1],.7*ones(1,3),[.64 .08 .18],.5*[0 1 0],[0 0 1],[.85 .5 0]};
mclr = pclr; plset = [];

mw = 20; dsth = 500; gl = length(gtype);
chrm = nan(1,length(gtype)); chrel = chrm; chreh = chrm;
ddm = []; ddc = []; ddful = cell(1,2);
gstm = nan(1,length(gtype)); gstci = [gstm;gstm];

fi1 = 46;fi2 = fi1+1;fic = 41; fip = 42; fit = 43;

%
for gi = 1:length(gtype)
    
    chdat = []; xgt = [];
    plclr = pclr{gi};
    %     mlclr = mclr{gi};
    plset = [plset;plclr];
    
    load([bpath gtype{gi} '_fuldata.mat'])
    
    % speed on LD (before xing) over time
    
    mnst_bplt_2
    
    gstm(gi) = stm; gstci(:,gi) = stci;
    
    
end

%%
bw = .35; goi = [1 3]; msz = 7;
figure(fi2); clf; hold all
plot_bcibar([],gstci(:,goi),gstm(goi),plset(goi,:),msz,[],bw,1)
plotstandard
set(gca,'xlim',[.25 2+.75],'ylim',[0 .7],'ytick',[0 .3 .6],'yticklabel','')
% set(gcf,'outerposition',[100 761-max(0,gi-2)*200 313 220])

goi = [1 4 5]; bw = .45;
figure(fi2+1); clf; hold all
plot_bcibar([],gstci(:,goi),gstm(goi),plset(goi,:),msz,[],bw,1)
plotstandard
set(gca,'xlim',[.25 3+.75],'ylim',[0 .7],'ytick',[0 .3 .6],'yticklabel','')
% set(gcf,'outerposition',[100 761-max(0,gi-2)*200 313 220])
