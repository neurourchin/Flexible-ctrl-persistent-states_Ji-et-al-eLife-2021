function auc = rocplot(sfm1)
% % mi = ceil(rand*199);
sfm = (sfm1.sf(end-5:end,2))';
lb = int8(sfm1.tlb(end-5:end))-1;
tlb = lb';%[lb 1-lb]';
% [tpr,fpr,thresholds] = roc(tlb,sfm);
[X,Y,T,auc] = perfcurve(tlb,sfm,1);
figure(10)
plotroc(tlb,sfm)
end

