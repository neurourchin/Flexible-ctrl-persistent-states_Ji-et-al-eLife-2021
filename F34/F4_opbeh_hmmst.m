setsavpath

gztype = {'mod1chrm','mod1chrm_pdfr1'};
svon = 0;
%%
binsize = 30;
for gi = 1:length(gztype)
    
    ofname = [bpath gztype{gi} '_fulbd.mat'];
    load(ofname)
    
        [NewSeq,States,trans,emis] = getHMMStates(ftrk,binsize);
    
   save([bpath gztype{gi} '_fulbd.mat'],'States','trans','emis','NewSeq','-append')     
 
end
