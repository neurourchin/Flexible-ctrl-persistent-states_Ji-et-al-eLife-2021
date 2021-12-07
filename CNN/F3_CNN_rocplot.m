
% fname = [gtype '_cnnpat_2-10dat'];
% load([savpath fname '.mat'],'tacr1')
%% summarize roc auc
mau1 = nan(1,length(sfm1));
for mi = 1:length(sfm1)
% % mi = ceil(rand*199);
sfm = (sfm1(mi).sf(end-5:end,2))';
lb = int8(sfm1(mi).tlb(end-5:end))-1;
tlb = lb';%[lb 1-lb]';
% [tpr,fpr,thresholds] = roc(tlb,sfm);
[X,Y,T,AUC] = perfcurve(tlb,sfm,1);
mau1(mi) = AUC;
% % figure(10)
% % plotroc(tlb,sfm)
% % tacr1(mi)
end
figure(65);clf;hold all
subplot 211; hist(mau1)
%%
mauc = nan(1,length(sfmc));
for mi = 1:length(sfmc)
% % mi = ceil(rand*199);
sfm = (sfmc(mi).sf(end-5:end,2))';
lb = int8(sfmc(mi).tlb(end-5:end))-1;
tlb = lb';%[lb 1-lb]';
% [tpr,fpr,thresholds] = roc(tlb,sfm);
[X,Y,T,AUC] = perfcurve(tlb,sfm,1);
mauc(mi) = AUC;
% % figure(10)
% % plotroc(tlb,sfm)
% % tacr1(mi)
end
figure(65);hold all
subplot 212;cla; hist(mauc)