function groupstruct = get_strain_groups(strain_names)
% 20120730
groupstruct = struct;
for r=1:8
    for c=1:12
        sn = strain_names{r,c};
        if isempty(sn)
            if ~isfield(groupstruct,'EMPTY')
                groupstruct.EMPTY = {};
            end
            groupstruct.EMPTY = [groupstruct.EMPTY coord2well(r,c)];
        else
            sn = underscorify(sn,1);
            if ~isfield(groupstruct, sn)
                groupstruct.(sn) = {};
            end
            groupstruct.(sn) = [groupstruct.(sn) coord2well(r,c)];
        end
    end
end
                
            