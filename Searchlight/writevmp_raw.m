a=BVQXfile('clear.vmp');

load('MVPAsear.mat');
a.Map(1).VMPData(:)=0;
a.Map(2).VMPData(:)=0;
for i=1:length(guo)
        x=round(mean(guo{i}.xyz(:,1)));
        y=round(mean(guo{i}.xyz(:,2)));
        z=round(mean(guo{i}.xyz(:,3)));
    a.Map(1).VMPData(x,y,z)=guo{i}.pre(1,1)/10;
    a.Map(2).VMPData(x,y,z)=guo{i}.post(1,1)/10;
end

a.save();
a.ClearObject;
    