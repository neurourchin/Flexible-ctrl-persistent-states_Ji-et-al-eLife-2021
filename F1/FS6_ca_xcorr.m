%% inter-neuron xcorr
clear
setsavpath
DirLog

cnmvec = {'NSM','AIY','RIB','AVB','RME','RIA','ASI','AIA','AVA'};
%% computer wt as control
corder = [1 4 2 3 5 6 7 8 9 10];
lg = 30;
cn = length(corder);
wxcfsum = cell(cn-1,cn); wxcmean = wxcfsum; wxcse = wxcfsum;

gtype = 'wt';
load([savpath gtype '_alldata.mat'])
load([savpath gtype '_NSM_triggstat.mat'])
fids = find(Fdx>0);
ffi = unique(Fdx(fids));
cdata = Cdat(fids,:);
fidata = Fdx(fids);
vdata = Vdat(fids);

for fi = ffi'
    cdat = Cdat(Fdx==fi,:);    
    for c1 = 1:(cn-1)
        for c2 = (c1+1):cn
            co1 = corder(c1); co2 = corder(c2);
            inds = ~isnan(cdat(:,co1))&~isnan(cdat(:,co2));
            [xcf,lags] = crosscorr((cdat(:,co1))',(cdat(inds,co2))',lg);
             
                wxcfsum{c1,c2} = [wxcfsum{c1,c2};xcf];

                if ~isempty(xcf)
                mxa = [];
                for xi = 1:size(xdat,2)
                    xa = xdat(:,xi);
                    mxa(xi) = mean(xa(~isnan(xa)));
                    sxa(xi) = std(xa(~isnan(xa)))/sqrt(numel(xa));
                end
                
                wxcmean{ri,ci} = mxa;
                wxcse{ri,ci} = sxa;
                
            end
        end
    end
    clear caintp vaxintp cnames
end

figure(113);clf;hold all
    for ri = 1:(cn-1)
        for ci = (ri+1):(cn)
            xdat = wxcfsum{ri,ci};
            if ~isempty(xdat)
                mxa = [];
                for xi = 1:size(xdat,2)
                    xa = xdat(:,xi);
                    mxa(xi) = mean(xa(~isnan(xa)));
                    sxa(xi) = std(xa(~isnan(xa)))/sqrt(numel(xa));
                end
                
                wxcmean{ri,ci} = mxa;
                wxcse{ri,ci} = sxa;
                
                cpi = (cn-1)*(ri-1)+ci-1;
                subplot((cn-1),(cn-1),cpi); cla;hold all
                plot([0 0],[-1 1],':','linewidth',1,'color',.35*ones(1,3))
                plot([-lg lg],[0 0],':','linewidth',1,'color',.35*ones(1,3))

                if strcmp(gtype,'wt')
                    errorbar(lags,mxa,sxa,'.','color',[0.7 0.7 1])
                    plot(lags,mxa,'b','linewidth',1)
                else
                    errorbar(lags,mxa,sxa,'.','color',[1 0.7 0.7])
                    plot(lags,mxa,'r','linewidth',1)
                end
                plotstandard
                set(gca,'ylim',[-.7 .7],'ytick',-.5:.5:.5,'yticklabel','','xtick',-lg:lg:lg,'ticklength',.055*[1 1])
            end
        end
    end
%     set(gcf,'outerposition',[150 550 373 420])
%% muts
xcfsum = cell(cn-1,cn); xcmean = xcfsum; xcse = xcfsum;

gtype = 'tph1';
load([savpath gtype '_alldata.mat'])
load([savpath gtype '_NSM_triggstat.mat'])
fids = find(Fdx>0);
ffi = unique(Fdx(fids));
cdata = Cdat(fids,:);
fidata = Fdx(fids);
vdata = Vdat(fids);

for fi = ffi'
    cdat = Cdat(Fdx==fi,:);    
    for c1 = 1:(cn-1)
        for c2 = (c1+1):cn
            co1 = corder(c1); co2 = corder(c2);
            inds = ~isnan(cdat(:,co1))&~isnan(cdat(:,co2));
            [xcf,lags] = crosscorr((cdat(:,co1))',(cdat(inds,co2))',lg);
             
                xcfsum{c1,c2} = [xcfsum{c1,c2};xcf];

                if ~isempty(xcf)
                mxa = [];
                for xi = 1:size(xdat,2)
                    xa = xdat(:,xi);
                    mxa(xi) = mean(xa(~isnan(xa)));
                    sxa(xi) = std(xa(~isnan(xa)))/sqrt(numel(xa));
                end
                
                xcmean{ri,ci} = mxa;
                xcse{ri,ci} = sxa;
                
            end
        end
    end
    clear caintp vaxintp cnames
end

figure(113);hold all
    for ri = 1:(cn-1)
        for ci = (ri+1):(cn)
            xdat = xcfsum{ri,ci};
            if ~isempty(xdat)
                mxa = [];
                for xi = 1:size(xdat,2)
                    xa = xdat(:,xi);
                    mxa(xi) = mean(xa(~isnan(xa)));
                    sxa(xi) = std(xa(~isnan(xa)))/sqrt(numel(xa));
                end
                
                xcmean{ri,ci} = mxa;
                xcse{ri,ci} = sxa;
                
                cpi = (cn-1)*(ri-1)+ci-1;
                subplot((cn-1),(cn-1),cpi); hold all
                plot([0 0],[-1 1],':','linewidth',1,'color',.35*ones(1,3))
                plot([-lg lg],[0 0],':','linewidth',1,'color',.35*ones(1,3))

                if strcmp(gtype,'wt')
                    errorbar(lags,mxa,sxa,'.','color',[0.7 0.7 1])
                    plot(lags,mxa,'b','linewidth',1)
                else
                    errorbar(lags,mxa,sxa,'.','color',[1 0.7 0.7])
                    plot(lags,mxa,'r','linewidth',1)
                end
                plotstandard
                set(gca,'ylim',[-.7 .7],'ytick',-.5:.5:.5,'yticklabel','','xtick',-lg:lg:lg,'ticklength',.055*[1 1])
            end
        end
    end
    set(gcf,'outerposition',[150 350 559 622])

%% save data
% savpath = 'C:\Users\turbotrack\Dropbox (MIT)\PD work\Presentations\Data\';
save([savpath gtype '_nn_xcorr.mat'],'lags','xcfsum','xcmean','xcse','wxcfsum','wxcmean','wxcse')
% savpath2 = 'C:\Users\turbotrack\Dropbox (MIT)\PD work\Presentations\Data plots\';
figure(113);
saveas(gcf,[savpath2 gtype '_nnxcorr.fig'])
saveas(gcf,[savpath2 gtype '_nnxcorr.tif'])
saveas(gcf,[savpath2 gtype '_nnxcorr.eps'],'epsc')