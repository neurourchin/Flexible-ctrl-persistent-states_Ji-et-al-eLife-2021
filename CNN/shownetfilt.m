function shownetfilt(cnet,lyi,fn,fid,nmb)
figure(fid);clf;hold all
for fi = 1:fn
subplot(1,fn,fi); 
cfilt = cnet.Layers(lyi).Weights(:,:,1,fi);
if nmb
    cfilt = cfilt/median(abs(cfilt(:)));
end
imagesc(cfilt)
end
colormap jet