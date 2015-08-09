function []=main()
% 1. Use GenerateSpheres.m to create sphere.mat
% 2. Run this code to perform libSVM decoding for each sphere
% 3. Demonstrate map with writevmp_raw.m, then open in BV
%
% Nihong Chen wrote on 2015.5.17
%


subN={ 'xz'};
for i=1:length(subN)
    finame=['D:\TMSlearningfMRI\vtc\' subN{i} '\Sphere.mat'];
    load(finame);
    sear(subN{i});
end
end

function []=sear(sub)

run = 11;
pa = ['D:\TMSlearningfMRI\vtc\' sub '\'];
t = 1;
ty = {'pre', 'post'};
tem = BVQXfile([pa ty{1} int2str(t) '.glm']);
data = tem.GLMData.BetaMaps;
[x, y, z,nb]= size(data);
Nr_block = Nr_block - 1;
datanew = zeros(x,y,z,run*nb);

for rp = 1:length(ty)
    for rr = 1:run
        datanew(:,:,:,run*nb*(rp-1)+(rr-1)*nb+1:run*nb*(rp-1)+rr*nb)=data(1:x,1:y,1:z,1:Nr_block);
        if rr<11
            tem = BVQXfile([pa ty{rp} int2str(rr+1) '.glm']);
            data = tem.GLMData.BetaMaps;
            tem.ClearObject;
        end
    end
end
jie=0;
patterns=size(sp,2);

for i = 1:patterns
    repeat = size(sp{i},1);
    if repeat > 40                                                          % Nr of voxels within a specific sphere
        roi = [];
        jie = jie+1;
        tt = 0;
        for j = 1:repeat
            if find(datanew(sp{i}(j,1),sp{i}(j,2),sp{i}(j,3),:)==0)         % pre post post2w all ~=0
            else
                tt=tt+1;
                guo{jie}.xyz(tt,1:3)=sp{i}(j,:);
                roi(tt,:)=datanew(guo{jie}.xyz(tt,1),guo{jie}.xyz(tt,2),guo{jie}.xyz(tt,3),:);
            end
        end
        if tt>30                                                            % Nr of activated voxels for further decoding
            zroi=roi;
            condi =8 ;
            n0=zeros(tt,run*2);
            n90=zeros(tt,run*2);
            c0=zeros(tt,run*2);
            c90=zeros(tt,run*2);
            for rp=1:length(ty)
                temp=0;
                for ind=1:condi:run*condi
                    temp = temp+1;
                    n0(:,temp)=zroi(:,run*Nr_block*(rp-1)+ind);
                    n90(:,temp)=zroi(:,run*Nr_block*(rp-1)+ind+1);
                    c0(:,temp)=zroi(:,run*Nr_block*(rp-1)+ind+2);
                    c90(:,temp)=zroi(:,run*Nr_block*(rp-1)+ind+3);
                    temp=temp+1;
                    n0(:,temp)=zroi(:,run*Nr_block*(rp-1)+ind+4);
                    n90(:,temp)=zroi(:,run*Nr_block*(rp-1)+ind+5);
                    c0(:,temp)=zroi(:,run*Nr_block*(rp-1)+ind+6);
                    c90(:,temp)=zroi(:,run*Nr_block*(rp-1)+ind+7);
                end;
                turn.predict=0;
                turn.predict=0;
                turn.guess=0;
                holdout=2;
                zuhe=nchoosek((1:run*2),holdout);
                cle=zeros(1,3);
                noise=cle;
                for rep=1:size(zuhe,1)
                    selector = ones(1,run*2);
                    selector(zuhe(rep,:))=0;
                    selector=boolean(selector);
                    num=sum(selector);
                    Trainl = [ones(1,num), -ones(1,num)];
                    Trainl=Trainl';
                    c0_90 = svmtrain(Trainl,[c0(:,selector), c90(:,selector)]' , ' -t 0');
                    n0_90 = svmtrain(Trainl,[n0(:,selector), n90(:,selector)]' , ' -t 0');
                    Testl=ones(holdout,1);                                 
                    
                    tests=boolean(1-selector);
                    patt1={c0(:,tests), c90(:,tests)};
                    patt2={n0(:,tests), n90(:,tests)};
                    mod1=[c0_90];
                    mod2=[n0_90];
                    for tem=1:length(mod1)
                        [p, accu, dec] = svmpredict(Testl,patt1{1}', mod1(tem), '-b 0');
                        cle(tem)=cle(tem)+accu(1);
                        [p, accu, dec] = svmpredict(-Testl,patt1{2}', mod1(tem), '-b 0');
                        cle(tem)=cle(tem)+accu(1);
                        [p, accu, dec] = svmpredict(Testl,patt2{1}', mod2(tem), '-b 0');
                        noise(tem)=noise(tem)+accu(1);
                        [p, accu, dec] = svmpredict(-Testl,patt2{2}', mod2(tem), '-b 0');
                        noise(tem)=noise(tem)+accu(1);
                    end
                end
                cle=cle/size(zuhe,1)/2;
                noise=noise/size(zuhe,1)/2;
                
                if rp==1
                    guo{jie}.pre=[cle;noise];
                else if rp==2
                        guo{jie}.post=[cle;noise];
                    end
                end
            end
            
        else
            guo{jie}.xyz=[];
            jie=jie-1;
        end
        
    end
end
save([pa 'MVPAsear'],'guo', 'tim');
end
