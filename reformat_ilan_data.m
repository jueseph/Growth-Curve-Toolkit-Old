function platedata = reformat_ilan_data(GC_data)
% 20120730
platedata = struct;

for p=1:length(GC_data)
    platedata(p).name = GC_data(p).name{1};
    platedata(p).data = cell(8,12);
    
    for r=1:8
        for c=1:12
            platedata(p).data{r,c} = struct;
            platedata(p).time = cell2mat(GC_data(p).time);
            
            N = length(platedata(p).time);
            
            for k = 1:N
                platedata(p).data{r,c}.OD600(k) = GC_data(p).data{k}.OD600(r,c);
            end
        end
    end
end
