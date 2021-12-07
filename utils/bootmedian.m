function bci = bootmedian(bn,bdat)
ops = statset('UseParallel',true); clrs = getstateclr;
bci = bootci(bn,{@nanmedian,bdat},'Options',ops);
