function [ data ] = readEnvisionData( fid )

% this function is called by the readEnvisionFile function each time a new
% matrix of data envision data needs to ne read. it assumes that the reads
% are 8x12 dimensional

background = [0];
data = zeros( 8, 12 );
for row = 1:1:8
    line = fgetl(fid);
    a = makeStringArray( line, char(44) );
    for col = 1:1:12
        if( str2num( cell2mat(a(col)) ) < 0.05 )
           background(end+1) = str2num( cell2mat(a(col)) );
        end
        data( row, col ) = str2num( cell2mat(a(col)) );
    end
end

%data = data - mean(background);
%data( find( data < 0.005 ) ) = 0.005;