setsavpath

gtype = {'wt','wtld'};
% pclr = {.2*[1 1 1],[0 0 1],[.5 .5 0],[0.5 0 .5]};
%% combine data based on genotype and make plots
pclr = {.24*[1 1 1],.7*[1 1 1]};
mclr = {.6*[1 1 1],.5*[0 1 0],.5*[1 0 1],[.64 .08 .18]};

mw = 20; dsth = 500;
chrm = nan(1,length(gtype)); chrel = chrm; chreh = chrm;
ddm = []; ddc = []; ddful = cell(1,2);

fi1 = 40;fi2 = fi1+1;fic = 41; fip = 42; fit = 43;

%
for gi = 1:length(gtype)
        
    chdat = []; xgt = [];
    plclr = pclr{gi};
    mlclr = mclr{gi};
      
    load([bpath gtype{gi} '_fuldata.mat'])
    
    % speed on LD (before xing) over time
    figure(fi2+max(0,gi-2)); clf; hold all
    if gi>1
        bx = 1;
        plot_bcibar(bx,wtci,wtm,pclr{1},[],[],bw,1)
    end
    bx = 2;
    mnst_bplt
    set(gcf,'outerposition',[100 761-max(0,gi-2)*200 145 220])
    
    if gi==1
        wtm = stm; wtci = stci;
    end

    
end
