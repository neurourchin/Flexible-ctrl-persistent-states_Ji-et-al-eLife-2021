% aggregate speed traces into one matrix and plot individual speed and angular speed traces
if ~exist('fnum','var')
    fnum = 10800;
end

flen = length(ftrk);
spmat = nan(flen,fnum); apmat = spmat; stmat = spmat;

for fi = 1:flen
    frms = ftrk(fi).Frames; fspd = ftrk(fi).Speed; fasp = abs(ftrk(fi).AngSpeed);
    fst = States(fi).states;
    fx = ftrk(fi).SmoothX; fy = ftrk(fi).SmoothY;
    fl = min(length(frms),length(fst));
    spmat(fi,frms) = fspd; apmat(fi,frms) = fasp; stmat(fi,frms(1:fl)) = fst(1:fl);
end
%% convert spmat into select windows flanking each stimuli (10s before and after),
% sort into separate matrices (same width) based on stim intensity
opdat = struct('spd',[],'mspd',[],'anp',[],'manp',[]);
if ~exist('ls','var')
    ls = '-';
end
for oi = 1:length(ontim)
    opb = (ontim{oi}-opr)*3; opa = (offtim{oi}+opst)*3; % 1min before stim onset and 10s after stim offset
    opmat = []; oamat = []; otmat = [];
    for oti = 1:length(opb)
        if opa(oi)<=size(spmat,2)
            opmat = [opmat;spmat(:,(opb(oti):opa(oti)))];
            oamat = [oamat;apmat(:,(opb(oti):opa(oti)))];
            otmat = [otmat;stmat(:,(opb(oti):opa(oti)))];
        end
    end
    
    % sort by speed 0-5s before stim
    oppre = nanmean(opmat(:,20:90),2); % speed ~3s before stim onset
    oppos = nanmean(opmat(:,30:60),2); % speed ~6-9s after
    oplat = nanmean(opmat(:,150:180),2);
    oki = find(~isnan(oppre));
    oppre = oppre(oki); oppos = oppos(oki); oplat = oplat(oki);
    opmat = opmat(oki,:); otmat = otmat(oki,:);
    ort = oppos./oppre;
    
    ki = find(oppre<pth);

    ozmat = opmat(ki,:);
    opm2 = cal_matmean(ozmat,1,1);
    [~,ord] = sort(oppre(ki));
    plot_bci([],opm2.ci,opm2.mean,clset(2,:),[],ls)
    fln = length(opm2.mean);
    plotstandard
    set(gca,'xlim',[0 fln],'xtick',[0 (opr*3):180:fln],...
        'ylim',[0.01 .065],'ytick',0:.025:.05,'yticklabel','')
end