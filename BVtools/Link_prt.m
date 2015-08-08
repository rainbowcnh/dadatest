%  To link prt with VTC in BV
%  Check the detail paths and filenames


%  Written By Nihong Chen, 2011


%bvqx = actxserver('BrainVoyagerQX.BrainVoyagerQXInterface');
bvqx = actxserver('BrainVoyagerQX.BrainVoyagerQXScriptAccess.1');
type = {'pre', 'post','ppost'};
sub = 'fl';
run_nr = 16;
pa = ['E:/fmri/sub/' sub '/TAL/'];
vmrname = [pa  'fl_TAL.vmr'];
vmrproject = bvqx.OpenDocument(vmrname);
for j=1:length(type)
    for i=1:run_nr
        na=[pa type{j} int2str(i) 'TAL.vtc'];
        vmrproject.LinkVTC(na);
        prtname=['E:/fmri/prt/formal/run' int2str(i) '.prt'];       
        vmrproject.LinkStimulationProtocol(prtname);
        vmrproject.SaveVTC(na);
    end
end