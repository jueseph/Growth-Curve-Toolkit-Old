function meta = load96wmeta(filename)
%LOAD96WMETA
%
%   20120801
%   20120803 updated to change blank wells to 'EMPTY'
%   20120821 can now load a sequence of files
%   20120920 renamed loadstrainnames->load96wmeta

meta=csv2cell(filename);
if size(meta,1)<8 || size(meta,2)<12
    meta{8,12}='';
end
meta=meta(1:8,1:12);

for c=1:numel(meta)
    if isempty(meta{c})
        meta{c} = 'EMPTY';
    end
end