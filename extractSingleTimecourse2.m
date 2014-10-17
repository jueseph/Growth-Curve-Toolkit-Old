function [ data_points, time_points ] = extractSingleTimecourse( r, c, plate, field )

% extracts all the measurments for a particular well across time of a given
% type (defined by the field parameter)

%display( strcat( 'Extracting time course for well', num2str(r), ',', num2str(c), ' in plate ', plate.name ) );

num_points = size( plate.data, 2 );
data_points = zeros( num_points, 1 );
t0 = plate.time{ 1 };

for i=1:num_points
%    l = str2num( exp( i ).data.(field){ r, c } )
    data_points( i ) = plate.data{i}.(field)( r, c );
    elapsed = etime( datevec(datenum( plate.time{i})), datevec(t0) );
    time_points( i ) = ( elapsed / 60 );
%    t0 = datenum( plate.time{i} );
end

