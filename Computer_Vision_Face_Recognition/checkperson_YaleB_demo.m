function [ind,ssdist]=checkperson_YaleB_demo(A,x,y,pers,impp)
%

N=size(A,2);

W=sparse([],[],[],N,pers,length(x));
for i=1:pers
    ind=((i-1)*impp+1):((i)*impp);
    W(ind,i)=x(ind);
end
ae=A*W-y(:,ones(pers,1));
ssdist=sqrt(sum(ae.^2));

[ssmin,ind]=min(ssdist);


