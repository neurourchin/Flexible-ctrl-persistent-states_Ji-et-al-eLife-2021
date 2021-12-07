
% clear
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
for coi = [1 4]
    cdr = [];
    if coi~=1
        gcoi = [1 2 3 4 6];
        clrm = [.24*ones(1,3);[.9 .5 .1];[1 .8 .3];[.1 0 .9];[0.8 .6 .8]];
    else
        gcoi = 1:6;
        clrm = [.24*ones(1,3);[.9 .5 .1];[1 .8 .3];[.1 0 .9];[.5 .1 .56];[0.8 .6 .8]];
    end
    figure(104+(coi>1));clf; hold all
    setfigsiz([20 436-300*(coi>1) 335 282])
    
    %
    pgi = 1;
    for gi = gcoi%1:length(fgtype)
        gtype = fgtype{gi};
        load([savpath gtype '_alldata_nostrnrm.mat']) % _nostrnrm

        if coi==1
            cdr{1,pgi} = Cdat(Cdat(:,4)>0.387,coi);
        elseif coi==4
            cdr{1,pgi} = Cdat(Cdat(:,1)>0.389,coi);
        end

        if gi==1
            wd1 = cdr{1,pgi};
        else
            [p1,~] = ranksum(wd1,cdr{1,pgi});
            cpt(coi,gi) = p1;
        end
        pgi = pgi+1;
    end
    
    cl = size(cdr,1);
    for i=1:cl
        subplot(cl,1,i); hold all
        [h,L,MX,MED]=violin_fr(cdr(i,:),'facecolor',clrm,...
            'edgecolor','k','facealpha',.3,...%'x',[1.5 2.3 3.5 4.3],...
            'plotdata',0,'medc','k');
        plot(get(gca,'xlim'),[0 0],'k:','linewidth',1)
        ytl = 1; set(gca,'xtick',1:6);
        plotstandard; box off
        ylim([-.2 2.5])
    end
    
    if svo1
        svname = ['nmab_cndhi_viol_' cnmvec{coi} '_nonrm'];
        savfig(savpath2,svname)
    end
    
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

