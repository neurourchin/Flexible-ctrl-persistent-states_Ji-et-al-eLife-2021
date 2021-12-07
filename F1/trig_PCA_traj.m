tpre = 240; tpost = 900;
if ~exist('ncmap','var')
    ncmap = jet(100);
end

varout = nsmtrigger_on(NTR,smcore,vdata,fidata,nsm_gmfit,tpre,tpost);
P_on = varout.tdon;

varout = nsmtrigger_on(NTR,cdata,vdata,fidata,nsm_gmfit,tpre,tpost);
T_on = varout.tdon;

%%
% cvc1 = linspace(.01 )
if ~exist('dt','var')
    dt = 90;
end
prn = 1:dt:tpre; pon = prn(end)+(1:dt:tpost);
rl1 = length(prn)-1; rl2 = length(pon)-1;
predat = nan(size(T_on(1).vals,1),rl1,length(P_on)); posdat = nan(size(T_on(1).vals,1),rl2,length(P_on));
prebl = predat; prebh = prebl; posbl = posdat; posbh = posbl;
preca = nan(size(T_on(1).vals,1),rl1); posca = nan(size(T_on(1).vals,1),rl2);
cvc = 'b';


for ti = 1:size(T_on(1).vals,1)
    
    for di = 1:length(P_on)
        for ri1 = 1:rl1
            curn = prn(ri1):(prn(ri1+1)-1);
            mdat = P_on(di).vals(ti,curn);
            predat(ti,ri1,di) = nanmean(mdat);
            if sum(~isnan(mdat))
                bci = bootci(100,@nanmean,mdat);
                prebl(ti,ri1,di) = bci(1);
                prebh(ti,ri1,di) = bci(2);
            end
        end
        
        for ri2 = 1:rl2
            curn = pon(ri2):(pon(ri2+1)-1);
            mdat = P_on(di).vals(ti,curn);
            posdat(ti,ri2,di) = nanmean(mdat);
            if sum(~isnan(mdat))
                bci = bootci(100,@nanmean,mdat);
                posbl(ti,ri1,di) = bci(1);
                posbh(ti,ri1,di) = bci(2);
            end
        end
    end
    
    for ri1 = 1:rl1
        curn = prn(ri1):(prn(ri1+1)-1);
        tdat = T_on(coi).vals(ti,curn);
        preca(ti,ri1) = nanmean(tdat);
    end
    
    for ri2 = 1:rl2
        curn = pon(ri2):(pon(ri2+1)-1);
        tdat = T_on(coi).vals(ti,curn);
        posca(ti,ri2) = nanmean(tdat);
    end
end

prm = nanmean(predat,1); pom = nanmean(posdat,1);
prm = squeeze(prm); pom = squeeze(pom);
pl = [prm;pom];
prc = nanmean(preca,1); poc = nanmean(posca,1);

% gather data for storage
TP.prepc = predat; TP.pospc = posdat; TP.preca = preca; TP.posca = posca;
TP.prem = prm; TP.posm = pom;TP.nsmpre = prc; TP.nsmpos = poc;
TP.pvals = pl;

%%

pset = [predat posdat];
pop = 2;


figure(foi); clf; hold all

switch pop
    case 3
        if ~exist('foi','var')
            foi = 17;
        end

        plot3(pl(:,1),pl(:,2),pl(:,6),cvc,'linewidth',2)
        % errorbar(prm(:,1),prm(:,2),prm(:,1)-prebl(),ypos,xneg,xpos)
        plot3(prm(:,1),prm(:,2),prm(:,6),'ko-','markersize',9)
        scatter3(prm(:,1),prm(:,2),prm(:,6),75,ncmap(round(prc*150),:),'filled','o')
        
        plot3(pom(:,1),pom(:,2),pom(:,6),'k^-','markersize',9)
        scatter3(pom(:,1),pom(:,2),pom(:,6),75,ncmap(round(poc*150),:),'filled','^')
        
        % caxis([0 .6])
        % colormap jet
        xlabel('PC1');ylabel('PC2');zlabel('PC6');
        xlim([-1.2 1]); ylim([-.4 1.8]); zlim([-1 .6])
        set(gca,'ydir','reverse')
        view(gca,[-107.6 17.9]); grid on
    case 2
        if ~exist('foi','var')
            foi = 15;
        end
        plot(pl(:,1),pl(:,2),cvc,'linewidth',2)
        % errorbar(prm(:,1),prm(:,2),prm(:,1)-prebl(),ypos,xneg,xpos)
        plot(prm(:,1),prm(:,2),'ko-','markersize',9)
        scatter(prm(:,1),prm(:,2),75,ncmap(min(100,max(1,round(prc*150))),:),'filled','o')
        
        plot(pom(:,1),pom(:,2),'k^-','markersize',9)
        scatter(pom(:,1),pom(:,2),75,ncmap(min(100,max(1,round(poc*150))),:),'filled','^')
        
        grid on
        xlabel('PC1');ylabel('PC2');
%         xlim([-1.2 1]); ylim([-.4 1.8]);
xlim([-2 2]); ylim([-1.5 2.5])

end
%% save data for direct plotting
saveas(gcf,[savpath2 gtype '_statetranspca.tif'])
saveas(gcf,[savpath2 gtype '_statetranspca.fig'])
saveas(gcf,[savpath2 gtype '_statetranspca.eps'],'epsc')

save([savpath gtype '_statetrans_PCA_' num2str(dt/2) 's.mat'],'T_on','P_on','tpre','tpost','TP','dt')