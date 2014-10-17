function renamegcdata(datadir,oneplate)
%RENAMEGCDATA renames growth curve output files
% 
%   Created 20120914
if exist('oneplate') ~=1
    oneplate = false;
end

fn = dir([datadir '*.csv']);
fn = {fn.name};

for c=1:length(fn)
    f = fn{c};
    tokens = regexp(f,'_','split');
    
    if oneplate 
        % change all plate names to plate 1
        tokens{2}(end)='1';
    else
        if length(tokens)>=7
            % longer filename (with fluorescence)
            tokens{2}(end)=tokens{7}(end);
        elseif length(tokens)==6
            % just OD
            tokens{2}(end)=tokens{5}(end);
        end
    end
    
    newf = strjoin(tokens,'_');
    disp([f '->' newf]);
    if ~strcmp(f,newf)
        movefile([datadir f],[datadir newf]);
    end
end