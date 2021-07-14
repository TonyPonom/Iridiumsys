function f = marshrutizator( sat,contab,Vesi,Tstart,Tfinish)% поиск маршрута волновым алгоритмом
mins = zeros(1,sat);% минимумы
PYTb = zeros(1,sat);% путь
navi = zeros(1,sat);% навигация
Vesi = ones(1,sat);
PYTb(Tstart) =Vesi(Tstart);
indic = false; c=1; indic2 = false;
for i = 1:4
    PYTb(contab(Tstart,i)) =Vesi(Tstart)+ Vesi(contab(Tstart,i));
    navi(contab(Tstart,i))=1;
    mins(contab(Tstart,i))= Tstart;
    if ( contab(Tstart,i)== Tfinish )
       indic = true;
    end;
    c = c+1;
end
r=2;
if ( indic == false )
    while ( indic2 == false ) 
        x=0;  
        for z = 1:sat
            
            if ((navi(z)== r-1) && (z~=Tfinish))
                p=r; 
                for k = 1:4
                    if (PYTb(contab(z,k))== 0)
                        c= c+1;
                    end;
                    %if (contab(z,k)== Tfinish) && (PYTb(contab(z,k))== p)
                    %    indic2 = true;
                    %end;
                    g = PYTb(z)+ Vesi(contab(z,k));
                    if ((PYTb(contab(z,k))> g) ||  (PYTb(contab(z,k))== 0))
                        PYTb(contab(z,k)) = g;
                        mins(contab(z,k))= z;
                        x=1;
                        navi(contab(z,k))=p;      
                    end
                end 
                
            end
        end
        if( x==0  )
            indic2 = true;
     
        end
        r=r+1;
    end
end;
sp = zeros(1,3);
indic2 = false;
t=1;
sp(t)=Tfinish;

if ( indic == false )
    while ( indic2 == false )
        sp(t+1)=mins(sp(t));
        t=t+1;
        if (sp(t)==Tstart)  
            indic2 = true;
        end
  
    end
    spor=zeros(1,3);k=1;
    for i=1:length(sp)
        spor(i)=sp(length(sp)-i+1);
        
    end
else
    spor=[Tstart,Tfinish];
end

f=spor;