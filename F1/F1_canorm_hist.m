cn = length(cnmvec);
mp = 1;

Cdat = []; Tdat = []; Vdat = []; Fdx = []; Odat = [];

for di = 1:length(dpaths)
    clear vaxintp caexp_g ca_ratio catime
    datpath = dpaths{di};
    inf = dir([datpath '*exp.mat']);
    intfile = inf.name;
    load([datpath intfile])
    
    datr = caexp_g;%ca_ratio;
    cnum = length(datr);
    caint = [];
    cvec = 1:cnum; %cvec(10) = [];
    
    tvec = catime;
    
    for cid = cvec
        for cli = 1:cn
            if strcmp(cnames{cid},cnmvec{cli})
                catmp = datr{cid}; catmp(catmp<0) = nan;
                %                 caint(:,cli) = smooth(catmp,5);
%                 catmp = smooth(catmp,15);
                catmp = slidingmedian([],catmp,5,0);
                catp = (catmp-prctile(catmp,5))/(prctile(catmp,5));
                % dynamic range greater than 20% dr/r
                catp2 = (catmp-prctile(catmp,mp))/(prctile(catmp,(100-mp))-prctile(catmp,mp)); % 93-5
                if cli == 1&&(prctile(catp,98)<.2||prctile(catp2,98)<1)
                     caint(:,cli) = (catmp-prctile(catmp,mp));
                else
                    caint(:,cli) = catp2;
                end
                break
            end
        end
    end
    
    if size(caint,2)<cn
        caint(:,cn) = zeros(size(caint,1),1);
    end
    
    figure(3);clf;plot(caint); title(num2str(di))
    
%     [x,y] = ginput(1);
    if exist('vaxintp','var')
        va = smooth(vaxintp(1:size(caint,1)),13);
    else
        va = nan(length(catime),1);
    end
    %     caint(end,:)=[];
    %     va(end)=[];

    if exist('opcind','var')
        opvec = ones(length(va),1); opvec(opcind) = 2;
        Odat = [Odat;opvec];
    end
    
    Cdat = [Cdat;caint];
    Tdat = [Tdat;tvec(:)];
    Vdat = [Vdat;va(:)];
    Fdx = [Fdx;di*ones(length(va),1)];
    
% %     if di==6
% %         o
% %     end
figure(115);clf; hold all
subplot 211; hold all
yyaxis left; plot(caint(:,1))
yyaxis right; plot(va)
subplot 212; plot(tvec)
% [x,y,butt] = ginput(1);
% if butt~=1 % lmb
%     p
% end
end