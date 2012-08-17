function [ data ] = readEnvisionFile( dir, file_name )

% this function opens a CSV output file from an envision read and returns
% the data within it 
% NOTE: it does not parse the creation date/time of the file 

try
    % try to open the file

    fid = fopen( strcat( dir, '/', file_name) );
    if fid == -1
        % if cannot open the file
        if ~exist(file_name)
            error('readGCfile:CannotFindFile','%s does not appear to exist.',file_name)
        end
    else
        
        line_num = 0; % keep track of the line number
        
        while 1

            line = fgetl(fid);
                    
            if ~ischar(line)
                break
            end

            % reset the count
            if( size( regexp( line, 'Background information' ) ) )             
                
                line_num = 1;
               
            elseif( line_num == 1 ) % don't need this line
                    
                line_num = 2;
                
            elseif( line_num == 2 ) % get the field name
                
                line_num = 3;               
                a = makeStringArray( line, char(44) );
                field = a{2};

            elseif( line_num == 3  )
                
                line_num = line_num + 1;
 
                % this populates the field's data
                field = regexprep( field, 'IW-', '' );
                data.(field) = readEnvisionData( fid );

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
 