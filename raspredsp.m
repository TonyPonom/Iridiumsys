function s = raspredsp(r,n,Vesi,Grafsp,Rv)
sp = zeros(2,r/2);
%-----------------------------------------------
%вариант с  равномерным распределением
xp = ravnrspred(r);
f=1;
for i = 1:2:r-1
    visible = zeros(2,1);
    leng = zeros(1,1);
    c=1; 
    for k= 1:66
        l = ((pi*6371)/180)*sqrt((Grafsp(k,1) - xp(1,i))*(Grafsp(k,1) - xp(1,i)) + (Grafsp(k,2) - xp(2,i))*(Grafsp(k,2) - xp(2,i)));
        if (l<=Rv)
            visible(1,c) = k;
            visible(2,c) = l;
            %visible(2,c) = Vesi(k);
            %leng(1,c) = l;
            c=c+1;
        end
    end
    %min = zeros(1,2);
    min = zeros(1,3);
    min(1,1) = visible(1,1);
    min(1,2) = visible(2,1);
    min(1,3) = leng(1);
    if c~=2
        for g= 2:length(visible)
            if (visible(2,g)<min(1,2))
                min(1,1) = visible(1,g);
                min(1,2) = visible(2,g);
                %min(1,3) = leng(g);
            end
            %if (visible(2,g)==min(1,2))
                %if (leng(g)<min(1,3))
                    %min(1,1) = visible(1,g);
                    %min(1,2) = visible(2,g);
                    %min(1,3) = leng(g);
                %end
            %end
        end
    end
    sp(1,f)= min(1,1);
    %-----------------------------
    visible2 = zeros(2,1);
    leng = zeros(1,1);
    c=1; 
    for k= 1:66
        l = ((pi*6371)/180)*sqrt((Grafsp(k,1) - xp(1,i+1))*(Grafsp(k,1) - xp(1,i+1)) + (Grafsp(k,2) - xp(2,i+1))*(Grafsp(k,2) - xp(2,i+1)));
        if (l<=Rv)
            visible2(1,c) = k;
            visible2(2,c) = l;
            %visible2(2,c) = Vesi(k);
            %leng(1,c) = l;
            c=c+1;
        end
    end
    %min2 = zeros(1,2);
    min2 = zeros(1,3);
    min2(1,1) = visible2(1,1);
    min2(1,2) = visible2(2,1);
    min2(1,3) = leng(1);
    if c~=2
        for g= 2:length(visible2)
            if (visible2(2,g)<min2(1,2))
                min2(1,1) = visible2(1,g);
                min2(1,2) = visible2(2,g);
                %min2(1,3) = leng(g);
            end
            %if (visible2(2,g)==min2(1,2))
                %if (leng(g)<min2(1,3))
                    %min2(1,1) = visible2(1,g);
                    %min2(1,2) = visible2(2,g);
                    %min2(1,3) = leng(g);
                %end
            %end
        end
    end
    sp(2,f)= min2(1,1);
    f=f+1;
end
s=sp;