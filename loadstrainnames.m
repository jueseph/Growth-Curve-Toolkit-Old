function strnames = loadstrainnames(filename)
%LOADSTRAINNAMES
%
%   20120801
%   20120803 updated to change blank wells to 'EMPTY'

strnames=csv2cell(filename);
if size(strnames,1)<8 || size(strnames,2)<12
    strnames{8,12}='';
end
strnames=strnames(1:8,1:12);

for c=1:numel(strnames)
    if isempty(strnames{c})
        strnames{c} = 'EMPTY';
    end
end