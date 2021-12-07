setsavpath
DirComp

svon = 0;
%% calculate mean normed std for each channel
cgf = []; crf = [];
for gi = [2 3 4 6]%length(gst)
    gdirs = gst(gi).dir;
    for di = 1:length(gdirs)
        cdp = gdirs{di};
        fd = dir([cdp '*_exp.mat']);
        load([cdp fd(1).name])
        
        cgd = nan(8,1); crd = cgd;
        for ci = 1:8
            cg = caexp_g{ci}; cr = caexp_r{ci};
            
            cgd(ci) = diff(prctile(cg,[2.5 97.5]))/nanmean(cg);
            crd(ci) = diff(prctile(cr,[2.5 97.5]))/nanmean(cr);
        end
        cgf = [cgf cgd];
        crf = [crf crd];
    end
end
%%
figure(60);clf; hold all
hx = 0:.05:2;
hg = histogram(cgf(:),hx);
% hg.EdgeColor = 'none';hg.FaceAlpha = .25;
hgy = hg.Values/sum(hg.Values);
hr = histogram(crf(:),hx);
hry = hr.Values/sum(hr.Values);

figure(60);clf; hold all
bar(hx(1:(end-1)),hgy,'facecolor','g','edgecolor','none');
bar(hx(1:(end-1)),hry,'facecolor','r','edgecolor','none'); alpha(.35)
[kg,kgx] = ksdensity(cgf(:)); kg = kg*.05;
[kr,krx] = ksdensity(crf(:)); kr = kr*.05;
plot(kgx,kg,'color',[0 .5 0],'linewidth',1.5);
plot(krx,kr,'r','linewidth',1.5)
plotstandard
set(gca,'xlim',[-.2 2],'ylim',[0 .1501],'ytick',0:.05:.2,'yticklabel','')
set(gcf,'outerposition',[135 630 251 318])
