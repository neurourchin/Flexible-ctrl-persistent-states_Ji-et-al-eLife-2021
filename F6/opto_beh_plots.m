plclr = getstateclr; plclr = [plclr;.6*ones(1,3)];
fid = 46; pth = .0786;

for gi = 1:length(gztype)
    figure(fid+round(gi/2)-1);
    set(gcf,'outerposition',[138+round(gi/2)*200 614 214 308])
    if mod(gi,2)
        clf; hold all
        pclr = plclr(3,:);
        makepatch([45 235],[.1 .1],.1,'r',.1)
    else
        hold all
        pclr = plclr(1,:);
    end
    
    cdt = gc(gi).rp;
    % 1.average speed traces
    plot_bci([],cdt.rci,cdt.rmn,pclr,[],[])
    yrn = get(gca,'ylim');
    set(gca,'xlim',[0 size(opmat,2)])
    
    if mod(gi,2)
        pclr = plclr(3,:);
    else
        hold all
        pclr = plclr(2,:);
    end
    plot_bci([],cdt.dci,cdt.dmn,pclr,[],[])
    set(gca,'ylim',[0.005 0.13])
    yrn = get(gca,'ylim');
%     plot([15 75;15 75]*3,[yrn' yrn'],'k:','linewidth',1.5)
    set(gca,'xlim',[0 size(cdt.rmn,2)],'ytick',.02:.04:.14)
    plotstandard
    %% 2. compute percent roaming with bt errbars
    clear rfrc
    rdt1 = cdt.rmat(:,57); rdt2 = cdt.rmat(:,165);
    ddt1 = cdt.dmat(:,75); ddt2 = cdt.dmat(:,165);
    
    stz = bootstrp(100,@(x)sum(x>.05)/length(rdt1),rdt1);
    rfrc(1,:) = [mean(stz) prctile(stz,[2.5 97.5])];
    
    stz = bootstrp(100,@(x)sum(x>.05)/length(rdt1),rdt2);
    rfrc(2,:) = [mean(stz) prctile(stz,[2.5 97.5])];
    
    stz = bootstrp(100,@(x)sum(x>.05)/length(ddt1),ddt1);
    rfrc(3,:) = [mean(stz) prctile(stz,[2.5 97.5])];
    
    stz = bootstrp(100,@(x)sum(x>.05)/length(ddt1),ddt2);
    rfrc(4,:) = [mean(stz) prctile(stz,[2.5 97.5])];
    
    figure(fid+6+round(gi/2)-1);
        set(gcf,'outerposition',[138+round(gi/2)*200 304 214 308])
    bw = .23; mz = 5;
    if mod(gi,2)
        clf; hold all; pclr = plclr(3,:);
        bx = [1.15 2.15];
    else
        pclr = plclr(1,:);
        bx = [.85 1.85];
    end
    subplot 211; hold all
    bci = (rfrc(1:2,2:3))';
    bmn = (rfrc(1:2,1))';
    plot_bcibar(bx,bci,bmn,pclr,mz,[],bw,1)
    xlim([.3 2.7]); ylim([0 1])
    if gi>4; ylim([0 1]); end
        plotstandard
    
    if mod(gi,2)
        pclr = plclr(3,:);
    else
        pclr = plclr(2,:);
    end
    subplot 212; hold all
    bci = (rfrc(3:4,2:3))';
    bmn = (rfrc(3:4,1))';
    plot_bcibar(bx,bci,bmn,pclr,mz,[],bw,1)
    xlim([.3 2.7]); ylim([0 1])
        plotstandard
end