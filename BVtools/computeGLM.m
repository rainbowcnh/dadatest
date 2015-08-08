% Computing GLM from BV

% History
% Nihong Chen wrote it, 2011



%bvqx = actxserver('BrainVoyagerQX.BrainVoyagerQXInterface');
%bvqx = actxserver('BrainVoyagerQX.BrainVoyagerQXInterface.1');
bvqx = actxserver('BrainVoyagerQX.BrainVoyagerQXScriptAccess.1')
type = {'pre', 'post','ppost'};
sub = 'ls';

pa = ['E:/fmri/sub/' sub '/tuning/'];
vmrname = [pa  'ls_ACPC.vmr'];
vmrproject = bvqx.OpenDocument(vmrname);
for j=1:length(type)
    for i = 1:run_nr
        na=[pa type{j} int2str(i) '.vtc'];
        vmrproject.LinkVTC(na);
        % prtname=['A:/fmri/prt/10beta/run' int2str(i) '.prt'];
        % vmrproject.LinkStimulationProtocol();
        rtcname=['E:/fmri/rtc/10beta/' int2str(i) '.rtc'];
        % rtcname=['A:/fmri/rtc/formal/run' int2str(i) '.rtc']
        vmrproject.LoadSingleStudyGLMDesignMatrix(rtcname);
        vmrproject.ComputeSingleStudyGLM();
        glmfilename = fullfile(pa, [type{j} int2str(i)  '.glm']);
        vmrproject.SaveGLM(glmfilename);
    end
end