function []=GenerateSpheres()
% Prepare .msk for idividual hemisphere 
% Brainvoayger Mesh--> Create Cortex_based VTC mask
% Nihong Chen wrote it, 2015.5
global wbrain maxX maxY maxZ

subN={'xz'};
for i=1:length(subN)
    pa=['D:\TMSlearningfMRI\vtc\' subN{i} '\'];
    fi =[pa 'rh.msk'];
    vtcfi=[pa 'm2.vtc'];
    a=BVQXfile(fi);
    b=BVQXfile(vtcfi);
    [maxX,maxY,maxZ]=size(a.Mask);
    wbrain=a.Mask;
    ind=0;
    for x=1:maxX
        for y=1:maxY
            for z=1:maxZ
                if a.Mask(x,y,z)==1 && (max(b.VTCData(:,x,y,z))>50)           % Brain mask
                    re=sphere([x,y,z]);
                    ind=ind+1;
                    sp{ind}=re;
                end
            end
        end
    end
end
finame=[pa 'Sphere.mat'];
save(finame, 'sp', 'ind')

end
function gone=sphere(s)
global wbrain maxX maxY maxZ
radius = 3;
tou=1;
wei=1;
go=0;
x0=s(1,1);
y0=s(1,2);
z0=s(1,3);
while 1
    while s(tou,1)==0
        tou=tou+1;
        if tou>wei
            break;
        end
    end
    if tou>wei
        break
    end
    go=go+1;
    gone(go,:)=s(tou,:);
    X=s(tou,1);
    Y=s(tou,2);
    Z=s(tou,3);
    s(tou,:)=[0 0 0];

    for i=X-1:X+1
        for j=Y-1:Y+1
            for k=Z-1:Z+1
                if ((X-1)>0 && (X+1)<maxX && (Y-1)>0 && (Y+1)<maxY && (Z-1)>0 && (Z+1)<maxZ)
                    if ~(i==X && j==Y && k==Z)
                        if wbrain(i,j,k)==1
                            dist=(i-x0)^2+(j-y0)^2+(k-z0)^2;
                            if dist<radius^2
                                yy=0;
                                for l=1:go
                                    if sum(gone(l,:)==[i j k])==3
                                        yy=yy+1;
                                    end
                                end
                                for l=tou:wei
                                    if sum(s(l,:)==[i j k])==radius
                                        yy=yy+1;
                                    end
                                end
                                if yy==0
                                    wei=wei+1;
                                    s(wei,1)=i;
                                    s(wei,2)=j;
                                    s(wei,3)=k;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
end
