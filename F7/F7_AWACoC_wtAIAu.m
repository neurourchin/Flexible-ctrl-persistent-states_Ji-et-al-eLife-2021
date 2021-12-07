setsavpath
% addpath(genpath('C:\Users\cm\Dropbox\PD work\Matlab\'))
gztype = {'AWACoC_noATR','AWACoC','AWACoC_AIAunc'};
svon = 0;
opdir = 'C:\Users\Ni Ji\Google Drive\Opto exp\';
%% parse stim params
% [stimfile,opdir]=uigetfile('*.stim', 'Specify stim file:', bpath);
stimfile = 'CB_1MinStims_102319.stim';
stim = load_stimfile([opdir,stimfile]);

parsestim
%%
plclr = {.6*ones(1,3),.1*ones(1,3),.6*ones(1,3),[0 0 .8]};
clsf = {.6*[1 1 1],.16*ones(1,3),.5*[0 1 0]};

fid = 28; pth = .025;
opr = 30; opst = 90;
figure(fid);clf;hold all
makepatch((opr+[0 60])*3,[.1 .1],.1,'r',.2)
for gi = 1:length(gztype)
    
    set(gcf,'outerposition',[8+(round(gi/2)-1)*200 540 176 192])
    
    cclr = clsf{gi};
    
    ls = '-';
    
    ofname = [bpath gztype{gi} '_fulbd.mat'];
    load(ofname)
    binsize = 30;
    fnum = 10800;
    
    op_disc_f4
    xlim([0 450])
end
