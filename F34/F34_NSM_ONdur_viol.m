cnmvec = {'NSM','AIY','RIB','AVB','RME','RIA','ASI','AIA','AVA','RIF'};

setsavpath
DirLog

cid = 3; % 3~NSM high periods
bid = 3;
svon = 0;
%%
load([savpath 'wt_mt_nsmdwdur_schist.mat'],'ndur','bstdur','nfdr','bfdr')
fi1 = 40;
cpt = [];
eclrs = [.24*ones(1,3);.9 .5 .1;1 .8 .3];
clrs = {.24*ones(1,3);[.9 .5 .1];[1 .8 .3];[.1 0 .9];[.5 .1 .56];[0.8 .6 .8]};
clrm = [.24*ones(1,3);[.9 .5 .1];[1 .8 .3];[.1 0 .9];[.5 .1 .56];[0.8 .6 .8]];

bn = 200; ngdr = [];
clear bym1 bym2 byc1 byc2

% 5-HT mut, nsm on duration
figure(fi1);clf;hold all
fpi = 1;
for fgi = [1 2 3] 
by1 = ndur{fgi};
ngdr{fpi} = ndur{fgi};

fpi = fpi+1;
end

[h,L,MX,MED]=violin_fr(ngdr(i,:),'facecolor',clrm,...
    'edgecolor','k','facealpha',.3,...%'x',[1.5 2.3 3.5 4.3],...
    'plotdata',1,'medc','b');

ylim([0 1800]); 
set(gca,'ytick',0:600:2400,'xtick',0:3,'yticklabel','')
% axis square
plotstandard; box off
if fgi>3
    setfigsiz([35 475 345 250])
else
    setfigsiz([62 190 215 288])
end

if svon
    dfname = ['wttphmod_ndur_viol'];
    savfig(savpath2,dfname)
end
%% PDF muts
clear bym1 bym2 byc1 byc2
eclrs = [.24*ones(1,3);.9 .5 .1;.1 0 .9;.5 .1 .56;0.8 .6 .8];
clrs = {.24*ones(1,3);[1 .8 .3];[.1 0 .9];[.5 .1 .56];[0.8 .6 .8]};
clrm = [.24*ones(1,3);[.9 .5 .1];[.1 0 .9];[.5 .1 .56];[0.8 .6 .8]];
cpt = [];

fpi = 1; ngdr = [];
for fgi = [1 2 4 7 5] %length(fgtype)
by1 = ndur{fgi};
if fgi == 1
    wd1 = by1; 
else
    [p1,~] = ranksum(wd1,by1);
        cpt(fpi) = p1;
end
ngdr{fpi} = ndur{fgi};
fpi = fpi+1;
end

ngdr{end} = [ngdr{end} [7 6.2 8 5.8]*120];
figure(fi1);clf; hold all
[h,L,MX,MED]=violin_fr(ngdr(i,:),'facecolor',clrm,...
    'edgecolor','k','facealpha',.3,...%'x',[1.5 2.3 3.5 4.3],...
    'plotdata',1,'medc','r');
ylim([0 2100]); %xlim([.3 fpi-.3])
plotstandard
set(gca,'ytick',0:600:2400,'xtick',0:5,'yticklabel','')
plotstandard; box off
if ci>3
    setfigsiz([35 475 251 266])
else
    setfigsiz([62 190 195 288])
end

if svon
    dfname = ['wtmt_ndur_viol'];
    saveas(gcf,[savpath2 dfname '.tif'])
    saveas(gcf,[savpath2 dfname '.fig'])
    saveas(gcf,[savpath2 dfname '.eps'],'epsc')
end

%% plot spd per state
clear bym1 bym2 byc1 byc2

load([savpath 'wt_mt_bvbdstat.mat'],'bvful','fgtype')

eclrs = [0 0 .3;.9 .7 .2;.5 .1 .56;.1 0 .9;.5 .1 .56];
figure(fpi+1);clf; hold all
fpi = 1;
for fgi = [1 3 4 5] 
by1 = abs(bvful(fgi).st(1).bvm)/20000;
by2 = abs(bvful(fgi).st(2).bvm)/20000;
[mn1,bci1] = calc_mnbci(by1,bn);
bym1(fpi) = mn1; 
byc1(:,fpi) = bci1;

[mn2,bci2] = calc_mnbci(by2,bn);
bym2(fpi) = mn2;
byc2(:,fpi) = bci2;

fpi = fpi+1;
end

ebar2d(bym1,bym2,[],[],byc1,byc2,eclrs)

plot([-1 1],[-1 1],'k:')
xlim([-.005 .05]); ylim([-.005 .05])
plotstandard
set(gca,'ytick',0:240:1000,'xtick',0:240:1000,'yticklabel','')
axis square
