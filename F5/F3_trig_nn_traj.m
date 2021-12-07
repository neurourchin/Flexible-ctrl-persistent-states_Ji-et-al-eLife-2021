tpre = 720+1; tpost = 480+1;
if ~exist('ncmap','var')
    ncmap = jet(100);
end

varout = nsmtrigger_on(NTR,cdata,vdata,fidata,nsm_gmfit,tpre,tpost);
T_on = varout.tdon;

%%
cci = 1;
% cvc1 = linspace(.01 )
    dt = 180;
prn = 1:dt:tpre; pon = prn(end)+(1:dt:tpost);
rl1 = length(prn)-1; rl2 = length(pon)-1;
predat = nan(size(T_on(1).vals,1),rl1,length(T_on)); posdat = nan(size(T_on(1).vals,1),rl2,length(T_on));
prebl = predat; prebh = prebl; posbl = posdat; posbh = posbl;
preca = nan(size(T_on(1).vals,1),rl1); posca = nan(size(T_on(1).vals,1),rl2);

for ti = 1:size(T_on(1).vals,1)
    
    for di = 1:length(T_on)
        for ri1 = 1:rl1
            curn = prn(ri1):(prn(ri1+1)-1);
            mdat = T_on(di).vals(ti,curn);
            predat(ti,ri1,di) = nanmean(mdat);
            if sum(~isnan(mdat))
                bci = bootci(100,@nanmean,mdat);
                prebl(ti,ri1,di) = bci(1);
                prebh(ti,ri1,di) = bci(2);
            end
        end
        
        for ri2 = 1:rl2
            curn = pon(ri2):(pon(ri2+1)-1);
            mdat = T_on(di).vals(ti,curn);
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
        tdat = T_on(cci).vals(ti,curn);
        preca(ti,ri1) = nanmean(tdat);
    end
    
    for ri2 = 1:rl2
        curn = pon(ri2):(pon(ri2+1)-1);
        tdat = T_on(cci).vals(ti,curn);
        posca(ti,ri2) = nanmean(tdat);
    end
end

prm = nanmean(predat,1); pom = nanmean(posdat,1);
prm = reshape(prm,size(prm,2),size(prm,3)); pom = reshape(pom,size(pom,2),size(pom,3));
pl = [prm;pom];
prc = nanmean(preca,1); poc = nanmean(posca,1);

% gather data for storage
TP.prepc = predat; TP.pospc = posdat; TP.preca = preca; TP.posca = posca;
TP.prem = prm; TP.posm = pom;TP.nsmpre = prc; TP.nsmpos = poc;
TP.pvals = pl;

%%
pd = [3 8 9];
pset = [predat posdat];
pop = 2; cvc = 'b';
if ~exist('ncmap','var')
    ncmap = jet(100);
end

figure(foi); clf; hold all

switch pop
    case 3
        if ~exist('foi','var')
            foi = 17;
        end

        plot3(pl(:,pd(1)),pl(:,pd(2)),pl(:,pd(3)),cvc,'linewidth',2)
        % errorbar(prm(:,1),prm(:,2),prm(:,1)-prebl(),ypos,xneg,xpos)
        plot3(prm(:,pd(1)),prm(:,pd(2)),prm(:,pd(3)),'ko-','markersize',9)
        scatter3(prm(:,pd(1)),prm(:,pd(2)),prm(:,pd(3)),75,ncmap(min(100,max(1,round(prc*150))),:),'filled','o')
        
        plot3(pom(:,pd(1)),pom(:,pd(2)),pom(:,pd(3)),'k^-','markersize',9)
        scatter3(pom(:,pd(1)),pom(:,pd(2)),pom(:,pd(3)),75,ncmap(min(100,max(1,round(poc*150))),:),'filled','^')
        
        % caxis([0 .6])
        % colormap jet
       xlabel(cnmvec{pd(1)});ylabel(cnmvec{pd(2)});zlabel(cnmvec{pd(3)});
        xlim([.1 .9]); ylim([.3 .75]); zlim([.1 .4])
        set(gca,'ydir','reverse')
        view(gca,[-107.6 17.9]); grid on
    case 2
        if ~exist('foi','var')
            foi = 15;
        end
        plot(pl(:,pd(1)),pl(:,pd(2)),cvc,'linewidth',2)
        % errorbar(prm(:,1),prm(:,2),prm(:,1)-prebl(),ypos,xneg,xpos)
        plot(prm(:,pd(1)),prm(:,pd(2)),'ko-','markersize',9)
        scatter(prm(:,pd(1)),prm(:,pd(2)),75,ncmap(min(100,max(1,round(prc*150))),:),'filled','o')
        
        plot(pom(:,pd(1)),pom(:,pd(2)),'k^-','markersize',9)
        scatter(pom(:,pd(1)),pom(:,pd(2)),75,ncmap(min(100,max(1,round(poc*150))),:),'filled','^')
        
        grid on
        xlabel(cnmvec{pd(1)});ylabel(cnmvec{pd(2)});
%         xlim([-1.2 1]); ylim([-.4 1.8]);
% xlim([.25 .7]); ylim([.25 .7])

end
