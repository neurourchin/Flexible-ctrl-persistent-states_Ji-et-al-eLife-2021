clear
cnmvec = {'NSM','AIY','RIB','AVB','RME','RIA','ASI','AIA','AVA','RIF'};

setsavpath
DirLog

fgtype = {'wt','tph1','mod1','pdfr1','pdfracy1','tph1pdfr1'};
svon = 0;
%%
gi = 1;
cd1 = cell(1,6); cd2 = cd1;
fidd = 191;
clear bn cn;
if fidd<=190
    ylm = [-.1 1.8]; %setfigsiz([-30 200 328 291])
    cn{1} = -.15:.075:2.1;
else
    ylm = [-.1 1.2]; %setfigsiz([-30 100 328 291])
    cn{1} = -.15:.05:2.1;
end
cn{2} = cn{1};
% xlm = [-2000 2100];
% setfigsiz([-30 200 689 435])
xlm = ylm;
rbmap;
%%
clrm = [.24*ones(1,3);[.9 .5 .1];[1 .8 .3];[.1 0 .9];[.5 .1 .56];[0.8 .6 .8]];
figure(69);clf;hold all
for gi = [1 2 4 6]
    gtype = fgtype{gi};
    clear Cdat Bst2 Vdat Bst
    if fidd<=190
        load([savpath gtype '_alldata_nostrnrm.mat']) % _nostrnrm
    else
        load([savpath gtype '_alldata.mat'])
    end
    %
    coi = [1 4];
    clm = [-7.5 -3];
    clm2 = [0.000 0.025];
    dlg = 1;
    pst = struct('rm',[],'dw',[]);
    fids = find(Fdx>0);
    cdata = Cdat(fids,:);
    cdata(cdata==0) = nan;
    fdata = Fdx(fids);
    vdata = Vdat(fids)/20000;
    xth = multithresh(cdata(:,1));
    yth = multithresh(cdata(:,4));
    hht = .1:.1:1;
    
    rc1o = Cdat(:,coi(1));
    rc2o = Cdat(:,coi(2));
    dli = rc1o==0|rc2o==0;
    rc1o(dli) = []; rc2o(dli) = []; rc21=rc2o;
    rl = numel(rc1o);
    
    pyc = [];
    for bi = 1:100
        rid = randsample(rl,round(rl/2),true);
        rc1 = rc1o(rid);
        rc2 = rc2o(rid);
        for yi = 1:10
            ytc = hht(yi);
            o21 = sum(rc1<xth&rc2>ytc);
            o22 = sum(rc1>xth&rc2>ytc);
            o11 = sum(rc1<xth&rc2<ytc);
            o12 = sum(rc1>xth&rc2<ytc);
            omat = [o11 o12;o21 o22]; omat = (-omat/sum(omat(:)));
            pyc(bi,yi) = o22/(o22+o12);
        end
        
    end
    %     plot(hht,pyc,'.-','linewidth',1)
    do = cal_matmean(pyc,1,0);
    bci = prctile(pyc,[2.5 97.5]);
    bmn = do.mean;
    plot_bci([],bci,bmn,clrm(gi,:),[],[])
end

ytl = 0; plotstandard
set(gca,'ytick',0:.5:1,'xtick',0:5:10)