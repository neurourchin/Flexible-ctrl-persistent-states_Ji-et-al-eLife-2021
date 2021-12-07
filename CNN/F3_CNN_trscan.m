setsavpath
svon = 0 ;
% general params
gtlist = {'wt' 'tph1' 'pdfr1' 'tph1pdfr1' 'unc31' 'tdc1' 'ttx3unc103gf' 'mod1' 'gcy28Chm'};
cgtype = 'wt';

gtype = cgtype;
load([savpath gtype '_alldata.mat'])
load([savpath gtype '_NSM_triggstat.mat'])
cls = [2:10];
svon = 0;
%% scan through temporal resolutions
trset = [15 30 45 60 75 100];
fnm = 3; prf = [400 300 180 120 60]; prf = prf(end:-1:1);
 tpost = 0; 
 trset = 60; prf = 180;

for pi = 1:length(prf)
    clear cmdl
    tpre = prf(pi);
    for ti = 1:length(trset)
        t_res = trset(ti);
        if t_res<=tpre
            fwn = floor(tpre/t_res);
            cmdl(ti).fspc = [t_res fwn];
            
            TDstat1 = extract_trigstat2(TD_on,t_res,fwn);
            CTstat1 = extract_trigstat2(CT_on,t_res,fwn);
            
            fiid = 10*ti;
            train_net_routine
            cmdl(ti).acr = tacr1;
            cmdl(ti).fltrw = hfilt1;
            cmdl(ti).fltp = hct;
            cmdl(ti).mfilt = hbnd;
            cmdl(ti).auc = aucf1;
            cmdl(ti).roc = rocf1;
            cmdl(ti).aic = aic;
            cmdl(ti).maic = nanmean(aic);
            cmdl(ti).bic = bic;
            cmdl(ti).mbic = nanmean(bic);
            
            if svon
                figure(fiid)
                savname = [gtype '_nsmon9nn_dt' num2str(t_res) '_dr' num2str(round(tpre/2))];
                saveas(gcf,[savpath2 savname '.tif'])
                saveas(gcf,[savpath2 savname '.fig'])
                %         saveas(gcf,[savpath2 savname '.eps'],'epsc')
                
                save([savpath savname '.mat'],'tacr1','hfilt1',...
                    'hct','hbnd','aucf1','rocf1','aic','bic','ic')
            end
        end
    end
    
    
    % plot and compare model performances
    clrs = {rand(1,3)};
    figure(121);clf;hold all
    subplot 411
    aucf = {cmdl(:).auc};
    for ai= 1:length(aucf)
    aucm(ai) = nanmean(aucf{ai});
    end
    plot(aucm);
    % aucf = [cmdl(:).auc]
    % make_barplt([],aucf,clrs,[],[],1)
    subplot 412
    aicf = [cmdl(:).aic]; plot(aicf);
    subplot 413
    bicf = [cmdl(:).bic]; plot(bicf)
    
    if svon
        mfname = ['cnn9ndr' num2str(round(tpre/2)) '_mcmp'];
        figure(121)
        saveas(gcf,[savpath2 mfname '.tif'])
        saveas(gcf,[savpath2 mfname '.fig'])
        mfname = ['cnn9ndr' num2str(round(tpre/2)) '_fuldat'];
        save([savpath mfname '.mat'],'cmdl')
    end
end