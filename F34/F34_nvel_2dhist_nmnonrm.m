cnmvec = {'NSM','AIY','RIB','AVB','RME','RIA','ASI','AIA','AVA','RIF'};

setsavpath
DirLog

fgtype = {'wt','tph1','mod1','pdfr1','pdfracy1','tph1pdfr1'};
svon = 0;
%%
cd1 = cell(1,6); cd2 = cd1;
fidd = 130;
figure(fidd);clf; hold all
coi = 1;
clear bn; cn{1} = -300:100:2200;
if fidd<=130
    ylm = [-.05 2]; setfigsiz([-30 200 328 554])
    cn{2} = -.1:.075:2.1;
else
    ylm = [-.05 1.4]; setfigsiz([-30 100 328 554])
    cn{2} = -.1:.05:2.1;
end
xlm = [-250 2100];
rbmap; dlg = 1;

% bn = 20;
%
for gi = [1 2 3 4 5 6]%1:length(fgtype)
    gtype = fgtype{gi};
    if fidd<=130
        load([savpath gtype '_alldata_nostrnrm.mat']) % _nostrnrm
    else
        load([savpath gtype '_alldata.mat'])
    end
    
    nc1 = Cdat(:,coi);
    bc1 = Vdat;
    
    subplot(3,2,gi);cla;
    hp = make2dhistp(bc1,nc1,cn,dlg);
    plotstandard
    set(gca,'xlim',ylm,'ylim',xlm)
    if dlg
        caxis([-9 -3])
    else
        caxis([0 0.005])
    end
    colormap(rbmp)
    box off
end
