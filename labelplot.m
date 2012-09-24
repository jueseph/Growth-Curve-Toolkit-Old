function out = labelplot(plotlabel,textoptions)
%LABELPLOT labels a plot.
% 20120803
set(gca,'units','pixels');
if exist('textoptions')~=1
    textoptions={};
end
dim = get(gca,'position');
wd = dim(3);
ht = dim(4);

hspace = min(max(wd./20, 10),20);
vspace = min(max(ht./10, 10),20);


if ~isempty(plotlabel)
    if strcmp('EMPTY',plotlabel)
        % gray out empty wells
        set(gca,'color',[.8 .8 .8]);
    else
        % label plot
        text(hspace,ht-vspace,plotlabel,'units','pixels','fontsize',min(16,Fontsize_cal(gca,8)),textoptions{:});
    end
end

set(gca,'units','normalized');