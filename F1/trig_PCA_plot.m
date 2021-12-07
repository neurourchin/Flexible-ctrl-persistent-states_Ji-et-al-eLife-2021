tpre = 240; tpost = 900;
poi = [1 2 4]; smw = 45;
cset = {'b','k',[.9 .5 0]};

varout = nsmtrigger_on(NTR,smcore,vdata,fidata,nsm_gmfit,tpre,tpost);
P_on = varout.tdon;

varout = nsmtrigger_on(NTR,[cdata vdata],vdata,fidata,nsm_gmfit,tpre,tpost);
T_on = varout.tdon;

figure(101);clf;hold all
set(gcf,'outerposition',[40 600 200 375]);

subplot(5,2,1); hold all
pout = cal_matmean((T_on(1).vals),1,1);
pm = slidingmean([],pout.mean,smw,0);
plo = slidingmean([],pout.ci(1,:),smw,0);
phi = slidingmean([],pout.ci(2,:),smw,0);
plot_bci([],[plo;phi],pm,cset{1},[])
plot([240 240],[-2 2],'k:')
xlim([0 480]);ylim([0 .8])
plotstandard
set(gca,'ytick',0:.4:.8,'yticklabel','','xtick',0:240:960)

subplot(5,2,9); cla; hold all
pout = cal_matmean(abs(T_on(11).vals),1,1);
pm = slidingmean([],pout.mean,smw,0);
plo = slidingmean([],pout.ci(1,:),smw,0);
phi = slidingmean([],pout.ci(2,:),smw,0);
plot_bci([],[plo;phi],pm,cset{2},[])
% plot_bci([],pout.ci,pout.mean,'b',[])
xlim([0 480]);ylim([0 1000])
plot([240 240],get(gca,'ylim'),'k:')
set(gca,'ytick',0:.4:.8,'yticklabel','')
plotstandard
set(gca,'ytick',0:500:1000,'yticklabel','','xtick',0:240:960)


for i = 1:length(poi)
    pi = poi(i);
    subplot(5,2,2+2*i-1); hold all
    pout = cal_matmean(P_on(pi).vals,1,1);
    pm = slidingmean([],pout.mean,smw,-1);
    plo = slidingmean([],pout.ci(1,:),smw,-1);
    phi = slidingmean([],pout.ci(2,:),smw,-1);
    plot_bci([],[plo;phi],pm,cset{3},[])
    plot([240 240],[-2 2],'k:')
    xlim([0 480]);ylim([-1 1.8])
    plotstandard
    set(gca,'ytick',-1:1,'yticklabel','','xtick',0:240:960)
    
end

%%
varout = nsmtrigger_off(NTR,smcore,vdata,fidata,nsm_gmfit,tpre,tpost);
P_on = varout.tdon;

varout = nsmtrigger_off(NTR,[cdata vdata],vdata,fidata,nsm_gmfit,tpre,tpost);
T_on = varout.tdon;

subplot(5,2,2); hold all
pout = cal_matmean((T_on(1).vals),1,1);
pm = slidingmean([],pout.mean,smw,0);
plo = slidingmean([],pout.ci(1,:),smw,0);
phi = slidingmean([],pout.ci(2,:),smw,0);
plot_bci([],[plo;phi],pm,cset{1},[])
plot([240 240],[-2 2],'k:')
xlim([0 480]);ylim([0 .8])
plotstandard
set(gca,'ytick',0:.4:.8,'yticklabel','','xtick',0:240:960)

subplot(5,2,10); cla; hold all
pout = cal_matmean(abs(T_on(11).vals),1,1);
pm = slidingmean([],pout.mean,smw,0);
plo = slidingmean([],pout.ci(1,:),smw,0);
phi = slidingmean([],pout.ci(2,:),smw,0);
plot_bci([],[plo;phi],pm,cset{2},[])
% plot_bci([],pout.ci,pout.mean,'b',[])
xlim([0 480]);ylim([0 1000])
plot([240 240],get(gca,'ylim'),'k:')
plotstandard
set(gca,'ytick',0:500:1000,'yticklabel','','xtick',0:240:960)


for i = 1:length(poi)
    pi = poi(i);
    subplot(5,2,2+2*i); hold all
    pout = cal_matmean(P_on(pi).vals,1,1);
    pm = slidingmean([],pout.mean,smw,-1);
    plo = slidingmean([],pout.ci(1,:),smw,-1);
    phi = slidingmean([],pout.ci(2,:),smw,-1);
    plot_bci([],[plo;phi],pm,cset{3},[])
    plot([240 240],[-2 2],'k:')
    xlim([0 480]);ylim([-1 1.8])
    plotstandard
    set(gca,'ytick',-1:1,'yticklabel','','xtick',0:240:960)
    
end
