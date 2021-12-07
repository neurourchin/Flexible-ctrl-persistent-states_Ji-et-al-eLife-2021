%% train with GLM
twin = [150 150];
t_res = 25;
ffl = (unique(Fdx))';
ftst = 8;
ftr = ffl(ffl~=ftst);

% random sampling
cls = 1:9;
tp = .7;

figure(5);clf;hold all;
vdm = []; pp = 0;
for fpi = (unique(Fdx))'
    vdt = Vdat(Fdx==fpi);
    vdmt = smooth(vdt,47);
    vdmt = (vdmt/prctile(vdmt,99));
    vdm = [vdm;(vdmt(:))];
    pp = pp+1;
end
plot(vdm);plot([0 length(vdm)],[0 0])
yyaxis right;plot(Cdat(ismember(Fdx,fii),1))

Cdm = [];
for ci = 1:size(Cdat,2)
Cdm = [Cdm medfilt1(Cdat(:,ci),15)];
end

ftsi = ftst;
fts = ismember(Fdx(ffi),ftsi);
ftrn = ismember(Fdx(ffi),fii(~ismember(fii,ftsi)));
cdats = Cdm(ffi(ftrn),cls);
fdats = Fdx(ffi(ftrn));
vdats = vdm((ftrn));
bt2 = Bst2(ffi(ftrn));

ctst = Cdm(ffi(fts),cls);
btst = Bst2(ffi(fts));
vtst = vdm(fts);
tdst = Tdat(ffi(fts));
%
trnx = cdats; trny = vdats;
tstx = ctst; lsty = vtst;
lmd = fitlm(trnx,trny,'quadratic'); 
lpred = predict(lmd,trnx);
ltpred = predict(lmd,tstx);

%
figure(106);clf;hold all
subplot 311;plot(1:fil,[cdats(:,1);ctst(:,1)]);
yyaxis right; plot(1:fil,[trny;lsty],'linewidth',1.5)
% hold all;plot(ftrn,llb,'b:','linewidth',1.5)
% hold all;plot(fts,tlb,'k:','linewidth',1.5);ylim([-0.1 1.2])
hold all;plot(1:length(lpred),lpred,'b-','linewidth',1)
hold all;plot(length(lpred)+(1:length(ltpred)),ltpred,'k-','linewidth',1);%ylim([-2000 2000])
hold all;plot([1 fil],[0 0],'k--')
xlim([round(fil)*.7 fil]);ylim([-2 2])

subplot 312;cla;hold all;
plot(1:fil,[cdats(:,1);ctst(:,1)])
yyaxis right;
plot(1:fil,[bt2 btst])
xlim([round(fil)*.7 fil])

subplot 313;cla;hold all;
plot(1:fil,[cdats(:,end);ctst(:,end)])
yyaxis right;
hold all;plot(1:length(lpred),smooth(lpred,1),'b-','linewidth',1)
hold all;plot(length(lpred)+(1:length(ltpred)),smooth(ltpred,1),'k-','linewidth',1);
% ylim([-2000 2000])
hold all;plot([1 fil],[0 0],'k--')
xlim([round(fil)*.7 fil])
%
prn = 1;
figure(10);clf;hold all
scatter([trny],[lpred],50,'b.')
scatter([lsty],[ltpred],50,'r.')
plot([0 0],prn*1.2*[-1 1],'k');plot(prn*1.2*[-1 1],[0 0],'k')
plot(prn*[-1 1],prn*[-1 1]+prn*.2,'k')
plot(prn*[-1 1],prn*[-1 1]-prn*.2,'k')
xlim(prn*1.5*[-1 1]);ylim(prn*1.5*[-1 1])
% % ypred = glmval(coef,trnx,'logit');
% % glb = ypred>.5;
% % accur = sum(glb==trny)/length(ypred)
% [aucg,rocg]=sumaucn(sfmg);
% mean(aucg)