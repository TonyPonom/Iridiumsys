function s = plotspred(r)
sp = zeros(2,r);
%pl=zeros(360,360);
%pl=[
%    ];
load('pl');
%potr=zeros(1,31);
potr=zeros(1,1453);
potr(1,1)=1;
for i=2:3%2:4
    potr(1,i)=2; 
end
for i=4:53%5:10
    potr(1,i)=3;
end
for i=54:253%11:19
    potr(1,i)=4;
end
for i=254:1453%25:31
    potr(1,i)=5;
end
for i = 1:r
    ind=true;
    while ind
        %KR=round(rand*(30))+1;
        KR=round(rand*(1452))+1;
        R=rand;
        Lat=(asin(2*R-1)*180)/pi; % Широта в градусах
        lon=R*360;
        if(lon==0)
            lon=360;
        end
        KLat=fix(Lat);
        if(KLat<=0)
            KLat=abs(KLat)+90;
        else
            KLat=90-KLat;
        end
        KLon=fix(lon);
        if KLon==0
            KLon=360;
        end
        if (pl(KLat,KLon)==potr(1,KR))
            sp(1,i)=Lat;
            sp(2,i)=lon;
            ind=false;
        end
    end
end
s=sp;