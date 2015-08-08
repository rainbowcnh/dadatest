
%%%%%%%%%% fit gaus%%%%%%%%%%%%%%%%%%%%
temp=zeros(1,7);
[roi,con,sub]=size(ppre);
g=zeros(3,sub,roi);
R=g;
for i=1
    for j=1:sub
        figure();
        temp=ppre(i,:,j);
        an=ezfit([-3:3],temp,'a*exp (-(x^2)/(2*b^2))+c');
        g(1,j,i)=abs(an.m(2));
        R(1,j,i)=an.r;
        
        x=[-3:3];
        y=temp;
        plot(x, y, 'b*--');
        a=ezfit(x,temp,'a*exp (-(x^2)/(2*b^2))+c');
        showfit(a, 'fitcolor','blue');
        
        temp=ppost(i,:,j);
        an=ezfit([-3:3],temp,'a*exp (-(x^2)/(2*b^2))+c');
        g(2,j,i)=abs(an.m(2));
        R(2,j,i)=an.r;
        
        hold on; plot(x, temp, 'r*--');
        b=ezfit([x],temp,'a*exp (-(x^2)/(2*b^2))+c');
        showfit(b, 'fitcolor','red');
        
        temp=ppost2w(i,:,j);
        an=ezfit([-3:3],temp,'a*exp (-(x^2)/(2*b^2))+c');
        g(3,j,i)=abs(an.m(2));
        R(3,j,i)=an.r;

        hold on; plot(x, temp, 'g*--');
        c=ezfit(x,temp,'a*exp (-(x^2)/(2*b^2))+c');
        showfit(c, 'fitcolor','green');
        
    end
end



gpre(:,:)=g(1,:,:);
gpost(:,:)=g(2,:,:);
gpost2w(:,:)=g(3,:,:);

rpre(:,:)=R(1,:,:);
rpost(:,:)=R(2,:,:);
rpost2w(:,:)=R(3,:,:);

gpc=gpost-gpre;
gp2=gpost2w-gpre;
[c1, p1]=ttest(gpc);
[c2, p2]=ttest(gp2);
[p1' p2']


rpc=rpost-rpre;
rp2=rpost2w-rpre;

tr1=rpre(:,:)>0.8;
tr2=rpost(:,:)>0.8;
tr3=rpost2w(:,:)>0.8;

tr=(tr1 + tr2 + tr3)==3;
fgpc=zeros(size(gpc));
fgp2=fgpc;
for i=1:sub
    for j=1:roi
        if tr(i,j)==1
            fgpc(i,j)=gpc(i,j);
            fgp2(i,j)=gp2(i,j);
        end
    end
end
%%%%%%%% plot target roi %%%%%%%%%%
figure();
temp=pre(6,:);
x=[-3:3];
y=temp;
plot(x, y, 'b*--');
a=ezfit(x,temp,'a*exp (-(x^2)/(2*b^2))+c');
showfit(a, 'fitcolor','blue');
%
% [sigmaNew,muNew,Anew]=mygaussfit(x,y);
% y=Anew*exp(-(x-muNew).^2/(2*sigmaNew^2));
% hold on; plot(x,y,'.r');

temp=post(6,:);
hold on; plot(x, temp, 'r*--');
b=ezfit([x],temp,'a*exp (-(x^2)/(2*b^2))+c');
showfit(b, 'fitcolor','red');

temp=post2w(6,:);
hold on; plot(x, temp, 'g*--');
c=ezfit(x,temp,'a*exp (-(x^2)/(2*b^2))+c');
showfit(c, 'fitcolor','green');



