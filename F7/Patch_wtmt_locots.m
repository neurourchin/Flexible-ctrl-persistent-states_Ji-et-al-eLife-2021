setsavpath

gztype = {'wt','wtld'};
% gztype = {'aiaunc','aiald'};
svon = 0;
%% plot wt against ld ctrl
pclr = {.14*[1 1 1],.6*[1 1 1]};
mw = 20; dth = 650; fst = 20; ds = 20; dx = 50;

fid = 38; fp = 1;

figure(fid); clf; hold all
for gi = [2 1]
    plclr = pclr{gi};
    mlclr = plclr;
    chdat = []; spdat = [];
    
    load([bpath gztype{gi} '_fuldata.mat'])
    toi = 1;
    state_trigg_gen
    
    % speed/state on LD (before xing) over time
    if gi==2
        figure(fid); clf; hold all
    end
    plot_trigg_f4(chxmat(1).ch,chxmat(2).ch,chxmat(3).ch,chxmat,plclr)
    
    fp = fp+1;
end

