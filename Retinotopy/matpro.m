function [im params] = matpro(matname)
eval(['load ' matname]);
for i = 1:params.numImages;
    eval(['im{i} = img' int2str(i) ';']);
end


