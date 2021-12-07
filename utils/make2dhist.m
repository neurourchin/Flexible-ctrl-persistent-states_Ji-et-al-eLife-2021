function hh = make2dhist(hx,hy,bn)
if length(bn)==1
    hh = histogram2(hx,hy,bn,'FaceColor','flat',...
        'DisplayStyle','tile','ShowEmptyBins','on');
else
    hh = histogram2(hx,hy,bn{1},bn{2},'FaceColor','flat',...
        'DisplayStyle','tile','ShowEmptyBins','on');
end
hh.EdgeColor = 'none';
xlim(hh.XBinEdges([1 end]))
ylim(hh.YBinEdges([1 end]))