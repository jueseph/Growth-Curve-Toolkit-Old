function allplates = loadGrowthcurvatronData( datadir )
% goes through all the Envision GC files in a directory and
% reads them in one by one. 

% 20140618

% get names of files in data folder, sorted by date
filenames = dir([datadir '*.csv']);
[ ~, idx ] = sort( [ filenames.datenum ] );
filenames = {filenames( idx ).name};

% initialize data structures
allplates = struct;
counts = [];
reverseStr = 0;

for ifn = 1:length(filenames)
    % display progress
    msg = sprintf('Processed %d of %d...', ifn, length(filenames));
    fprintf([reverseStr, msg]);
    reverseStr = repmat(sprintf('\b'), 1, length(msg));
   
    % determine plate number
    filename = filenames{ifn};  
    tokens = regexp(filename,'Plate(\d+)','tokens');
    iplate = str2num(tokens{1}{1});
        
    % increment the number of reads for this plate
    if iplate > length(counts)
        counts(iplate) = 0;
    end
    counts(iplate) = counts(iplate) + 1;

    % get the plate data
    filedata = csv2cell([datadir filename]);

    irow = 1;
    while irow <= size(filedata,1)
        if strcmp('Background information',filedata{irow, 1})
            % name of fluorescence channel
            channame = filedata{irow+2, 2};
            channame = regexprep( channame, 'IW-', '' );
            
            % grab data for this channel
            fielddata = cell2mat(filedata((irow+4):(irow+11), 1:12));
            allplates(iplate).(channame)(:,:,counts(iplate)) = fielddata;
            
            % go on to next block of data
            irow = irow + 12;
            
        elseif strcmp('Assay Finished: ',filedata{irow, 1})
            allplates(iplate).time(counts(iplate)) = datenum(filedata{irow,5});
            break;
        else
            irow = irow + 1;
        end
    end
end
fprintf('\n');
