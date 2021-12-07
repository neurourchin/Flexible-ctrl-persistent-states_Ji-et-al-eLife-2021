function h = schist_fun(xin,yin,cset,bw)
px = []; py = []; lbl = []; bwm = [];
for di = 1:length(xin)
px = [px; xin{di}(:)]; py = [py; yin{di}(:)];
lbl = [lbl;(di-1)*ones(size(xin{di}(:)))];
% bwm = [bw(1)*ones(1,2);bw(2)*ones(1,2)]
end

if ~isempty(cset)
    cset = [.6 .6 .6;0 0 0];
end

axes1 = axes('Tag','yhist',...
    'Position',[rand(1,2)*.5 0.217016129032258 0.55]);

h = scatterhist(px,py,'Group',lbl,'Kernel','on','Bandwidth',[bw(1)*ones(1,di);bw(2)*ones(1,di)],'legend','off',...
    'Direction','out','Color',cset,'marker','..^','LineStyle',{'-','-',':'},...
    'LineWidth',[2,2,2],'MarkerSize',[15 15 8],'NBins',[20 20]);
h(1).XLabel.String = ''; h(1).YLabel.String = '';
h(1).XTickLabel = ''; h(1).YTickLabel = '';
h(2).XTick = h(1).XTick; h(3).XTick = h(1).XTick;
h(2).YTick = h(1).YTick; h(3).YTick = h(1).YTick;
axis square
