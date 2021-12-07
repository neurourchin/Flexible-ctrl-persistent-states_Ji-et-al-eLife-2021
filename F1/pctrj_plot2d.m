cvc = 'b';

if ~exist('ncmap','var')
    ncmap = jet(100);
end

figure(11);clf;
figure(foi); clf; hold all

pnum = size(pset,1); rn = floor(sqrt(pnum)); cn = ceil(pnum/rn);

for ri = 1:pnum

figure(foi);
subplot(rn,cn,ri); hold all; grid on
% plot(pl(:,1),pl(:,2),cvc,'linewidth',2)
% plot(prm(:,1),prm(:,2),'ko-','markersize',5)
% scatter(prm(:,1),prm(:,2),35,ncmap(round(prc*150),:),'filled','o')
% 
% plot(pom(:,1),pom(:,2),'k^-','markersize',5)
% scatter(pom(:,1),pom(:,2),35,ncmap(round(poc*150),:),'filled','^')

xlabel('PC1');ylabel('PC2');zlabel(['PC' num2str(pd3)]);
% xlim([-1.2 1]); ylim([-.4 1.3]); zlim([-1 .6])
% zlim([-4 6]); 
xlim([-3 4]); ylim([-1.5 2.5])

cdt = caset(ri,:); pci = find(~isnan(cdt));
cdt = cdt(pci); cdt(cdt<0)=0; cvl = min(100,max(1,round(cdt*150)));
plot(pset(ri,pci,1),pset(ri,pci,2),'color',.5*ones(1,3))
plot(pset(ri,pci(end),1),pset(ri,pci(end),2),'o','color',.2*ones(1,3))
scatter(pset(ri,pci,1),pset(ri,pci,2),25,ncmap(cvl,:),'filled','o')

figure(11);hold all
subplot(rn,cn,ri)
plot(caset(ri,:),'o-')
end