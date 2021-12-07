setsavpath
addpath(genpath('C:\Users\cm\Dropbox\PD work\Matlab\'))
gztype = {'mod1chrmN2ctrl' 'mod1chrm','mod1chrm_pdfr1'};
svon = 0;
opdir = [dbpath '\PD work\Presentations\BehData\'];
%% parse stim params
% [stimfile,opdir]=uigetfile('*.stim', 'Specify stim file:', bpath);
stimfile = 'power_titrate_blue_green_large19_noG.stim';
stim = load_stimfile([opdir,stimfile]);

parsestim
%%
plclr = {.6*ones(1,3),.1*ones(1,3),.6*ones(1,3),[0 0 .8]};
cls1 = getstateclr;
cls0 = .65*ones(2,3); cls00 = .1*ones(2,3);
cls2 = [.9 .6 .1;0 .5 .8];
clsf = {cls0,cls00,cls1};
fid = 28; pth = .065;
opr = 30; opst = 90;

for gi = 1
    figure(fid);
    set(gcf,'outerposition',[8+(round(gi/2)-1)*200 540 176 192])
        clf; hold all
        makepatch((opr+[0 60])*3,[.1 .1],.1,'r',.2)
        clset = clsf{gi};

    ls = '-';
    
    ofname = [bpath gztype{gi} '_fulbd.mat'];
    load(ofname)
    binsize = 30;
    fnum = 10800;
    
    op_disc_f2 
end
%% parse stim params
% [stimfile,opdir]=uigetfile('*.stim', 'Specify stim file:', bpath);
stimfile = 'RIFAIY_acute_longterm.stim';
stim = load_stimfile([opdir,stimfile]);

parsestim
%%
plclr = {.6*ones(1,3),.1*ones(1,3),.6*ones(1,3),[0 0 .8]};
fid = 28; pth = .065;
opr = 30; opst = 90;

for gi = length(gztype)
    figure(fid);
        hold all
        clset = clsf{gi};
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