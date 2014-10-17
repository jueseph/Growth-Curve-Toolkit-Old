function [ data ] = readEnvisionFile( file_name )

% this function opens a CSV output file from an envision read and returns
% the data within it 
% NOTE: it does not parse the creation date/time of the file 

data = struct;

try
    % try to open the file

    fid = fopen( file_name );
    if fid == -1
        % if cannot open the file
        if ~exist(file_name)
            error('readGCfile:CannotFindFile','%s does not appear to exist.',file_name)
        end
    else
        while 1

            line = fgetl(fid);
                    
            if ~ischar(line)
                break
            end

            % encountered a new fluorescence channel
            if( size( regexp( line, 'Background information' ) ) )             
                
                line = fgetl(fid);
                line = fgetl(fid);
          
                a = makeStringArray( line, char(44) );
                field = a{2};
 
                % this populates the field's data
                field = regexprep( field, 'IW-', '' );
                data.(field) = readEnvisionData( fid );
                
            elseif( size( regexp( line, 'Assay Finished:' ) ) )
                disp(line);
            end
        end
    end
    fclose(fid);
    
catch ME
    ME.message
    if ~ischar(file_name)
        error('readGCfile:InvalidInput','Input must be a character array')
    end
 
end
 