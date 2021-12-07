gi = 1; ws = 11; fi = 9;
cnl = {'NSM','AIA','AVA'};

Cnm = cell(1,10);
Cdn = Cnm;
Cdf = Cnm;
Crt = Cnm;
Cor = Cnm;

fd = dir([fpath '*_exp.mat']);
load([fpath fd(1).name])
coi = [];
for ci = 1:length(cnl)
    for cti = 1:10
        tf = strcmp(cnames{cti},cnl{ci});
        if tf
            coi = [coi cti];
            break
        end
    end
end
for ci = coi
    cg = caexp_g{ci};
    Cor{ci} = cg-prctile(cg,1);
    ct = caexp_g{ci}./caexp_r{ci};
    Crt{ci} = ct-prctile(ct,1);
    Cdf{ci} = diff(ct(1:10:end));
    Cnm{ci} = (ct-prctile(ct,1))/diff(prctile(ct,[1 99]));
end
%
xrz = {[-.5 8],[-.2 1.5],[-.3 3.2]};
cp = 1;
for ci = coi
    figure(60+ci);clf;hold all
    setfigsiz([22+(ci*100) 366 180 356])
    subplot 311;cla; hold all
    kfhist(Cor{ci},30,[],[0 .8 0])
    plotstandard
    set(gca,'xlim',xrz{cp},'ylim',[0 .2],'ytick',0:.1:.2,'yticklabel','')
    
    subplot 312;cla; hold all
    kfhist(Crt{ci},30,[],.4*[1 1 0])
    plotstandard
    set(gca,'xlim',xrz{cp},'ylim',[0 .2],'ytick',0:.1:.2,'yticklabel','')
    
    subplot 313;cla; hold all
    kfhist(Cnm{ci},30,[],[.8 .5 0])
    plotstandard
    set(gca,'xlim',[-.1 1.2],'ylim',[0 .2],'ytick',0:.1:.2,'yticklabel','')
    cp = cp+1;
end