function mout = matsmooth(main,dim,sw,dr)
switch dim
    case 1
        mc = main'; 
    case 2
        mc = main;
end
ml = size(mc,1);

mo = nan(ml,size(mc,2));
parfor mi = 1:ml
    cmn = slidingmean([],mc,sw,dr);
    mo(mi,:) = cmn;
end

switch dim
    case 1
        mout = mo;
    case 2
        mout = mo;
end