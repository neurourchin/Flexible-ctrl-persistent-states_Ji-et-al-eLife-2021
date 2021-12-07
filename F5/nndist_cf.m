bn = 100; pmt = nan(1,length(cset));
cp = 1;
for ci = cset
    ctx = CTs(ci).vals(:,crg);
    cln = numel(ctx);
    x0 = tdgp(ci).gp(end).dat(:); xln = numel(x0);
    dbm = nan(bn,2);
    for bi = 1:bn
        di1 = datasample(1:xln,round(xln/4));
        di2 = datasample(1:cln,round(cln/4));        
        dbm(bi,:) = [mean(x0(di1)),mean(ctx(di2))];     
    end
    [~,rp] = multicomp_bt(dbm(:,1),dbm(:,2));
    pmt(cp) = rp;
    cp = cp+1;
end


fdrp = mafdr(pmt,'BHFDR',true);
%%
[pmt;fdrp]