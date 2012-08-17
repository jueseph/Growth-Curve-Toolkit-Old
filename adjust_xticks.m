function out = adjust_xticks(ticks, n)
%ADJUST_XTICKS places an x tick mark at every number in TICKS and a tick
%label every N tick marks.
if exist('n')~=1
    n = 1;
end

ticklabels = {num2str(ticks(1))};
for c=1+n:n:length(ticks)
    for k=1:n-1
        ticklabels{end+1}='';
    end
    ticklabels{end+1} = num2str(ticks(c));
end

set(gca,'XTick',ticks);
set(gca,'XTickLabel',ticklabels);
