% Visualize and evaluate trained networks
hset = reshape(hfilt,size(hfilt,1)*size(hfilt,2),size(hfilt,3)*size(hfilt,4));
hset = permute(hset,[2 1]);
eva = evalclusters(hset,'kmeans','calinski','klist',1:6);
clix = kmeans(hset,eva.OptimalK);

knm = max(clix); csize = zeros(1,knm);
for cli = 1:knm
csize(cli) = length(find(clix==cli));
end
[cln,crk] = sort(csize,'descend');
crk(cln<3) = [];

% % lpi = 1;
% % for cli = crk
% %     hcl = hset(clix == cli,:);
% %     hctmp = mean(hcl,1);
% %     hcm{lpi} = reshape(hctmp,size(hfilt,1),size(hfilt,2));
% %     ctmp = bootci(100,@nanmean,hcl);
% %     hclo{lpi} = hcm{lpi}-reshape(ctmp(1,:),size(hfilt,1),size(hfilt,2));
% %     hchi{lpi} = reshape(ctmp(2,:),size(hfilt,1),size(hfilt,2))-hcm{lpi};
% %     lpi = lpi+1;
% % end
