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
pdat = diff(pdat(1:5:end,:),[],1);

cvals = vdata/20000;
% cvals = vlab;
cvals = pdat(:,1);


[pc,score,latent,explnd] = runPCA(pdat,0,-1,cvals);
%% color by foraging state
cvals = Bst2(fids);
cvals = cvals(1:5:end); cvals = cvals(2:end);
cmap = getstateclr;
cmap = cmap([2 1],:);

f15=figure(15);clf;hold all
f15.OuterPosition = [354 502 150 220];

scatter3(score(:,1),-score(:,2),score(:,3),15,cvals,'filled','markerfacealpha',.5)

grid('on');
caxis([1 3]);ylim([-2 2])
colormap(cmap)
plotstandard
set(gca,'yticklabel','')
%% color by axial velocity
cvals = vdata/20000;
cvals = cvals(1:5:end); cvals = cvals(2:end);
cmap = cmap_gen({[1 0 0] .5*ones(1,3) [0 1 0]},1);

f16=figure(16);clf;hold all
f16.OuterPosition = [154 502 150 220];
scatter3(score(:,1),-score(:,2),score(:,3),15,cvals,'filled','markerfacealpha',.2)
grid('on');
caxis([-.025 .025]);ylim([-2 2])
plotstandard
set(gca,'yticklabel','')
colormap(cmap)
%% color by NSM activity
cvals = cdata(:,1);
cvals = cvals(1:5:end); cvals = cvals(2:end);

f16=figure(17);clf;hold all
f16.OuterPosition = [14 502 150 220];
scatter3(score(:,1),-score(:,2),score(:,3),15,cvals,'filled','markerfacealpha',.2)
grid('on');
caxis([-.025 .025]);ylim([-2 2])
plotstandard
set(gca,'yticklabel','')
colormap jet
%%
if svon
    %%
    figure(15)
    savname = [gtype '_DIFFpca_byBst'];
    saveas(gcf,[savpath2 savname '.tif'])
    saveas(gcf,[savpath2 savname '.fig'])
    saveas(gcf,[savpath2 savname '.eps'],'epsc')
    
    figure(16)
    savname = [gtype '_DIFFpca_byvax'];
    saveas(gcf,[savpath2 savname '.tif'])
    saveas(gcf,[savpath2 savname '.fig'])
    saveas(gcf,[savpath2 savname '.eps'],'epsc')
    
    figure(17)
    savname = [gtype '_DIFFpca_bynca'];
    saveas(gcf,[savpath2 savname '.tif'])
    saveas(gcf,[savpath2 savname '.fig'])
    saveas(gcf,[savpath2 savname '.eps'],'epsc')
end
%%
