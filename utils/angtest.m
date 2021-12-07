arng = 10400:13550;
% show exisiting variables
figure(21);clf;hold all
stem(anvel(arng))
figure(12);clf; hold all
subplot 211; plot(slocc(arng,1),'.-')
subplot 212; plot(slocc(arng,2),'.-')

%% now perform velocity and ang velocity calculations
dts = 1; pidd = find(pid);
tm = tvec(pidd(arng));
init = floor(tm(1)); endt = ceil(tm(end));
oid = [];
for tti = 1:length(tm)
invec = [max(tm(1),(tm(tti)-dts/2)) min(tm(end),(tm(tti)+dts/2))];
oidx = findnearestneighbor(invec,tm);
sloco1 = slocc(oidx,:); % smoothed version of the cleaned location positions

% calculate instantaneous velocity
velx1(tti) = diff(sloco1(:,1))/dts;
vely1(tti) = diff(sloco1(:,2))/dts;

oid(tti,:) = oidx;
end

figure(13);clf; hold all; 
subplot 211; plot(velx1); hold all; plot(velx(arng))
subplot 212; plot(vely1); hold all; plot(vely(arng))

itr1 = 1097; itr2 = oid(itr1,1); itr3 = oid(itr1,2);
figure(14);clf; hold all
plot(slocc(arng,1),slocc(arng,2),'.-')
quiver(slocc(arng,1),slocc(arng,2),(velx(arng))',(vely(arng))')
plot(slocc(arng(1),1),slocc(arng(1),2),'ro')
plot(slocc(arng(40),1),slocc(arng(40),2),'mo')
plot(slocc(arng(90),1),slocc(arng(90),2),'go')
plot(slocc(arng(itr1),1),slocc(arng(itr1),2),'ko')
plot(slocc(arng(itr2),1),slocc(arng(itr2),2),'k*')
plot(slocc(arng(itr3),1),slocc(arng(itr3),2),'k^')
%% now calculate angular changes
tanval1 = [];
for ti = arng
    tanval1(ti) = atanwrap2(velx(ti),vely(ti));

end
figure(15);clf;hold all;
subplot 211; plot(tanval1(arng),'.-')

oid2 = arng(oid);
anvtst = [];
for ti = 1:length(arng)
    % invec = [max(time(1),(time(ti)-dts/2)) min(time(end),(time(ti)+dts/2))];
    % oidx = findnearestneighbor(invec,time);
    % dispx = diff(velx(oid(ti,:))); dispy = diff(vely(oid(ti,:)));
    atemp = (tanval1(oid2(ti,2))-tanval1(oid2(ti,1)))/dts;
    if abs(atemp)>180
        if atemp>0
            atemp = 360-atemp;
        elseif atemp<0
            atemp = -360-atemp;
        end
    end
    anvtst(ti) = atemp;
end
subplot 212; plot(anvtst,'.-')
hold all;plot(anvel(arng))
