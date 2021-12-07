bstates = []; Bst = []; Bst2 = [];
for fi = unique(Fdx')
    fid = find(Fdx == fi);
    seq = seqs{fi};
    state = hmmviterbi(seq,estTR,estE);
    nca = Cdat(fid,1);
    vca = Vdat(fid);   
    bdat = state; 
    
    figure(2);clf;hold all
    subplot 211
    imagesc([1 length(nca)],0.5*[1 1],state); hold all
    caxis([1 3])
    plot(1:length(nca),(double(seq)-2)/2,'k','linewidth',1.5); hold all
    plot(1:length(nca),vca/prctile(vca,95)); hold all
    plot(1:length(nca),Xd(fid,1)/prctile(Xd(fid,1),95),'linewidth',1.5);
    set(gca,'ydir','normal','ylim',[-1.5 1.5])
    title([gtype ' File #' num2str(fi)])
    
    subplot 212
    imagesc([1 length(nca)],0.5*[1 1],bdat); hold all
    caxis([1 2])
    plot(1:length(nca),(double(seq)-2)/2,'k','linewidth',1.5); hold all
    plot(1:length(nca),nca/prctile(nca,95)); hold all
    set(gca,'ydir','normal','ylim',[-1.5 1.5])
    
    % check segmentation
    bstates{fi} = state;
    Bst = [Bst state];
    Bst2 = [Bst2 bdat];
    if ckflg
        [x,y] = ginput(1);
    else
        pause(.1)
    end
end