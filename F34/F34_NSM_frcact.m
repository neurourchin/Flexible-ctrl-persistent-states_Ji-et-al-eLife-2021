setsavpath
DirLog

fgtype = {'wt','tph1','mod1','pdfr1','pdfracy1','tph1pdfr1','tph1i'};
svon = 0;

fpd = 103;
Nfg = struct('fr',[],'nw',[],'rt',[]);

for gi = 1:6
    gtype = fgtype{gi};
    load([savpath gtype '_alldata.mat'])
    %%
    fp = 1;
    frc = []; nwt = [];
    for fi = (foi(:))'
        %%
        cdats = Cdat(Fdx==fi,1);
        vdats = Vdat(Fdx==fi,1);
        nnt = nsm_clust(Fdx==fi);
        
        frc(fp) = sum(nnt>2)/length(nnt); nwt(fp) = length(nnt);
        
        fp = fp+1;
    end
    Nfg(gi).fr = frc;
    Nfg(gi).nw = nwt;
    Nfg(gi).rt = sum(frc.*nwt)/sum(nwt);
end

% plot
clrs = {.24*ones(1,3);[.9 .5 .1];[1 .8 .3];[.1 0 .9];[.5 .1 .56];[0.8 .6 .8]};
bdat = {Nfg.fr};
fidx = 63;
[bm,bci] = make_barplt([],bdat,clrs,fidx,[],1);
set(gca,'yticklabel','')
%%
if svon
    save([savpath savname '.mat'],'Nmat','Nbd','nsrt')
end
