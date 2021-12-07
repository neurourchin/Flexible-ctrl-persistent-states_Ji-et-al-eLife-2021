function cmap = cmap_gen_flx(clrs,clz)    
cmap = [];
if length(clrs)==1
   clrs{2} = [1 1 1]; 
   cran1=cran_gen(clrs{1},clrs{2});  
   cmap = cran1;
else    
    for li = 1:(length(clrs)-1)
        cran1=cran_gen_flx(clrs{li},clrs{li+1},clz(li),clz(li+1));     
        cmap = [cmap;cran1];
    end
end
% map has 401 rows
% figure;imagesc(-100:40);colormap(cmap)