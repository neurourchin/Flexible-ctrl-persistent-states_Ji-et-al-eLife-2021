%% load data at different time resolutions
dtst = [2 10 20 40 60]/2; dtn = length(dtst);
tpre = 720+1; tpost = 480+1;
if ~exist('ncmap','var')
    ncmap = jet(100);
end

varout = nsmtrigger_on(NTR,cdata,vdata,fidata,nsm_gmfit,tpre,tpost);
T_on = varout.tdon;
C_on = varout.cton;

cnm = length(T_on); trn = size(T_on(1).vals,1);
prg = prn(1):pon(end);

%%
dti = 5; % use 30s res
tres = 2;
foi = 30;
coi = [3 8 9];

% first exclude peri-NSMon data points from full dataset
npre = 60; npost = 660; % in .5s res
[~,cid] = max(nsm_gmfit(:,1));
trn = size(T_on(1).vals,1);
crn = size(C_on(1).vals,1);

    
    for ci = 1:3
        for ti = 1:trn
            tdat = T_on(ci).vals(ti,600:tpre);
            [~,ctmp] = tilingmean(1:length(tdat),tdat,tres);
            cprm{ci} = [cprm{ci} ctmp];
            
            tdat = T_on(ci).vals(ti,(tpre+1):end);
            [~,ctmp] = tilingmean(1:length(tdat),tdat,tres);
            cpom{ci} = [cpom{ci} ctmp];
        end
        
        for tci = 1:crn
            
            tdat = C_on(ci).vals(tci,(tpre+1):end);
            [~,ctmp] = tilingmean(1:length(tdat),tdat,tres);
            ctm{ci} = [ctm{ci} ctmp];
        end
    end

%%
figure(foi+5);clf; hold all
cxd = {ctm{1},cprm{1},cpom{1}}; cyd = {ctm{2},cprm{2},cpom{2}};

hs = schist_fun(cxd,cyd,[],[.05 .05]);
% scatter(ctm{1},ctm{2},18,'k','filled','markerfacealpha',ma,'markerfacealpha',ma)
