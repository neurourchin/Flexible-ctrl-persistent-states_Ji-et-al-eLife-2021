xsp = OP.stagevel(:,1); ysp = OP.stagevel(:,2);
wx = OP.wormpos(:,1); wy = OP.wormpos(:,2);
wc = [median(wx) median(wy)];

spf = sqrt(xsp.^2+ysp.^2);
wd = [wx-wc(:,1) wy-wc(:,2)];
wdn = sqrt(wd(:,1).^2+wd(:,2).^2);

figure(2);clf;hold all
yyaxis left; plot(spf); ylim([0 2500])
yyaxis right; plot(wdn); ylim([0 20])

figure(3);clf;hold all
make2ddhist(spf,wdn,0:100:2500,0:20,2)

figure(4);clf;hold all
make2dschist({spf},{wdn},[0 0 1],[200 1])
xlim([0 2500]);ylim([0 20])

%%
smw = 90;
cp = nan(length(sloc),1); xp = cp; yp = cp;
wx = xp; wy = yp;
cp(pid) = spdo;
xp(pid) = slocc(:,1)./10000; yp(pid) = slocc(:,2)/10000;
wx(pid) = OP.wormpos(pid,2); wy(pid) = OP.wormpos(pid,1);

nid = find(abs(diff(xp))>1|abs(diff(yp))>1);
for ni = 1:length(nid)
    cni = nid(ni);
    xp = [xp(1:cni);nan;xp((cni+1):end)];
    yp = [yp(1:cni);nan;yp((cni+1):end)];
    cp = [cp(1:cni);nan;cp((cni+1):end)];
    wx = [wx(1:cni);nan;wx((cni+1):end)];
    wy = [wy(1:cni);nan;wy((cni+1):end)];
end

cp(cp>.08) = .08;
figure(65);clf;hold all;
set(gcf,'outerposition',[86 660 327 395])
% subplot 121; hold all
colorline_fun(xp,yp,cp,.1080); caxis([0.015 .082])
plot([0.5 1],-7.5*[1 1],'k','linewidth',1.5)
clrs = getstateclr;
cmap = cmap_gen_flx({clrs(2,:),clrs(1,:)},[50 100]);
colormap(cmap)
axis square;axis equal;
set(gca,'xlim',[-15 3],'xtick',(-15:2.5:15),...
    'ylim',[-10 8],'ytick',(-15:2.5:15))

%%
cf = 10000/33;
nzi = find(~isnan(wx)&~isnan(wy));
nid = find(abs(diff(wx))>500|abs(diff(wy))>500);
cwp = cp; op = .2; clr = 'k';
wx(nid)=[]; wy(nid) = []; cp(nid) = [];
soc = 10;
xeds=220:390; yeds = 320:590;

figure(66);clf;hold all
set(gcf,'outerposition',[86 360 327 395])
%  subplot 122; cla;hold all
%  colorline_fun(wx,wy,cp,.020); caxis([0.015 .082])
make2ddhist(wx,wy,xeds,yeds,2); colormap gray
plot([280 295],440*[1 1],'w','linewidth',1.5)
set(gca,'xlim',[240 310],'ylim',[430 500],'yticklabel','','xticklabel','')
%%
impath = 'D:\workspace\KeepVids\DATA 22618_1510 mt5 wm1001\';
imf = dir([impath '*_test.avi']);
v = VideoReader([impath imf(1).name]);
v.CurrentTime = 600;
img = readFrame(v);
figure(67);clf;hold all
set(gcf,'outerposition',[426 360 327 395])
imagesc(img(:,:,1))
hold all
plot([490 505],245*[1 1],'w','linewidth',1.5)
% plotstandard
set(gca,'xlim',[435 510],'ylim',[235 310],'yticklabel','','xticklabel','')
colormap parula