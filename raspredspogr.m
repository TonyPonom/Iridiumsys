function s = raspredspogr(r,n,Vesi,Grafsp,Rv,p)
sp = zeros(2,r/2);
%-----------------------------------------------
xp = ravnrspred(r);%вариант с  равномерным распределением
%xp = plotspred(r);%вариант согласно плотности населения 
dost = zeros(1,n);
q=1;
f=1;
z=1;
i=z;
while z <= r
    visible = zeros(2,1);
    leng = zeros(1,1);
    %ind=true;
    %while ind
        c=1; 
        for k= 1:66
            if dost(k)~=p
                %l = ((pi*6371)/180)*sqrt((Grafsp(k,1) - xp(1,i))*(Grafsp(k,1) - xp(1,i)) + (Grafsp(k,2) - xp(2,i))*(Grafsp(k,2) - xp(2,i)));
                sin1=sin((Grafsp(k,1) - xp(1,i))/2);
                sin2=sin((Grafsp(k,2) - xp(2,i))/2);
                %l =((pi*6371)/180)*sqrt((Grafsp(k,1) - xp(1,i))*(Grafsp(k,1) - xp(1,i)) + (Grafsp(k,2) - xp(2,i))*(Grafsp(k,2) - xp(2,i)));
                l=2*6371*asin(sqrt(sin1*sin1+sin2*sin2*cos(Grafsp(k,1))*cos(xp(1,i))));
                if (l<=Rv)
                    visible(1,c) = k;
                    visible(2,c) = l;
                    %visible(2,c) = Vesi(k);
                    leng(1,c) = l;
                    c=c+1;
                end
            end
        end
        %min = zeros(1,2);
        min = zeros(1,3);
        min(1,1) = visible(1,1);
        min(1,2) = visible(2,1);
        min(1,3) = leng(1);
        if c>2
            for g= 2:length(visible)
                if (visible(2,g)<min(1,2))
                    min(1,1) = visible(1,g);
                    min(1,2) = visible(2,g);
                    min(1,3) = leng(g);
                end
                %if (visible(2,g)==min(1,2))
                %    if (leng(g)<min(1,3))
                %        min(1,1) = visible(1,g);
                %        min(1,2) = visible(2,g);
                %        min(1,3) = leng(g);
                %    end
                %end
            end
        end
        %if visible(1,1)==0
            %%x = ravnrspred(1);
            %xp = ravnrspred(r);
            %%xp(1,i)= x(1,1);
            %%xp(2,i)= x(2,1);
        %else
            %ind=false;
        %end
    %end
    if visible(1,1)~=0
        dost(min(1,1))=dost(min(1,1))+1;
        %Vesi(min(1,1))=Vesi(min(1,1))+1;
        sp(q,f)= min(1,1);
        if q==2
            q=1;
            f=f+1;
        else
            q=q+1;
        end
        z=z+1;
    end
    i=i+1;
    if i==r+1
        xp = ravnrspred(r);
        i=1;
    end
end
s=sp;