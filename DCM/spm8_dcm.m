

% Initialise SPM
%--------------------------------------------------------------------------
spm('Defaults','fMRI');
spm_jobman('initcfg');
%spm_get_defaults('cmdline',1);
number=8;
subN={'zxl', 'fzz','xds', 'wp','fl', 'zy', 'jhl','zly', 'xsz', 'lyk','lmy', 'hyc', 'lqq', 'ls', 'lmx', 'jhy', 'hyy'};
da={ 'day1','day2', 'day3', 'day4', 'day5','day6'};
clear matlabbatch
%--------------------------------------------------------------------------
for s=1:17
tmp=strfind(lookup,(subN{s}));
tmp= cellfun('length',tmp);
ss=find(tmp,1);
for k=1:length(da)
for run=1:8
data_path = ['D:\fmri\' subN{s} '\' da{k} '\run' int2str(run)];
% CHANGE WORKING DIRECTORY
%--------------------------------------------------------------------------
clear matlabbatch
matlabbatch{1}.cfg_basicio.cfg_cd.dir = cellstr(data_path);
spm_jobman('run',matlabbatch);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DYNAMIC CAUSAL MODELLING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear DCM
%--------------------------------------------------------------------------
load(fullfile(data_path,'GLM','SPM.mat'));

load(fullfile(data_path,'GLM','VOI_rMT_2.mat'),'xY');
DCM.xY(1) = xY;
load(fullfile(data_path,'GLM','VOI_rV3a_2.mat'),'xY');
DCM.xY(2) = xY;
load(fullfile(data_path,'GLM','VOI_rIPS_2.mat'),'xY');
DCM.xY(3) = xY;

DCM.n = length(DCM.xY);      % number of regions
DCM.v = length(DCM.xY(1).u); % number of time points

DCM.Y.dt  = SPM.xY.RT;
DCM.Y.X0  = DCM.xY(1).X0;
for i = 1:DCM.n
    DCM.Y.y(:,i)  = DCM.xY(i).u;
    DCM.Y.name{i} = DCM.xY(i).name;
end

DCM.Y.Q    = spm_Ce(ones(1,DCM.n)*DCM.v);

DCM.U.dt   =  SPM.Sess.U(1).dt;
DCM.U.name = [SPM.Sess.U(1).name SPM.Sess.U(2).name];
DCM.U.u    = [SPM.Sess.U(1).u(33:end,1) ...
              SPM.Sess.U(2).u(33:end,1)];

DCM.delays = repmat(SPM.xY.RT,DCM.n,1);
DCM.TE     = 0.03;

DCM.options.nonlinear  = 0;
DCM.options.two_state  = 0;
DCM.options.stochastic = 0;
DCM.options.nograph    = 1;
DCM.options.centre = 0;

DCM.a = [1 0 1; 0 1 1; 1 1 1];
DCM.b = zeros(3,3,2);  DCM.b(3,1,2) = 1;  DCM.b(3,2,2) = 1;
DCM.c = [1 0; 1 0;0 0];
DCM.d = zeros(3,3,0);

save(fullfile(data_path,'GLM','DCM_rfwd.mat'),'DCM');


DCM.b = zeros(3,3,2);  DCM.b(1,3,2) = 1;  DCM.b(2,3,2) = 1;

save(fullfile(data_path,'GLM','DCM_rbwd.mat'),'DCM');

% ESTIMATION
%--------------------------------------------------------------------------
DCM_bwd = spm_dcm_estimate(fullfile(data_path,'GLM','DCM_rbwd.mat'));
DCM_fwd = spm_dcm_estimate(fullfile(data_path,'GLM','DCM_rfwd.mat'));
% 

clear DCM

load(fullfile(data_path,'GLM','SPM.mat'));

load(fullfile(data_path,'GLM','VOI_lMT_2.mat'),'xY');
DCM.xY(1) = xY;
load(fullfile(data_path,'GLM','VOI_lV3a_2.mat'),'xY');
DCM.xY(2) = xY;
load(fullfile(data_path,'GLM','VOI_lIPS_2.mat'),'xY');
DCM.xY(3) = xY;

DCM.n = length(DCM.xY);      % number of regions
DCM.v = length(DCM.xY(1).u); % number of time points

DCM.Y.dt  = SPM.xY.RT;
DCM.Y.X0  = DCM.xY(1).X0;
for i = 1:DCM.n
    DCM.Y.y(:,i)  = DCM.xY(i).u;
    DCM.Y.name{i} = DCM.xY(i).name;
end

DCM.Y.Q    = spm_Ce(ones(1,DCM.n)*DCM.v);

DCM.U.dt   =  SPM.Sess.U(1).dt;
DCM.U.name = [SPM.Sess.U(1).name SPM.Sess.U(2).name];
DCM.U.u    = [SPM.Sess.U(1).u(33:end,1) ...
              SPM.Sess.U(2).u(33:end,1)];

DCM.delays = repmat(SPM.xY.RT,DCM.n,1);
DCM.TE     = 0.03;

DCM.options.nonlinear  = 0;
DCM.options.two_state  = 0;
DCM.options.stochastic = 0;
DCM.options.nograph    = 1;
DCM.options.centre = 0;

DCM.a = [1 0 1; 0 1 1; 1 1 1];
DCM.b = zeros(3,3,2);  DCM.b(3,1,2) = 1;  DCM.b(3,2,2) = 1;
DCM.c = [1 0; 1 0;0 0];
DCM.d = zeros(3,3,0);

save(fullfile(data_path,'GLM','DCM_lfwd.mat'),'DCM');

DCM.b = zeros(3,3,2);  DCM.b(1,3,2) = 1;  DCM.b(2,3,2) = 1;

save(fullfile(data_path,'GLM','DCM_lbwd.mat'),'DCM');

% ESTIMATION
%--------------------------------------------------------------------------
DCM_bwd = spm_dcm_estimate(fullfile(data_path,'GLM','DCM_lbwd.mat'));
DCM_fwd = spm_dcm_estimate(fullfile(data_path,'GLM','DCM_lfwd.mat'));


end
end
end


