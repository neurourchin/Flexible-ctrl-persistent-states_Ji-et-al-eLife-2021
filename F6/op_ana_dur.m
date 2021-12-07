% aggregate speed traces into one matrix and plot individual speed and angular speed traces
if ~exist('fnum','var')
    fnum = 10800;
end
flen = length(ftrk);
spmat = nan(flen,fnum); apmat = spmat;

for fi = 1:flen
    frms = ftrk(fi).Frames; fspd = ftrk(fi).Speed;
    fasp = abs(ftrk(fi).AngSpeed); fst = ftrk(fi).State;
    fx = ftrk(fi).SmoothX; fy = ftrk(fi).SmoothY;
    spmat(fi,frms) = fspd; apmat(fi,frms) = fasp;
end
%% convert spmat into select windows flanking each stimuli (10s before and after),
% sort into separate matrices (same width) based on stim intensity
opdat = struct('spd',[],'mspd',[],'anp',[],'manp',[]);
if ~exist('ls','var')
    ls = '-';
end

prt = 15; pst = 15;
for ti = 1:length(ontim)
    opb = (ontim{ti}-prt)*3; opa = (offtim{ti}+pst)*3; % 10s before stim onset and 10s after stim offset
    opmat = []; oamat = []; oppre = [];
    for oti = 1:length(opb)
        if opa(ti)<=size(spmat,2)
            opmat = [opmat;spmat(:,(opb(oti):opa(oti)))];
            oamat = [oamat;apmat(:,(opb(oti):opa(oti)))];
        end
    end
    
    % gather average speeds in 3s bins
    cm = 6;
    ol = size(opmat,1);
    ommat = nan(size(opmat));
    for oi = 1:ol
        otmp = slidingmean([],opmat(oi,:),cm,-1);
        ommat(oi,:) = otmp;
        oppre(oi) = nanmedian(ommat(oi,(-9:9)+(prt*3))); % 3s pre stim
    end
    %% analyze roaming animals
    ki = find(oppre>.05);
    ozmat = ommat(ki,:);
    [~,ord] = sort(oppre(ki));%(ommat(:,28));
    optmp = oppre(ki);
    ozpre = optmp(ord);
    ozmat = ozmat(ord,:);

    fgid = 120+5*(gi-1);
    cal_spd_emb1
    fdt.rmat = ozmat; fdt.rpmat = plmat;
    fdt.rmn = opm.mean; fdt.rci = opm.ci;
    fdt.sldur = oldur;
    fdt.lpdt = [pdt1 pdt2 pdt3];
    %% analyze dwelling animals
    ki = find(oppre<.05);
    ozmat = ommat(ki,:);
    [~,ord] = sort(oppre(ki));%(ommat(:,28));
    optmp = oppre(ki);
    ozpre = optmp(ord);
    ozmat = ozmat(ord,:);

    fgid = 123+5*(gi-1);
    cal_spd_emb2
    fdt.dmat = ozmat; fdt.dpmat = plmat;
    fdt.dmn = opm.mean; fdt.dci = opm.ci;
    fdt.spr = oprt;
    fdt.ppdt = [pdt1 pdt2 pdt3];
end