cnmvec = {'NSM','AIY','RIB','AVB','RME','RIA','ASI','AIA','AVA','RIF'};
setsavpath
gset = {'mod1NC'};
corder = [1 4 2 3 5 6 7 8 9 10 11];
clst = {.7*ones(1,3),[.8 0.3 .3],[0 .65 0],[0.2 .2 1],[0.2 .2 0.8]};
mf = 5;

figure(230);clf;hold all
gtype = [gset{1} 'ctrl'];
if ~isempty(dir([savpath gtype '_optotrigdat.mat']))
    load([savpath gtype '_optotrigdat.mat'])
    pnm = length(corder); pln = length(pt(1).nmean);
    obd = [121 182];
    for cpi = 1:length(corder)
        %
        pi = cpi; cid = corder(cpi);
        subplot(ceil(pnm/2),2,cpi); cla;hold all %
        patch(obd([1 2 2 1])/dw,[-.1 -.1 1 1]*2,'r','edgecolor','none','facealpha',.15)
        if cid<=length(pt)
            plot(smooth(pt(cid).nmean,mf),'color',clst{1},'linewidth',1.5)
            px = [1:pln,pln:-1:1];
            ptc = [smooth(pt(cid).nci(1,:),mf) smooth(pt(cid).nci(2,:),mf)]';
            py = [ptc(1,:) ptc(2,end:-1:1)];
            patch(px,py,clst{1},'edgecolor','none','facealpha',.65)
            set(gca,'xtick',(0:60:600)/dw,'xticklabel','','yticklabel','',...
                'tickdir','out','ticklength',.025*[1 1])
        end
        if cid~=11
            ylim([-.2 1.2])
            title(cnmvec(cid))
        else
            title('Speed')
            ylim([0 .065])
        end
    end
end


gtype = 'NChm';
load([savpath gtype '_optotrigdat.mat'])

for cpi = 1:length(corder)
    pi = cpi; cid = corder(cpi);
    if cid~=11; cli = 2; else cli = 3;end
    subplot(ceil(pnm/2),2,cpi); hold all %
    %         patch(obd([1 2 2 1])/dw,[-.1 -.1 1 1]*2,'r','edgecolor','none','facealpha',.15)
    plot(smooth(pt(cid).nmean,mf),'color',clst{cli},'linewidth',1.5)
    px = [1:pln,pln:-1:1];
    ptc = [smooth(pt(cid).nci(1,:),mf) smooth(pt(cid).nci(2,:),mf)]';
    py = [ptc(1,:) ptc(2,end:-1:1)];
    patch(px,py,clst{cli},'edgecolor','none','facealpha',.65)
    set(gca,'xtick',(0:60:600)/dw,'xticklabel','','yticklabel','',...
        'tickdir','out','ticklength',.025*[1 1]) %,'xtick',[45 61 91 106]
    %     set(gca,'xtick',(0:120:600)/dw,'xticklabel','','yticklabel','',...
    %         'tickdir','out','xlim',[0 prng(end)-prng(1)]/dw,'ylim',ylm,'ticklength',.025*[1 1])
    xlim([45 106])
    if cid~=11
        ylim([0 1.1])
        title(cnmvec(cid))
    else
        title('Speed')
        ylim([0 .08])
        set(gca,'ytick',0:.04:.1)
    end
end
%
gb=1;
if gb==1
    gtype = [gset{1}];
    load([savpath gtype '_optotrigdat.mat'])
    
    for cpi = 1:length(corder)
        pi = cpi; cid = corder(cpi);
        if cid~=11; cli = 4; else cli = 5;end

        subplot(ceil(pnm/2),2,cpi); hold all %
        plot(smooth(pt(cid).nmean,mf),'color',clst{cli},'linewidth',1.5)
        px = [1:pln,pln:-1:1];
        ptc = [smooth(pt(cid).nci(1,:),mf) smooth(pt(cid).nci(2,:),mf)]';
        py = [ptc(1,:) ptc(2,end:-1:1)];
        patch(px,py,clst{cli},'edgecolor','none','facealpha',.5)
        set(gca,'xtick',[45 61 91 106],'xticklabel','','yticklabel','',...
            'tickdir','out','ticklength',.025*[1 1]) %,'xtick',[45 61 91 106] (0:60:600)/dw
        xlim([45 106])
        
        if cid~=11
            ylim([0 1.1])
            title(cnmvec(cid))
        else
            title('Speed')
            ylim([0.005 .06005])
            set(gca,'ytick',0:.03:.1)
        end
    end
end
%%
if svon
    svname = [gtype '_opto_trig'];
    savfig(savpath2,svname)
end