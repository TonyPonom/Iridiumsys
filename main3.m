clc;clear;
sat=66;%66; % количество спутников
contab = [ 34 2 62 39;  %Матрица связности
           1 3 63 7;
           2 4 64 8;
           3 5 65 9;
           4 6 66 10;
           5 7 44 11;
           39 8 2 12;
           7 9 3 13;
           8 10 4 14;
           9 11 5 15;
           10 44 6 16;
           45 13 7 50; 
           12 14 8 18;
           13 15 9 19;
           14 16 10 20;
           15 17 11 21;
           16 49 55 22;
           50 19 13 23;
           18 20 14 24;
           19 21 15 25;
           20 22 16 26;
           21 55 17 27;
           56 24 18 61;
           23 25 19 29;
           24 26 20 30;
           25 27 21 31;
           26 28 22 32;
           27 60 66 33;
           61 30 24 38;
           29 31 25 34;
           30 32 26 35;
           31 33 27 36;
           32 66 28 37;
           1 35 30 39;
           34 36 31 40;
           35 37 32 41;
           36 38 33 42;
           37 6 29 43;
           7 40 34 1;
           39 41 35 45;
           40 42 36 46;
           41 43 37 47;
           42 44 38 48;
           43 11 6 49;
           12 46 40 50;
           45 47 41 51;
           46 48 42 52;
           47 49 43 53;
           48 17 44 54;
           18 51 45 12;
           50 52 46 56;
           51 53 47 57;
           52 54 48 58;
           53 55 49 59;
           54 22 17 60;
           23 57 51 61;
           56 58 52 62;
           57 59 53 63;
           58 60 54 64;
           59 28 55 65;
           29 62 56 23;
           61 63 57 1;
           62 64 58 2;
           63 65 59 3;
           64 66 60 4;
           65 33 28 5;
           ];
%contab = [ 2 3 4 5;
%           1 3 4 5;
%           1 2 4 5;
%           1 2 3 5;
%           1 2 3 4;
%    ];
beta = 85 *(pi/180);
Rv = 781*tan(beta);
%Rv=4700;
isys = 86.6;
usys = [ 0 32.7 65.4 98.1 130.8 163.5 196.2 228.9 261.6 294.3 327];
omsys =[ 0 31.6 63.2 94.8 126.4 158 ];
xy = zeros(3,sat);
Grafsp = zeros(sat,2);
q=1;nv=1;
for m =1:sat
    xy(1,m)=cos(usys(nv)*(pi/180))*cos(omsys(q)*(pi/180))-sin(usys(nv)*(pi/180))*sin(omsys(q)*(pi/180))*cos(isys*(pi/180));
    xy(2,m)=cos(usys(nv)*(pi/180))*sin(omsys(q)*(pi/180))-sin(usys(nv)*(pi/180))*cos(omsys(q)*(pi/180))*cos(isys*(pi/180));
    xy(3,m)=sin(usys(nv)*(pi/180))*sin(isys*(pi/180));
    Grafsp(m,1)=asin(xy(3,m)/sqrt(xy(1,m)*xy(1,m)+xy(2,m)*xy(2,m)+xy(3,m)*xy(3,m)))*(180/pi); % широта
	Grafsp(m,2)=atan2(xy(2,m),xy(1,m));	%долгота
	while (Grafsp(m,2) < -pi) 
         Grafsp(m,2) = pi*2 + Grafsp(m,2);
    end
    Grafsp(m,2) = Grafsp(m,2)*(180/pi)+180;
    nv=nv+1;
    if (mod(m+1,11) == 0) && (m+1~=66)
        q=q+1;nv=1;
    end
    if (mod(m+1,11)==0)
        nv=1;
    end

end
taktend=200;
pksk=zeros(1,taktend);
ppk=zeros(1,taktend);
p=4000000;
sred=100;
for kl=1:sred
taktend=200; %кол-во тактов на который имитируем 
Vesi = ones(1,sat); %массив весов
next = ones(1,sat); % массив со следующими пустыми местами в очереди
send = zeros(1,sat); % массив с последним пакетом который на данный такт можно переслать
sputsys = zeros(sat,200*sat,sat); % основной 3х мерный массив,имитирующий спутниковую систему
par = 32; %пакетов в такт забрасывают
antenna = zeros(1,4); %массив для показа сколько антенн на спутнике было использовано
usredp = zeros(1,taktend);
sredpack=zeros(1,taktend);
pk=0;
%pksk=zeros(1,taktend);
expocket = zeros(1,taktend);
pocket=0;
ds=zeros(1,sat);
%s = pairs(par,sat);
s = raspredspogr(par*2,sat,Vesi,Grafsp,Rv,p);
for i = 1:par
    if (s(1,i)~=s(2,i))
        marsh = marshrutizator( sat,contab,Vesi,s(1,i),s(2,i)); 
        for j = 2 : length(marsh)
            sputsys(marsh(1,1),next(marsh(1,1)),j-1)= marsh(1,j);   
        end
        next(marsh(1,1)) = next(marsh(1,1))+1;
        Vesi(marsh(1,1)) = Vesi(marsh(1,1))+1;
        send(marsh(1,1)) = send(marsh(1,1))+1;
    end
    if (s(1,i)==s(2,i))
        %pocket=pocket+1;
        %pk=pk+1;
        ds(s(1,i))=ds(s(1,i))+1;
    end
end
%expocket(1)=0;
%sredpack(1)=0;
ppk(1)=pk;
takt=2; %текущий такт
ind = true;
while takt<=taktend
    pk=0;
    for ps=1:sat
        if ds(ps)~=0
        	%pocket=pocket+ds(ps);
        	%pk=pk+ds(ps);
            if ds(ps)<=p
                pocket=pocket+ds(ps);
                pk=pk+ds(ps);
                ds(ps)=0;
            else
                pocket=pocket+p;
                pk=pk+p;
                ds(ps)=ds(ps)-p;
            end
        end
    end
    %ds=zeros(1,sat);
    % закидываем пакеты
    % --------------------------------------------------------------------------------
    %s = pairs(par,sat);
    s = raspredspogr(par*2,sat,Vesi,Grafsp,Rv,p);
    for i = 1:par
        if (s(1,i)~=s(2,i))
            marsh = marshrutizator( sat,contab,Vesi,s(1,i),s(2,i)); 
            for j = 2 : length(marsh)
                sputsys(marsh(1,1),next(marsh(1,1)),j-1)= marsh(1,j);   
            end
            next(marsh(1,1)) = next(marsh(1,1))+1;
            Vesi(marsh(1,1)) = Vesi(marsh(1,1))+1; 
        end
        if (s(1,i)==s(2,i))
            %pocket=pocket+1;
            %pk=pk+1;
            ds(s(1,i))=ds(s(1,i))+1;
        end
    end
    %----------------------------------------------------------------------------------
    %передаем пакеты
    %----------------------------------------------------------------------------------
    for z = 1:sat
        if (send(z)~=0)
            t=1; antenna = zeros(1,4);an=0;ind=true;
            while ind
                g=sputsys(z,t,1);
                an =0; in=true;
                while ((an<4) && (in))%поиск антенны через который отправляем пакет
                    an=an+1;
                    if contab(z,an)==g
                        in = false;
                    end
                end
                if (antenna(an)== 0 )%если через эту антенну еще не передавали пакет
                    gg=sputsys(z,t,1);
                    sputsys(z,t,1)=0;
                    ind2 = true;j=2;
                    if (sputsys(z,t,2)==0)%пакет доставлен
                        %pocket=pocket+1;
                        %pk=pk+1;
                        ds(gg)=ds(gg)+1;
                        ind2 = false;
                        Vesi(z) = Vesi(z)-1;
                        send(z)=send(z)-1;
                    end
                    if (sputsys(z,t,2)~=0)%регулируем весы на спутниках, пакеты на отправку и следующее место
                        next(g)=next(g)+1;
                        send(z)=send(z)-1;
                        Vesi(g)=Vesi(g)+1;
                        Vesi(z)=Vesi(z)-1;
                    end
                    while ind2 %передаем пакет
                        sputsys(g,next(g)-1,j-1) = sputsys(z,t,j);
                        sputsys(z,t,j) = 0;
                        j=j+1;
                        if ((sputsys(z,t,j)==0)||(j>2*sat))
                            ind2=false;
                        end
                    end
                    antenna(an)= 1;% ставим индикатор, что уже использовали эту антенну 
                end
                an=antenna(1)+antenna(2)+antenna(3)+antenna(4);
                if an==4 % условие входа, когда все антенны использовали
                    ind = false;
                end
                if (send(z)==0)% условие выхода, когда больше нет пакетов в очереди
                    ind = false;
                end
                t=t+1;
                if sputsys(z,t,1)==0% другой вариант предыдущего условия(почему оставил не помню
                    ind = false;
                end
            end
        end
    end
    %----------------------------------------------------------------------------------
    %сортируем очередь
    %----------------------------------------------------------------------------------
     for z = 1:sat
        ind = true;t=1;
        if (Vesi(z)==1)% условие когда не надо сортировать очередь(нет пакетов в очереди)
            ind=false;
        end
        if (Vesi(z)==2)&&(sputsys(z,1,1)~=0)% условие когда не надо сортировать очередь(есть один пакет и он стоит первым)
            ind=false;
        end
        kol=0;%количество перемещенных пакетов
        while ind% сама сортировка
            if (sputsys(z,t,1)==0)&&(t<(next(z)-1))
                ind3 = true;x=t;
                while ind3
                    if sputsys(z,x+1,1)~=0
                        ind2 = true;j=1;
                        while ind2 %перемещаем пакеты в очереди
                            c=sputsys(z,t,j);
                            sputsys(z,t,j)=sputsys(z,x+1,j);
                            sputsys(z,x+1,j)=c;
                            j=j+1;
                            if ((sputsys(z,x+1,j)==0)||(j==sat))
                                ind2=false;%означает что весь маршрут пакета передали
                            end
                        end
                        ind3=false;
                        kol=kol+1;%увеличиваем количество переставленных пакетов
                    end
                    x=x+1;%идем дальше по очереди(откуда перемещаем пакеты)
                end 
            end
            if (kol == (Vesi(z)-1))||(t==(next(z)))%условия выхода из сортировки очереди
                ind=false;
                send(z)=t;
            end
            t=t+1;%идем дальше по очереди(куда перемещаем пакеты)
        end

    end
    %----------------------------------------------------------------------------------
    % высчитываем сколько на каком спутнике пакетов и выставляем
    % vesi,send,next
    for i=1:sat
        ind=true;t=1;
        while ind
            if (sputsys(i,t,1)==0)
                ind=false;
            end
            t=t+1;
        end
        next(i)=t-1;
        send(i)=next(i)-1;
        Vesi(i)=next(i);
    end
    ppk(takt)=ppk(takt)+pk;
    expocket(takt)=pocket;
    pksk(takt)=pksk(takt)+pk;
    pk=0;
    takt=takt+1;
end
    %figure(1)
    %plot( usredp)
end
%spack = zeros(1,taktend);
for kl=1:taktend
    ppk(kl)=((ppk(kl)/sred));
end
ed=ppk(taktend) %pksk(taktend)
eed=ed/par %spack(taktend)
figure(2)
plot(ppk)
title('усредненое')
xlabel('такты')
ylabel('количество вышедших покетов на такте')
figure(3)
bar(send)
xlabel('№ спутника')
ylabel('пакетов в очереди')
xlim([1,66])

