function [bm,bci] = make_barplt(bx,bdat,clrs,fid,bw,em)
% bdat clrs are cell vars
bn = length(bdat);
if isempty(bx)
    bx = 1:bn;
end
if isempty(fid)
fid = 19;
end
if isempty(bw)
bw = .5;
end
figure(fid);clf;hold all

for bi = 1:bn
    cbd = bdat{bi}; cbd = cbd(:);
    bm(bi) = nanmedian(cbd);
    switch em
        case 1
            bci(:,bi) = bootmedian(100,cbd);
            bce = [bm(bi)-bci(1,bi),bci(2,bi)-bm(bi)];
        case 2
            be = std(cbd)/sqrt(length(cbd));
            bci(:,bi) = [bm(bi)-be;bm(bi)+be];
            bce = [be be];
    end
    bar(bx(bi),bm(bi),'barwidth',bw,'facecolor',clrs{min(bi,length(clrs))})
    errorbar(bx(bi),bm(bi),bce(1),bce(2),'k.','linewidth',1)
    hold all
end

plotstandard
set(gca,'xlim',[bx(1)-.7 bx(end)+.7],'xtick',bx)
