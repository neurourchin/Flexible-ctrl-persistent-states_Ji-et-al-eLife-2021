%% train with GLM
twin = [150 150]; t_res = 25;

% random sampling
    cls = 1:10;
    cds = 2:4;
cls(ismember(cls,cds)) = [];
ftr = (unique(Fdx))';
aucf = []; rocf = []; yrf = [];
xit = 0:.02:1;

parfor rhi = ftr
    fho = ftr(randperm(length(ftr),1));
    fts = ffi(ismember(Fdx(ffi),fho)); ftl = length(fts);
    fts = fts(round(ftl*.5):ftl);
    ftrn = ~ismember(ffi,fts);
    
    Cdm = [];
    for ci = 1:size(Cdat,2)
        Cdm = [Cdm medfilt1(Cdat(:,ci),303)];
    end
    % Cdm = medfilt1(Cdat);
    cdats = Cdm(ftrn,cls);
    fdats = Fdx(ftrn);
    vdats = Vdat(ftrn);
    bt2 = Bst2(ftrn);
    
    ctst = Cdm(fts,cls);
    btst = Bst2(fts);
    vtst = Vdat(fts);
    
    %
    trnx = cdats; brny = bt2'>0; tsty = btst'>0;
    [B,FitInfo] = lassoglm(trnx,brny,'binomial','alpha',.15,'CV',3);
    idxLambdaMinDeviance = FitInfo.IndexMinDeviance;
    B0 = FitInfo.Intercept(idxLambdaMinDeviance);
    coef = [B0; B(:,idxLambdaMinDeviance)];
    yptr = glmval(coef,cdats,'logit');
    llb = yptr>.5;
    yptst = glmval(coef,ctst,'logit');
    glb = yptst>.5;
    accur = sum(glb==tsty)/length(yptst);
    
    ip = strel('disk',50);
    ldt = imclose((llb>0),ip); gdt = imclose((glb>0),ip);
    accur = sum(gdt==tsty)/length(yptr);
    
    [X,Y,T,AUC] = perfcurve(tsty,yptst,1);
    [xsrt,xia,~] = unique(X); ysrt = Y(xia);
    yit = interp1(xsrt,ysrt,xit); yrf = [yrf;yit];
    figure(76);hold all
    plot(X,Y);plot(xit,yit,':','linewidth',1.5)
    drawnow
    rocf = [rocf;[X(:) Y(:)]];
    aucf = [aucf AUC];
end

%
yo = cal_matmean(yrf,1,1);
figure(79);
if length(cls)==10
    clf; plot([0 1],[0 1],'k:','linewidth',1.5)
end
hold all
plot_bci(xit,yo.se,yo.mean,rand(1,3),'','')
ytl=1; plotstandard
set(gca,'ytick',0:.5:1,'xtick',0:.5:1)
%%
rply = input('Save glm model data? y=enter/n=any other key ','s');

if isempty(rply)

   save([savpath gtype '_glmrd_' cnmvec{cls} '.mat'],'aucf','rocf','xit',...
       'yrf','fstr','yo');

end