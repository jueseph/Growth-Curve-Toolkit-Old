function [h gr] = plotwellsold(wells, allplates, varargin)
%   20120730
%   20120803 updated
%   20120926 removed t0. make sure to use reformat_ilan_data
parser = inputParser;
addRequired(parser,'wells',@iscell);
if ischar(wells)
    wells = {wells};
end
addRequired(parser,'allplates',@isstruct);
addParamValue(parser,'bgval',0,@isnumeric);
addParamValue(parser,'bgwell','',@(x) true);
addParamValue(parser,'colorbyplate',false,@islogical);
addParamValue(parser,'color',[],@isnumeric);
addParamValue(parser,'dofit',false,@islogical);
addParamValue(parser,'dolog',true,@islogical);
addParamValue(parser,'dobgsub',true,@islogical);
addParamValue(parser,'fitwindow',2,@isnumeric);
addParamValue(parser,'fitfunc',@growthratefit,@(x)isa(x,'function_handle'));
addParamValue(parser,'linestyle',{'o-','markersize',5,'linewidth',1},@iscell);
addParamValue(parser,'makeplot',true,@islogical);
addParamValue(parser,'xtranslate',[],@(h)isa(h, 'function_handle'));

parse(parser,wells,allplates,varargin{:});
xtranslate = parser.Results.xtranslate;
color = parser.Results.color;
colorbyplate = parser.Results.colorbyplate;
dolog = parser.Results.dolog;
dofit = parser.Results.dofit;
dobgsub = parser.Results.dobgsub;
bgval = parser.Results.bgval;
bgwell = parser.Results.bgwell;
linestyle = parser.Results.linestyle;
makeplot = parser.Results.makeplot;
fitwindow = parser.Results.fitwindow;
fitfunc = parser.Results.fitfunc;

% plot group
if makeplot, colors = lines; end
h = [];
gr = [];
for k=1:length(wells)
%     disp(['Now plotting ' wells{k}]);
    [r,c] = well2coord(wells{k});
    
    % get data
    for p = 1:length(allplates)
        t_vec = allplates(p).time;
        od_vec = allplates(p).data{r,c}.OD600;
        
        % background subtraction
        if dobgsub
            if ~isempty(bgwell)
                [a,b] = well2coord(bgwell);
                ctwell = allplates(p).data{a,b}.OD600;
                bgval = median(ctwell(1:min(end,10)));
            end
            od_vec = od_vec - bgval;
            od_vec(od_vec<2e-10) = 2^-10;
        end
        
        % log transform
        if dolog
            od_vec = log2(od_vec);
        end
        
        % x-translate
        if ~isempty(xtranslate)
            t_vec = xtranslate(t_vec,od_vec);
        end
        
        % show colors by plate or by well
        if ~isempty(color)
            plotcolor = color;
        elseif colorbyplate && makeplot
            plotcolor = colors(p,:);
        elseif makeplot
            plotcolor = colors(k,:);
        end
        
        % plot growth curve
        if dofit
            % x axis is time
            if makeplot 
                h(k,p) = plot( t_vec, od_vec , '-','color',plotcolor);
                
%                 h(k,p) = plot(od_vec , linestyle{:},'color',color);
                hold all;
            end

            % fit growth rate
            [fitcoefs fitline] = fitfunc(t_vec, od_vec, fitwindow,2);
            gr(k,p) = fitcoefs(:,2);
            if makeplot
                plot(fitline(:,1),fitline(:,2),'.','markersize',10,'color',plotcolor);
            end
        elseif makeplot
            % x axis is time
            h(k,p) = plot( t_vec, od_vec , linestyle{:}, 'color',plotcolor);
            
%             h(k,p) = plot( od_vec , linestyle{:}, 'color',plotcolor);
            hold all;
        end
    end
end

if makeplot, grid on; end

