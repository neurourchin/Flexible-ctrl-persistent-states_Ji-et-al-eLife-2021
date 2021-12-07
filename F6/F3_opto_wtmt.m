setsavpath

gztype = {'WT_noATR','WT_ATR','tph-1_noATR','tph-1_ATR','pdfr1_noATR','pdfr1_ATR'};
expn = 'AIAChrim_';
%% parse stim params
[stimfile,opdir]=uigetfile('*.stim', 'Specify stim file:', bpath);
stim = load_stimfile([opdir,stimfile]);

opon = stim(:,1); opoff = stim(:,2); % stim on off times
scn = stim(:,3); % number of stim wavelengths
sint = stim(:,4); % stim intensity for each epoch
ilvl = unique(sint); % unique stim intensitites
inum = length(ilvl); % number of different stim intensitites

ontim = cell(1,inum); offtim = ontim; opfr = ontim;
for oi = 1:inum
    curint = ilvl(oi);
    curidx = find(sint == curint);
    ontim{oi} = opon(curidx); offtim{oi} = opoff(curidx);
    for oti = 1:length(curidx)
        optmp = (ontim{oi}(oti)*3):(offtim{oi}(oti)*3);
        opfr{oi} = [opfr{oi} optmp];
    end
end

%%
plclr = {.65*ones(1,3),.1*ones(1,3),.65*ones(1,3),[0 0 .8]};
cls1 = getstateclr;
cls0 = .65*ones(2,3); cls00 = .1*ones(2,3);
cls2 = [.9 .6 .1;0 .5 .8];
fid = 28; pth = .067;

for gi = 1:2%(length(gztype)-1):length(gztype)
    figure(fid+round(gi/2)-1);
    set(gcf,'outerposition',[8+(round(gi/2)-1)*200 540 176 276])
    if mod(gi,2)
        clf; hold all
        makepatch([30 210],[.1 .1],.1,'r',.1)
        clset = cls0;
    else
        hold all
        clset = cls1;
    end
    ls = '-';
    
    ofname = [bpath expn gztype{gi} '_fulbd.mat'];
    load(ofname)
    disp([gztype{gi} num2str(length(ftrk))])
    binsize = 30;
    fnum = 10800;
    
    op_disc_f3
    
    if gi==2; wpm1 = opm1; wpm2 = opm2; end
    if gi==3
        ls = ':';
        plot_bci([],wpm1.ci,wpm1.mean,cls00(1,:),[],ls)
        plot_bci([],wpm2.ci,wpm2.mean,cls00(2,:),[],ls)
    end
end
