if ~exist('mlg','var')
    mlg = 30;
end

cnum = size(cdata,2);
for fgi = 1:length(fgtype)
    gtype = fgtype{fgi};
    load([savpath gtype '_alldata.mat'])
    fids = find(Fdx>0);

    cdata = Cdat(fids,:);
    % cdata = zscore(cdata,[],1);
    fidata = Fdx(fids);
    vdata = Vdat(fids);
    vlx = vax_clust(fids);
    vln = max(vlx);
    
    xcfsum = cell(cnum-1,cnum);
    for fi = (unique(fidata))'
        xdt = vdata(fidata == fi);
        cdt = cdata(fidata == fi,:);
        
        for ci = 1:(cnum-1)
            for ei = (ci+1):cnum
                inds = ~isnan(cdt(:,ci))&~isnan(cdt(:,ei));
                [xcf,lags] = crosscorr(cdt(inds,ci),cdt(inds,ei),mlg);
                xcfsum{ci,ei-1} = [xcfsum{ci,ei-1};xcf'];
            end
            
            inds = ~isnan(cdt(:,ci))&~isnan(xdt);
            [xcf,lags] = crosscorr(cdt(inds,ci),xdt(inds),mlg);
            xcfsum{ci,cnum} = [xcfsum{ci,cnum};xcf'];   
        end
    end
    
    gxf(fgi).xcf = xcfsum; gxf(fgi).lg = lags;
    gxf(fgi).gt = gtype;
end
%% compute and plot sum stats
hold all

for fgi = 1:fgl
    figure(fiid+fgi);clf;hold all
    for ci = 1:(cnum-1)
        for ei = ci:cnum
            xdat = gxf(fgi).xcf{ci,ei};
            if ~isempty(xdat)
                mxa = [];
                for xi = 1:size(xdat,2)
                    xa = xdat(:,xi); xa = xa(~isnan(xa));
                    mxa(xi) = mean(xa);
                    cxa(:,xi) = bootci(50,@mean,xa);
                end
                
                pli = (ci-1)*cnum+ei;
                subplot(cnum-1,cnum,pli); hold all
                
                plot(10*[-1 1],[0 0],'k-')
                plot([0 0],[-1 1]*.2,'k')
                xlim([-30 30]); ylim([-1 1]*.8)
                plotstandard
                set(gca,'yticklabel','','Xcolor', 'w', 'Ycolor', 'w')
                
                if fgi>1
                    pclr = [.65 0 .18];
                    plot_bci(lags,gxf(1).ci{ci,ei},gxf(1).mn{ci,ei},'k',[],[])
                end
%                 pclr = 'k';
                plot_bci(lags,cxa,mxa,pclr,[],[])
                
                
                gxf(fgi).mn{ci,ei} = mxa; gxf(fgi).ci{ci,ei} = cxa;
            end
        end
    end
end
