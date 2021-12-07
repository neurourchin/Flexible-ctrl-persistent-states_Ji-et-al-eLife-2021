DirLog
setsavpath
cnmvec = {'NSM','AIY','RIB','AVB','RME','RIA','ASI','AIA','AVA','RIF'};

fgtype = {'wtf','tph1','mod1','pdfr1','pdfracy1','tph1pdfr1'};
svon = 0;
%%
fiid = 80; 
mlg = 30; % max lag
gxf = struct('xcf',[],'lg',[],'mn',[],'ci',[],'gt',[]);

ca_vaxcorr

%%
if svon
    savname = ['cavxcorr'];
    saveas(gcf,[savpath2 savname '.tif'])
    saveas(gcf,[savpath2 savname '.fig'])
    saveas(gcf,[savpath2 savname '.eps'],'epsc')
    
end
