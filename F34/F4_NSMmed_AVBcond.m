cnmvec = {'NSM','AIY','RIB','AVB','RME','RIA','ASI','AIA','AVA','RIF'};

setsavpath
DirLog

fgtype = {'wt','tph1','mod1','pdfr1','pdfracy1','tph1pdfr1'};
svo1 = 0;
%% hist comp
fclr = [.6 .2 .5];
cd1 = cell(1,6); cd2 = cd1; 
cpt = nan(4,length(fgtype));
cci1 = cpt'; cci2 = cci1;
cst = [4 1]; cpi = 1;
figure(104);clf; hold all
setfigsiz([20 336 335 482])
figure(105);clf; hold all
setfigsiz([220 336 335 482])


for coi = [1 4]
    cdr = [];
    if coi~=1
        gcoi = [1 2 3 4 6];
        clrm = [[0 0 1];[0 0 .7];[0 0 .5];[0 0 .3];[0 0 .1]];
    else
        gcoi = 1:6;
        clrm = [[0 0 1];[0 0 .7];[0 0 .5];[0 0 .3];[0 0 .1]];
    end
    %
    pgi = 1;
    gi = 1;
    gtype = fgtype{gi};
    load([savpath gtype '_alldata.mat']) % _nostrnrm
    cd1 = Cdat(:,coi); cd2 = Cdat(:,cst(cpi));
    dci = cd1==0|cd2==0; cd1(dci) = []; cd2(dci) = [];
    cdr{1,gi} = cd1(cd2<.3);
    cdr{2,gi} = cd1(cd2>=.3&cd2<.6);
    cdr{3,gi} = cd1(cd2>=.6&cd2<.9);
    cdr{4,gi} = cd1(cd2>=.9);
    
    cstz = []; chp = [];
    for ci = 1:size(cdr,1)
        cstz(ci,:) = prctile(cdr{ci,gi},[15 30 75 80 95]);
        chp(ci) = sum(cdr{ci,gi}>.6)/length(cdr{ci,gi});
    end
    
    figure(104)
    subplot(2,1,cpi); hold all
    % plot(cstz)
    plot([1 1]*3,[0 .5],'k:','linewidth',1)
    plot(chp,'o-','linewidth',1.5)
    set(gca,'ytick',0:.1:.3,'ylim',[0.075 .3]); box off
    ytl=1; plotstandard;
    
    figure(105)
    subplot(2,1,cpi); hold all
    [h,L,MX,MED]=violin_fr(cdr(:,1)','facecolor',clrm,...
        'edgecolor','k','facealpha',.3,...%'x',[1.5 2.3 3.5 4.3],...
        'plotdata',0,'medc','k');
    plot(get(gca,'xlim'),[0 0],'k:','linewidth',1)
    ytl = 1; set(gca,'xtick',1:6);
    plotstandard; box off
    ylim([-.2 2.5])
    
    if svo1
        svname = ['nmab_condhi_viol_' cnmvec{coi}];
        savfig(savpath2,svname)
    end
    cpi = cpi+1;
end


%%
cd1 = cell(1,6); cd2 = cd1;
fidd = 130;
figure(fidd);clf; hold all
coi = 1;
clear bn; cn{1} = -.1:.05:2.1; cn{2} = -.1:.05:2.1;
if fidd<=130
    xlm = [0 2];
    cn{1} = -.1:.075:2.1; cn{2} = -.1:.075:2.1;
else
    xlm = [0 1.5];
    cn{1} = -.1:.05:2.1; cn{2} = -.1:.05:2.1;
end
ylm = xlm;
% bn = 20;
%
for gi = 1:length(fgtype)
    gtype = fgtype{gi};
    load([savpath gtype '_alldata_nostrnrm.mat']) % _nostrnrm
    
    nc1 = Cdat((Vdat)>=500&(Vdat)<1000,1);
    nc2 = Cdat(abs(Vdat)>=0&abs(Vdat)<250,1);
    bc1 = Cdat((Vdat)>=500&(Vdat)<1000,4);
    bc2 = Cdat(abs(Vdat)>=0&abs(Vdat)<250,4);
    
    subplot(6,2,(gi-1)*2+1);cla;
    hp = make2dhistp(bc1,nc1,cn);
    plotstandard
    set(gca,'xlim',xlm,'ylim',ylm)
    % caxis([0 0.03])
    subplot(6,2,(gi)*2); cla;
    hp2 = make2dhistp(bc2,nc2,cn);
    plotstandard
    set(gca,'xlim',xlm,'ylim',ylm)
    % caxis([0 .0125])
    colormap jet
end

