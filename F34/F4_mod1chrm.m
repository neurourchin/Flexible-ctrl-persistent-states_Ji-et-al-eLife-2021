setsavpath
addpath(genpath('C:\Users\cm\Dropbox\PD work\Matlab\'))
gztype = {'mod1chrm','mod1chrm_pdfr1'};
svon = 0;
opdir = 'C:\Users\cm\Dropbox\PD work\Presentations\BehData\';
%% parse stim params
% [stimfile,opdir]=uigetfile('*.stim', 'Specify stim file:', bpath);
stimfile = 'RIFAIY_acute_longterm.stim';
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
plclr = {.6*ones(1,3),.1*ones(1,3),.6*ones(1,3),[0 0 .8]};
cls1 = getstateclr;
cls0 = .5*ones(2,3); cls00 = .1*ones(2,3);
cls2 = [.9 .6 .1;0 .5 .8];
fid = 28; pth = .065;
opr = 30; opst = 90;

for gi = 1:length(gztype)
    figure(fid+round(gi/2)-1);
    set(gcf,'outerposition',[8+(round(gi/2)-1)*200 540 176 192])
    if mod(gi,2)
        clf; hold all
        makepatch((opr+[0 60])*3,[.1 .1],.1,'r',.2)
        clset = cls0;
    else
        hold all
        clset = cls1;
    end
    ls = '-';
    
    ofname = [bpath gztype{gi} '_fulbd.mat'];
    load(ofname)
    binsize = 30;
    fnum = 10800;
    
    op_disc_f2
    
%     if gi==1; wpm1 = opm1; wpm2 = opm2; end
 
end
%% save plots
if svon
        figure(fid+round(gi/2)-1);
        savname = [gztype{gi} '_mod1chrm'];
        saveas(gcf,[savpath2 savname '.tif'])
        saveas(gcf,[savpath2 savname '.fig'])
        saveas(gcf,[savpath2 savname '.eps'],'epsc')
end