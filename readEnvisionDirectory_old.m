function [ GC_data, all_data, all_times ] = readEnvisionDirectory( dir_name, num_experiments, beta )

% this script goes through all the Envision GC files in a directory and
% reads them in one by one. It uses the parameters in the ParameterFile to
% obtain the number of plates and assign the conditions (e.g. media type,
% dilution factor) to each plate. 

% TODO:
% take in another file that contains the strain information for each well
% in the plates
dir_name
try
    file_dir=dir([dir_name,'*.csv']); %This makes sure that only CSV files are read
catch
    
end

% how many plates were there
% argument 'experiments' removed by JW 20120124
% num_experiments = size( experiments, 2 );
counts = zeros(num_experiments);    % this will keep track of how many reads per plate

[ unused, order ] = sort( [ file_dir(:).datenum ] );
sorted_file_dir = file_dir( order ); % the files sorted by date

%filedir

time_point = 0;

%t_vec = zeros(size(sorted_file_dir)/4);
t_vec = [];
%t0 = datevec(sorted_file_dir(1).date);

for f=1:length(sorted_file_dir)

    file_name = sorted_file_dir(f).name;
    if( regexp( file_name, 'initial' ) )
       continue;
    end
      
    % first determine which plate this read is from
    file_name_array = regexp( file_name, '\_', 'split' );
    
    % parse the plate file name data
    plate_name = strcat( file_name_array(1), file_name_array(2) );
    plate_index = str2num(file_name_array{2});
    
%    experiment = expierments{plate_index};
    
    % get the plate data
    [ plate_data ] = readEnvisionFile( dir_name, file_name );
    
    % increment the number of reads for this plate
    counts( plate_index ) = counts( plate_index ) + 1;
        
     if( counts( plate_index ) == 1 )
         t0(plate_index,:) = datevec(sorted_file_dir(f).date);
         %t0_data(plate_index) = plate_data;
     end
    
     % this is currently irrelevant- gets calculated later
    t_vec( plate_index, counts(plate_index) ) = etime( datevec(sorted_file_dir(f).date), t0(plate_index,:) ) / 60;

    % correct the OD saturation
%     plate_data.OD600 = mm_correction( beta, plate_data.OD600 ); % - t0_data(plate_index).OD600;
    all_data( plate_index, counts(plate_index), : ) = reshape( plate_data.OD600, 1, 96 );
    
    % populate the struct that will contain all the data
    GC_data( plate_index ).time{ counts( plate_index ) } = datenum(sorted_file_dir(f).date);
    GC_data( plate_index ).data{ counts( plate_index ) } = plate_data;
    GC_data( plate_index ).name = plate_name; %experiments( plate_index );
%    GC_data( plate_index ).experiment = experiment;
    
end

all_times = t_vec;
%plot( [1:1:size(t_vec)],t_vec )

