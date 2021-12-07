function xh = make2dschist(xset,yset,cclrs,bw)
px = []; py = []; lbl = [];
xl = length(xset);

for xi = 1:xl
px = [px;xset{xi}(:)]; py = [py;yset{xi}(:)];
lbl = [lbl;xi*ones(length(xset{xi}),1)];
end

xh = scatterhist(px,py,'Group',lbl,'Kernel','on','Bandwidth',bw(:)*ones(1,length(xset)),'legend','off',...
    'Direction','out','Color',cclrs,'LineStyle',{'-','-','-'},...
    'LineWidth',[2,2,2],'MarkerSize',[12,12]);
xh(1).XLabel.String = ''; xh(1).YLabel.String = '';
