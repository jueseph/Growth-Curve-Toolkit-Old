function platedata = reformat_ilan_data(GC_data,t0)
% 20120730
platedata = struct;

if length(t0)==1
    t0 = repmat(t0, length(GC_data),1);
end

idxout = 1;
for idxin=1:length(GC_data)
    if ~isempty(GC_data(idxin).name)
        platedata(idxout).name = GC_data(idxin).name{1};
    end
    if isempty(GC_data(idxin).data)
        disp(['Plate ' num2str(idxin) ' of input data structure is empty. ' ...
            'Omitting from output.']);
        continue;
    end
    platedata(idxout).data = cell(8,12);
    
    for r=1:8
        for c=1:12
            platedata(idxout).data{r,c} = struct;
            % time relative to t0
            t = cell2mat(GC_data(idxin).time) - t0(idxin);
            platedata(idxout).time = t * 24; % to hours
            
            N = length(platedata(idxout).time);
            
            fns = fieldnames(GC_data(idxin).data{1});
            
            for k = 1:N
                for ifn = 1:length(fns)
                    platedata(idxout).data{r,c}.(fns{ifn})(k) = ...
                        GC_data(idxin).data{k}.(fns{ifn})(r,c);
                end
            end
        end
    end
    
    idxout = idxout + 1;
end
