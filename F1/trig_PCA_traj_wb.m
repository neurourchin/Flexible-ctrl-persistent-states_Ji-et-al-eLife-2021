bnm = 50; dt = 30;
tpre = 240; tpost = 900;
if ~exist('ncmap','var')
    ncmap = jet(100);
end

varout = nsmtrigger_on(NTR,smcore,vdata,fidata,nsm_gmfit,tpre,tpost);
P_on = varout.tdon;

varout = nsmtrigger_on(NTR,cdata,vdata,fidata,nsm_gmfit,tpre,tpost);
T_on = varout.tdon;

figure(foi); clf;
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

bn = size(T_on(1).vals,1);

for bi = 1:bnm
    tinds = randsample(bn,100,true);
    for ti = 1:size(tinds)
        tbi = tinds(ti);
        trig_avg_wb
    end
    
    prm = nanmean(predat,1); pom = nanmean(posdat,1);
    prm = squeeze(prm); pom = squeeze(pom);
    pl = [prm;pom];
    prc = nanmean(preca,1); poc = nanmean(posca,1);
    plc = [prc poc];

    pset = [predat posdat];
    pop = 2;
    
    figure(foi); hold all
    
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

            px = pl(:,1); py = pl(:,2);
            pclr = ncmap(min(100,round(plc*150)),:);
            pu = diff(px); pv = diff(py);
            
            for qi = 1:length(pu)
                hold all
                ctmp = pclr(qi,:);
                cpc = ones(1,3)-(.3*(ones(1,3)-ctmp));
                plot(px([qi qi+1]),py([qi qi+1]),'color',cpc);
            end
    end
    
    TB.px(bi,:) = px; TB.py(bi,:) = py;
    TB.pu(bi,:) = pu; TB.pv(bi,:) = pv;
    TB.pcl(:,:,bi) = pclr;
    
    %             xlim([-2 2]); ylim([-1.5 2.5])
    
end

%%
mpx = median(TB.px,1); mpy = median(TB.py,1); mplc = median(TB.pcl,3);
mpu = diff(mpx); mpv = diff(mpy);
% pclr = ncmap(round(mplc*150),:);
psz = sqrt(mpu.^2+mpv.^2);
for qi = 1:length(mpu)
    hold all
    q=quiver(mpx(qi),mpy(qi),mpu(qi),mpv(qi));
%     ctmp = pclr(qi,:);
    q.Color = mplc(qi,:);
    q.MaxHeadSize = .5*1.2/psz(qi);
    q.AlignVertexCenters = 'on';
    q.LineWidth = 1.5;
end

grid on
xlabel('PC1');ylabel('PC2');
xlim([-1.3 1.2]); ylim([-.5 2]);
axis square
%% save data for direct plotting
% % saveas(gcf,[savpath2 gtype '_statetranspca.tif'])
% % saveas(gcf,[savpath2 gtype '_statetranspca.fig'])
% % saveas(gcf,[savpath2 gtype '_statetranspca.eps'],'epsc')
% %
save([savpath gtype '_statetrans_PCAboot.mat'],'T_on','P_on','tpre','tpost','TB','dt')