zl = size(ozmat,1);
pri = prt*3; pei = (60+prt)*3;
oldur = nan(1,zl);
for zi = 1:zl
    %%
%     zi = 710;
    cdt = ozmat(zi,pri:pei);
    ws1 = (.06); ws2 = ((.6*ozpre(zi)));
    wth = mean([ws1,ws2]);
    cdb = cdt<wth; cdb2 = cdt<mean([.08,(.8*ozpre(zi))]);
    cdbc = (cdb+cdb2)>0;
    cdd = imclose(cdbc,strel('rectangle',[1 7]));
    ac = regionprops(cdd,'PixelIdxList','Area');
    if ~isempty(ac)
    if ac(1).PixelIdxList(1)<30
        oldur(zi) = ac(1).Area;
    else
        oldur(zi) = -(1/zi);
    end
    else
        oldur(zi) = -(1/zi);
    end
%     figure(2);plot(cdt)
%     figure(5);imagesc(cdd)
end
%% sort and compute average
ni = find(isnan(oldur)); nni = find(~isnan(oldur));
[~,osd] = sort(oldur(nni),'ascend');
osmat = ozmat(nni(osd),:);
onmat = ozmat(ni,:);
plmat = [onmat;osmat];
opm = cal_matmean(ozmat,1,1);

%% plotting
if ~exist('fgid','var')
    fgid = 120;
end
figure(fgid);clf; hold all
subplot(4,1,1)
plot_bci([],opm.ci,opm.mean,[0 0 1],[],[])
xlim([0 length(opm.mean)]); ylim([.045 0.135])
plot([45 45],get(gca,'ylim'),'k')
plot([231 231],get(gca,'ylim'),'k')

subplot(4,1,2:3)
plmat = plmat(end:-1:1,:);
imagesc(plmat)
hold all
plot([45 45],get(gca,'ylim'),'k')
plot([231 231],get(gca,'ylim'),'k')
caxis([0 .15])

% compute histogram for 56-60/3 s and 111-115/3 s
subplot(4,1,4); hold all
pdt = ozmat(:,44); pdt1 = pdt(:);
pd = fitdist(pdt1,'Kernel');
x = 0:.0025:.2;
y = pdf(pd,x);
plot(x,y,'linewidth',1.5)

pdt = ozmat(:,57); pdt2 = pdt(:);
pd = fitdist(pdt2,'Kernel');
y = pdf(pd,x);
plot(x,y,'linewidth',1.5)

pdt = ozmat(:,105); pdt3 = pdt(:);
pd = fitdist(pdt3,'Kernel');
y = pdf(pd,x);
plot(x,y,'linewidth',1.5)