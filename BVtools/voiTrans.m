% Translate a .voi from TAL space to ACPC space, note that the actural 
% space is ACPC, while BV wrongly label it as 'TAL'
%
% History
% Nihong Chen wrote it, 2012

a=BVQXfile('gxl.voi');
if strcmp(a.ReferenceSpace,'TAL')
a.ReferenceSpace='ACPC';
for i=1:numel(a.VOI)
  a.VOI(i).Voxels=128-a.VOI(i).Voxels(:, [2,3,1]);
end
a.Save();
end
