
% clear
cnmvec = {'NSM','AIY','RIB','AVB','RME','RIA','ASI','AIA','AVA','RIF'};

setsavpath
DirLog

fgtype = {'wt','tph1','mod1','pdfr1','pdfracy1','tph1pdfr1'};
svon = 0;
%% NSM vs AVB activitiy histogram
clc
fgl = length(fgtype);
clrs = getstateclr;
cmap = cmap_gen({clrs(2,:),.3*ones(1,3),clrs(1,:)},-1);
clrc= {clrs(2,:),clrs(1,:)};
ap = .1;

for fgi = 1:length(fgtype)
    gtype = fgtype{fgi};
    load([savpath gtype '_alldata.mat'])
    fids = find(Fdx>0);
    cdata = Cdat(fids,:);
    cdata(cdata==0) = nan;
    fdata = Fdx(fids);
    vdata = Vdat(fids)/20000;
    bdata = Bst2(fids);
    if fgi == 1
        xth = multithresh(cdata(:,1));
        yth = multithresh(cdata(:,4));
    end
    
    
    fh(fgi)=figure(fi1+fgi-1);clf; hold all
    subplot 121; hold all
    scatter(cdata(bdata==1,1),cdata(bdata==1,4),15,clrs(2,:),'filled',...
        'markerfacealpha',ap);caxis([0 .1]); % abs(vdata(bdata==1))
    colormap(cmap);caxis([.0065 .065])
    plot([xth xth;-1 2]',[-1 2;yth yth]','k:','linewidth',1.5)
    xlim([-.1 1.1]);ylim([-.1 1.1])
    axis square
    plotstandard
    set(gca,'xtick',0:.5:1,'ytick',0:.5:1,'yticklabel','')
    
    
    subplot 122; hold all
    scatter(cdata(bdata==2,1),cdata(bdata==2,4),15,clrs(1,:),'filled',...
        'markerfacealpha',ap);caxis([0 .1]);
    colormap(cmap);caxis([.0065 .065])
    plot([xth xth;-1 2]',[-1 2;yth yth]','k:','linewidth',1.5)
    xlim([-.1 1.1]);ylim([-.1 1.1])
    axis square
    plotstandard
    set(gca,'xtick',0:.5:1,'ytick',0:.5:1,'yticklabel','')
    
    %     fh(fgi).OuterPosition = [31+230*(fgi-1) 350 260 260];
    title(fgtype{fgi})
    
    % quantify occupancy
    o21 = sum(cdata(:,1)<xth&cdata(:,4)>yth);
    o22 = sum(cdata(:,1)>xth&cdata(:,4)>yth);
    o11 = sum(cdata(:,1)<xth&cdata(:,4)<yth);
    o12 = sum(cdata(:,1)>xth&cdata(:,4)<yth);
    omat = [o11 o12;o21 o22]; omat = (-omat/sum(omat(:)));
    ocmat{fgi} = omat;
    
    if svon
        savname = [fgtype{fgi} '_nsm_avb_sctspd'];
        saveas(fh(fgi),[savpath2 savname '.tif'])
        saveas(fh(fgi),[savpath2 savname '.fig'])
        saveas(fh(fgi),[savpath2 savname '.eps'],'epsc')
    end
    
end
