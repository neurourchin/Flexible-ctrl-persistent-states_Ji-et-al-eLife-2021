setsavpath

gtype = {'wt','wtld','aiaunc','pdfr1','tax4'};
pclr = {.2*[1 1 1],[0 0 1],[.5 .5 0],[0.5 0 .5]};

%% combine data based on genotype and make plots
mw = 20; dsth = 500;
chrm = nan(1,length(gtype)); chrel = chrm; chreh = chrm;
ddm = []; ddc = []; ddful = cell(1,2);
cxdat = cell(1,length(gtype));

fi1 = 45;fi2 = fi1+1;fic = 41; fip = 42; fit = 43;

%
for gi = 1:length(gtype)
    
    chdat = []; xgt = [];
    plclr = pclr{gi};
      
    load([bpath gtype{gi} '_fuldata.mat'])
    
    
    % speed on LD (before xing) over time
    figure(fi2+max(0,gi-2)); clf; hold all
    if gi>1
        subplot 121; hold all
        plot_bci(wpid,[wplo;wphi],wpm,pclr{1},[],[])
        subplot 122; hold all
        plot_bci(wtid,[wtlo;wthi],wtm,pclr{1},[],[])        
    end
    spd_v_time
    
    if gi==1
        wpid = spid; wplo = spclm; wphi = spchm; wpm = spdmm;
        wtid = spid2; wtlo = spclm2; wthi = spchm2; wtm = spdmm2;
    end

end
%