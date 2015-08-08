

% Initialise SPM
%--------------------------------------------------------------------------
spm('Defaults','fMRI');
spm_jobman('initcfg');
%spm_get_defaults('cmdline',1);
number=8;
subN={'zxl', 'fzz','xds', 'wp','fl', 'zy', 'jhl','zly', 'xsz', 'lyk','lmy', 'hyc', 'lqq', 'ls', 'lmx', 'jhy', 'hyy'};
da={ 'day1','day2', 'day3', 'day4', 'day5','day6'};
clear matlabbatch
lookup={'zxl', 'fzz','xds', 'wp','fl', 'zy', 'jhl','zly', 'xsz', 'lyk','lmy', 'hyc', 'lqq', 'ls', 'lmx', 'jhy', 'hyy'};
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
% GLM SPECIFICATION, ESTIMATION & INFERENCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if mod(k,2)==0
factors = load(['D:\DCM\day2\run', int2str(run) '.mat']);                       % load stimulus protocal
else
    factors = load(['D:\DCM\day1\run', int2str(run) '.mat']);
end
% OUTPUT DIRECTORY
%-----------------------------------------------------------------------
clear matlabbatch
matlabbatch{1}.cfg_basicio.cfg_mkdir.parent = cellstr(data_path);
matlabbatch{1}.cfg_basicio.cfg_mkdir.name = 'GLM';
spm_jobman('run',matlabbatch);

if exist('./GLM/SPM.mat')
    continue
end
%MODEL SPECIFICATION
%--------------------------------------------------------------------------
clear matlabbatch
matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(fullfile(data_path,'GLM'));
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT    = 2;                         %
f = spm_select('FPList', data_path, '^sw.*\.img$');
matlabbatch{1}.spm.stats.fmri_spec.sess.scans            = cellstr(f); 
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name     = 'train';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset    = [factors.d1+1];
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = 6;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name     = 'all';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset    = [factors.d1+1 factors.d2+1 factors.d3+1 factors.d4+1];    
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = 6;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name     = 'fixation';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset    = [factors.fix+1];
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 6;

% % MODEL ESTIMATION
%--------------------------------------------------------------------------
matlabbatch{2}.spm.stats.fmri_est.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));
% 
% INFERENCE
%--------------------------------------------------------------------------
matlabbatch{3}.spm.stats.con.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));
matlabbatch{3}.spm.stats.con.consess{1}.fcon.name   = 'Effects of interest';
matlabbatch{3}.spm.stats.con.consess{1}.fcon.convec = {eye(3)};
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name   = 'Photic';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [1 0 -1];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name   = 'Motion';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [0 1 -1];

spm_jobman('run',matlabbatch);
end
end
end


