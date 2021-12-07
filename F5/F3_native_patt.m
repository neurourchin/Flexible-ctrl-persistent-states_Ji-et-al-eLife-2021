ci1 = 3; ci2 = 8;
figure(53); clf; hold all
subplot 211; hold all
% cd1 = C_on(ci1).vals; cd1 = cd1(:);
% cd2 = C_on(ci2).vals; cd2 = cd2(:);
cd1 = TD_on(ci1).vals(:,200:5:300); cd1 = cd1(:);
cd2 = TD_on(ci2).vals(:,200:5:300); cd2 = cd2(:);
scatter(cd1,cd2,'filled')
cd1 = TD_on(ci1).vals(:,460:5:480); cd1 = cd1(:);
cd2 = TD_on(ci2).vals(:,460:5:480); cd2 = cd2(:);
scatter(cd1,cd2,'filled')
xlim([-.2 1.3]); ylim([0 1.3])

subplot 212
cd1 = TD_on(ci1).vals(:,460:5:480); cd1 = cd1(:);
cd2 = TD_on(ci2).vals(:,460:5:480); cd2 = cd2(:);
scatter(cd1,cd2)
xlim([-.2 1.3]); ylim([0 1.3])
%%
tr1 = 11:16; tr2 = 13:16;
figure(53); clf; hold all
subplot 211; hold all
% cd1 = C_on(ci1).vals; cd1 = cd1(:);
% cd2 = C_on(ci2).vals; cd2 = cd2(:);
% scatter(cd1,cd2)
cd1 = CTs(ci1).vals(:,tr1); cd1 = cd1(:);
cd2 = CTs(ci2).vals(:,tr1); cd2 = cd2(:);
scatter(cd1,cd2,'filled')
cd1 = TDs(ci1).vals(:,tr2); cd1 = cd1(:);
cd2 = TDs(ci2).vals(:,tr2); cd2 = cd2(:);
scatter(cd1,cd2,'filled')
xlim([-.2 1.3]); ylim([0 1.3])

subplot 212
cd1 = TDs(ci1).vals(:,tr2); cd1 = cd1(:);
cd2 = TDs(ci2).vals(:,tr2); cd2 = cd2(:);
scatter(cd1,cd2)
xlim([-.2 1.3]); ylim([0 1.3])