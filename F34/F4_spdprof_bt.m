clc
fiid = 75; bn = 100;
fgl = length(fgtype); ocmat = cell(1,fgl);
clrs = getstateclr;
cx = -.01:.005:.115;
hrn = [.02 .04]; pmmt = nan(bn,fgl);

for fgi = 1:fgl
    gtype = fgtype{fgi};
    load([savpath gtype '_alldata.mat'])
    fids = find(Fdx>0);
    cdata = Cdat(fids,:);
    cdata(cdata==0) = nan;
    fdata = Fdx(fids);
    vdata = Vdat(fids)/20000;
    bdata = Bst2(fids);
    if fgi==1; bdata = 2-bdata; end
    cln = size(cdata,1);
    
    for bi = 1:bn
        pid = datasample(1:cln,round(cln/4));
        pdt = abs(vdata(pid));
        pmd(bi,fgi) = sum(pdt>=hrn(1)&pdt<=hrn(2))/length(pdt);
    end
 end
pmci = prctile(pmd,[2.5 97.5]); pmn = mean(pmd);
[fdrp,rp] = multicomp_bt(pmd(:,2:end),pmd(:,1))
%% plotting
figure(fiid);clf;hold all
bw = []; bx = []; bbol = 1; msiz  = 10; mtp = [];
pclr = [.24*ones(1,3);.9 .5 .1;1 .8 .3;.1 0 .9;.5 .1 .56;0.8 .6 .8];
plot_bcibar(bx,pmci,pmn,pclr,msiz,mtp,bw,bbol)
plotstandard
set(gca,'xlim',[.3 6.7],'ylim',[0 .5],'ytick',0:.25:1,'yticklabel','')
setfigsiz([-10.2000  520.6000  306.6000  280.4000])
