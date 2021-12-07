load([savpath gtype '_statetrans_PCA.mat'],'T_on','P_on','tpre','tpost','TP')
% offload data
predat = TP.prepc; posdat = TP.pospc; preca = TP.preca; posca = TP.posca;
prm = TP.prem; pom = TP.posm;prc = TP.nsmpre; poc = TP.nsmpos;
pl = TP.pvals; 
if ~exist('foi','var')
    foi = 17;
end
%%
pset = [predat posdat]; caset = [preca posca];

vwa = [-145.799174944814 13.9639344131103];
pd3 = 6;

pctrj_plot2d


%% save data for direct plotting
saveas(gcf,[savpath2 gtype '_statetranspca.tif'])
saveas(gcf,[savpath2 gtype '_statetranspca.fig'])
saveas(gcf,[savpath2 gtype '_statetranspca.eps'],'epsc')