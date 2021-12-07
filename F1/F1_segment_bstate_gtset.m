% clear
cnmvec = {'NSM','AIY','RIB','AVB','RME','RIA','ASI','AIA','AVA','RIF'};

setsavpath
DirLog

fgtype = {'wt','tph1','mod1','pdfr1','tph1pdfr1','tph1i','pdfracy1'};
svon = 0;
%% cluster NSM activity and velocity stats using ref models
ckflg = 1;
for gi = 1:length(fgtype)
    gtype = fgtype{gi};
%     classify_activity_gm
%     save([savpath gtype '_alldata.mat'],'Xd','nsm_clust','nsm_gmfit','vax_clust','vax_gmfit','-append')
    get_vax_hmm
end