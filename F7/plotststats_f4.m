bw = .5
figure(fid);clf;hold all
[bm,bci] = make_barplt([],bdat,clrs,fid,bw,2)

[bm,bci] = make_barplt([],{R1,R2},{clmat(2,:),clmat(1,:)},27,.6,1);
