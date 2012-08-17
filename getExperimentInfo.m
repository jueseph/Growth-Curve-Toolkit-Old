function [ experiments ] = getExperimentInfo( file_name )

try
    % Go through the PARAMETER file which describes each plate (e.g. media)
    fid = fopen(file_name);
    if fid == -1
        % if cannot open the file
        if ~exist(file_name)
            error('readGCfile:CannotFindFile','%s does not appear to exist.',file_name)
        end
    else

        line_num = 0;
        
        while 1
            line = fgetl(fid);
            line_num = line_num + 1;
            
            if ~ischar(line)
                break
            end
            % the 'experiment' description from the PARAMETER file
            experiments{ line_num } = line;
        end
    end
    fclose(fid);
catch ME
     if ~ischar(file_name)
        error('readGCfile:InvalidInput','Input must be a character array')
    end
    ME
    
end