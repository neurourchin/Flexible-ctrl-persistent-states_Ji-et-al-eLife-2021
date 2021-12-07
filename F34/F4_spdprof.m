
% clear
cnmvec = {'NSM','AIY','RIB','AVB','RME','RIA','ASI','AIA','AVA','RIF'};

setsavpath
DirLog

fgtype = {'wt','tph1n','mod1','pdfr1','pdfracy1','tph1pdfr1'};
svon = 0;
%% 
clc
btn = 100; fiid = 74;
fgl = length(fgtype); ocmat = cell(1,fgl);
clrs = getstateclr;
cx = -.01:.005:.115;
hrn = [.02 .04];

figure(fiid);clf;hold all
for fgi = 1:length(fgtype)%[1 4 5 6]
    gtype = fgtype{fgi};
    load([savpath gtype '_alldata.mat'])
    fids = find(Fdx>0);
    cdata = Cdat(fids,:);
    cdata(cdata==0) = nan;
    fdata = Fdx(fids);
    vdata = Vdat(fids)/20000;
    bdata = Bst2(fids);
    if fgi==1; bdata = 2-bdata; end
    cln = size(cdata,1);
    
    pid = vdata>=-.5;
    ndt = cdata(pid,1); pdt = abs(vdata(pid)); bdt = bdata(pid);
    if fgi==1
        subplot(fgl+1,1,1); cla
        pd1 = pdt(bdt==1);
        [kg1,kgx1,hgx1,hgy1] = kfhist(pd1(pd1>=cx(1)),cx,[],clrs(1,:));
        pd2 = pdt(bdt==2);
        [kg2,kgx2,hgx2,hgy2] = kfhist(pd2(pd2>=cx(1)),cx,[],clrs(2,:));
        cla;hold all
        bar(hgx1,hgy1,'facecolor',clrs(2,:),...
            'edgecolor','none');alpha(.5);
        bar(hgx2,hgy2,'facecolor',clrs(1,:),...
            'edgecolor','none');alpha(.5);
        plot(kgx1,kg1,'color',clrs(2,:),'linewidth',1.5);
        plot(kgx2,kg2,'color',clrs(1,:),'linewidth',1.5);
        
        mp1 = median(pd1);mp2 = median(pd2);
        plot(ones(2,1)*mp1,[0 .2],':','color',clrs(2,:),'linewidth',1.5)
        plot(ones(2,1)*mp2,[0 .2],':','color',clrs(1,:),'linewidth',1.5)
        patch([hrn hrn([2 1])],[0 0 .5 .5],.5*ones(1,3),'edgecolor','none');alpha(.3)
        xlim(cx([1 end-1]))
        plotstandard; box off
        set(gca,'xtick',0:.025:.1,'ylim',[0 .23],'yticklabel','')
    end
    
    subplot(fgl+1,1,fgi+1);cla;hold all
    [kg,kgx] = kfhist(pdt(pdt>=cx(1)),cx,[],[0 .3 0]); alpha(.5)
    plot(ones(2,1)*mp1,[0 .2],':','color',clrs(2,:),'linewidth',1.5)
    plot(ones(2,1)*mp2,[0 .2],':','color',clrs(1,:),'linewidth',1.5)
            patch([hrn hrn([2 1])],[0 0 .3 .3],.5*ones(1,3),'edgecolor','none');alpha(.3)
    xlim(cx([1 end-1]))
    plotstandard;
    set(gca,'xtick',-.1:.025:.1,'ylim',[0 .2],'yticklabel','')
end
