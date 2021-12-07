% clear
DirLog
cnmvec = {'NSM','AIY','RIB','AVB','RME','RIA','ASI','AIA','AVA','RIF'};

setsavpath
%% PCA
cls = 1:10;
gtype = 'wt';

load([savpath gtype '_alldata.mat'])
fids = find(Fdx>0);
cdata = Cdat(fids,:);
fidata = Fdx(fids);
vdata = Vdat(fids);
nlab = nsm_clust(fids);
vlab = vax_clust(fids);

pdat = cdata(:,cls); 

cvals = vdata/20000;
% cvals = vlab;
cvals = cdata(:,1);


[pc,score,latent,explnd] = runPCA(pdat,0,-1,cvals);
%% color by foraging state
cvals = Bst2(fids);
cmap = [.93 .69 .13;.49 .18 .56;.4 .67 .19];
cmap = getstateclr;
cmap = cmap([2 1],:);

f15=figure(15);clf;hold all
f15.OuterPosition = [354 502 267 330];

% scatter(score(:,1),-smcore(:,2),15,cvals,'filled','markerfacealpha',.2)
scatter3(score(:,1),-score(:,2),score(:,3),15,cvals,'filled','markerfacealpha',.5)
% scatter3(smcore(nlab==3,1),smcore(nlab==3,2),smcore(nlab==3,3),3,find(nlab==3))
axis equal

% view([151.000000481743 38.9999998784058]);
grid('on');
caxis([1 3])
% zlim([-3 5]); 
xlim([-5 6]); ylim([-5 5])

% xlabel('PC1');ylabel('PC2');zlabel('PC3');
colormap(cmap)

plotstandard
set(gca,'yticklabel','')
%%
savname = [gtype '_pca_byBst'];
saveas(gcf,[savpath2 savname '.tif'])
saveas(gcf,[savpath2 savname '.fig'])
saveas(gcf,[savpath2 savname '.eps'],'epsc')

%% color by axial velocity
cvals = vdata/20000;
cmap = cmap_gen({[1 0 0] .5*ones(1,3) [0 1 0]});

f16=figure(16);clf;hold all
f16.OuterPosition = [154 502 267 330];
scatter3(score(:,1),-score(:,2),score(:,3),15,cvals,'filled','markerfacealpha',.2)
% scatter3(smcore(nlab==3,1),smcore(nlab==3,2),smcore(nlab==3,3),3,find(nlab==3))
axis equal
% view([151.000000481743 38.9999998784058]);
grid('on');
caxis([-.05 .05])
zlim([-3 5]); xlim([-5 6]); ylim([-5 5])

% xlabel('PC1');ylabel('PC2');zlabel('PC3');
plotstandard
set(gca,'yticklabel','')
colormap(cmap)

%%
savname = [gtype '_pca_byvax'];
saveas(gcf,[savpath2 savname '.tif'])
saveas(gcf,[savpath2 savname '.fig'])
saveas(gcf,[savpath2 savname '.eps'],'epsc')
%% color by NSM activity
cvals = cdata(:,1);

f14=figure(14);clf;hold all
f14.OuterPosition = [14 502 267 330];
scatter3(score(:,1),-score(:,2),score(:,3),15,cvals,'filled','markerfacealpha',.2)
% scatter3(smcore(nlab==3,1),smcore(nlab==3,2),smcore(nlab==3,3),3,find(nlab==3))
axis equal
% view([151.000000481743 38.9999998784058]);
grid('on');
caxis([-.07 1])
zlim([-3 5]); xlim([-5 6]); ylim([-5 5])

% xlabel('PC1');ylabel('PC2');zlabel('PC3');
colormap jet
plotstandard
set(gca,'yticklabel','')
%%
savname = [gtype '_pca_bynca'];
saveas(gcf,[savpath2 savname '.tif'])
saveas(gcf,[savpath2 savname '.fig'])
saveas(gcf,[savpath2 savname '.eps'],'epsc')