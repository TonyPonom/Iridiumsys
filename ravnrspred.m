function s = ravnrspred(r)
sp = zeros(2,r);
for i = 1:r
        R=rand;
        sp(1,i)=(asin(2*R-1)*180)/pi; % Широта в градусах
        sp(2,i)=R*360;
end
s=sp;