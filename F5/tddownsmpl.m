function [tmx,tds] = tddownsmpl(tdat,dst)
% dst - downsample interval in # data points
cnm = length(tdat);
tn = size(tdat(1).vals,1);
tl = size(tdat(1).vals,2);

clear tds
tds(1) = struct('vals',[],'fi',[]);
tx = 1:tl;
for ci = 1:cnm
    tds(ci).vals = [];
    for ti = 1:tn
        [tmx,ttmp] = tilingmean_ds(tx,tdat(ci).vals(ti,:),dst,-1);
        tds(ci).vals = [tds(ci).vals;ttmp];
    end
    
    tds(ci).fi = tdat(ci).fi;
end
% p