function [chout,cmn,ce] = plot_trigg_f4(dmat1,dmat2,dmat3,dset,plclr)
% parse input params
tpre = dset(1).spc.tpre; % tpost = dset(1).spc.tpost;
tini = dset(1).spc.tini; % dth = dset(1).spc.dth;
ylm = [-.1 .4];
%% plot pre-state profile for combined track group
[ddsrt,cd1] = sort(dset(1).ddr,'descend');

if ~isempty(dmat2)
    [ddsrt,cd2] = sort(dset(2).ddr,'descend');
    chxful = [dmat1(cd1,:);dmat2(cd2,:)];
else
    chxful = dmat1(cd1,:);
end

cm = 45;
chout = cal_matmean(chxful,1,1);
cmn = slidingmean([],chout.mean,cm,-1);
ce = slidingmean([],chout.se,cm,-1);

bx = ((1:size(chxful,2))-tpre-1)/3;
if ~exist('plclr','var')||isempty(plclr)
   plclr = [0 0 1]; 
end
% p
% generate control profile

hold all
plot_bci(bx,[cmn-ce;cmn+ce],cmn,plclr,[],[])
plot(bx([1 end]),[0 0],'k:','linewidth',1.5)
plot(0*[1 1],ylm,'k')
xlim(bx([1 end])); ylim(ylm)

set(gca,'xtick',[((1:180:361)-tpre-1)/3 40],'xticklabel',{'-2' '-1' '0'},...
    'ytick',[-.1 0 .15 .3],'yticklabel','')
plotstandard
set(gcf,'outerposition',[200 685 200 265])