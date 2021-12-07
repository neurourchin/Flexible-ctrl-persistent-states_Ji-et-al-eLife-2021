tpre = 240; tpost = 900;
if ~exist('ncmap','var')
    ncmap = jet(100);
end

varout = nsmtrigger_on(NTR,smcore,vdata,fidata,nsm_gmfit,tpre,tpost);
P_on = varout.tdon;

varout = nsmtrigger_on(NTR,[cdata vdata],vdata,fidata,nsm_gmfit,tpre,tpost);
T_on = varout.tdon;

figure(101);clf;hold all
for i = 1:5
subplot(5,2,2*i-1); hold all
po = cal_matmean(P_on(i).vals,1,1);
plot_bci([],po.ci,po.mean,'b',[])
plot([240 240],[-2 2],'k:')
xlim([0 480]);ylim([-1 1.8])
end

%%
varout = nsmtrigger_off(NTR,smcore,vdata,fidata,nsm_gmfit,tpre,tpost);
P_on = varout.tdon;

varout = nsmtrigger_off(NTR,[cdata vdata],vdata,fidata,nsm_gmfit,tpre,tpost);
T_on = varout.tdon;

for i = 1:5
subplot(5,2,2*i); hold all
po = cal_matmean(P_on(i).vals,1,1);
plot_bci([],po.ci,po.mean,'b',[])
plot([240 240],[-2 2],'k:')
xlim([0 480]);ylim([-1 1.8])
end


