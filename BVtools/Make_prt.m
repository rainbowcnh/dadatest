% This program is used for producing .prt file in Brainvoyager, given 
% a set of predetermined sequence for Block-design fMRI.

% Written by Nihong Chen, 2011


interval = 6;                                                              % the number of TR during each blank interval
disp = 6;                                                                  % the number of TR during each stimuli display interval
colo = [255  0   0
    0   255  0
    0    0  255
    255  0  255
    255  255 0
    0 255 255
    100 0 0
    0 100 0
    0 0 100
    100 100 0];


seq=[3     2     4     3+4     4+4     1     1+4     2+4                    % each line produce a prt for a fMRI run
     1     4     3     4+4     2     1+4     3+4     2+4     
     2     2+4     3     3+4     4     1     1+4     4+4
     2     3     4     1     4+4     1+4     2+4     3+4
     3     4     1     1+4     2     2+4     4+4     3+4
     3     4     4+4     2     1     1+4     2+4     3+4
     4     3     4+4     2     3+4     2+4     1     1+4
     3     2     3+4     4     4+4     2+4     1     1+4
     1     2     3     1+4     3+4     4     2+4     4+4
     2     3     4     1     1+4     4+4     2+4     3+4
     1     4     3     2     1+4     3+4     2+4     4+4];
cond = max(seq(1,:));
run = size(seq,1);
block = size(seq,2);
% blank = (1 : interval+disp: 1+(interval+disp)*block);
for i = 1:11
    name = ['run' int2str(i) '.prt'];
    fid = fopen(name,'w+');
    fprintf(fid, '%s\n','')
    fprintf(fid, '%s\n', 'FileVersion:        2');
    fprintf(fid, '%s\n','')
    fprintf(fid, '%s\n','ResolutionOfTime:   Volumes')
    fprintf(fid, '%s\n','')
    fprintf(fid, '%s\n','Experiment:         run2')
    fprintf(fid, '%s\n','')
    fprintf(fid, '%s\n','BackgroundColor:    0 0 0')
    fprintf(fid, '%s\n','TextColor:          255 255 255')
    fprintf(fid, '%s\n','TimeCourseColor:    255 255 255')
    fprintf(fid, '%s\n','TimeCourseThick:    3')
    fprintf(fid, '%s\n','ReferenceFuncColor: 0 0 80')
    fprintf(fid, '%s\n','ReferenceFuncThick: 3')
    fprintf(fid, '%s\n','')
    
    fprintf(fid, '%s%d\n','NrOfConditions:  ', cond+1)
    
    fprintf(fid, '%s\n','blank')
    fprintf(fid, '%d\n', block+1)
    ind=zeros(cond);
    re=floor(block/cond);
    recor= zeros(cond,re,2);
    for j = 1: block
        fprintf(fid, '%d   %d\n', (j-1)*(interval+disp)+1, (j-1)*(interval+disp)+interval);
        ind(seq(i,j)) = ind(seq(i,j)) + 1;
        k =  ind(seq(i,j));
        a = [(j-1)*(interval+disp)+1+interval (j-1)*(interval+disp)+interval+disp];
        recor(seq(i,j),k,:)=a(:);
    end;
    j=j+1;
    fprintf(fid, '%d   %d\n', (j-1)*(interval+disp)+1, (j-1)*(interval+disp)+interval);
    fprintf(fid, '%s%d %d %d\n','Color:  ', 195, 195, 195);
    
    
    for j= 1: cond
        fprintf(fid, '%s\n','');
        fprintf(fid, '%s%d\n','d',j);
        fprintf(fid, '%d\n', re);
        for k=1:re
            fprintf(fid, '%d   %d\n', recor(j,k,1), recor(j,k,2));
        end;
        fprintf(fid, '%s%d %d %d\n','Color:  ', colo(j,1), colo(j,2), colo(j,3));
    end;
    
    fclose(fid);
end;