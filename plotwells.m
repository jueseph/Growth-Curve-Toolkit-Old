function [h gr] = plotwells(wells, allplates, varargin)
%   20120730
%   20120803 updated
%   tested on [t33] data, added optional params for [t34]
parser = inputParser;
addRequired(parser,'wells',@iscell);
if ischar(wells)
    wells = {wells};
end
addRequired(parser,'allplates',@isstruct);
addParamValue(parser,'t0',0,@isnumeric);
addParamValue(parser,'xtranslate',[],@(h)isa(h, 'function_handle'));
addParamValue(parser,'colorbyplate',false,@islogical);
addParamValue(parser,'dolog',true,@islogical);
addParamValue(parser,'dofit',false,@islogical);
addParamValue(parser,'dobgsub',true,@islogical);
addParamValue(parser,'bgval',0,@isnumeric);
addParamValue(parser,'bgwell','',@(x) true);
addParamValue(parser,'linestyle',{'o-','markersize',5,'linewidth',1},@iscell);
addParamValue(parser,'fitwindow',2,@isnumeric);

parse(parser,wells,allplates,varargin{:});
t0 = parser.Results.t0;
xtranslate = parser.Results.xtranslate;
colorbyplate = parser.Results.colorbyplate;
dolog = parser.Results.dolog;
dofit = parser.Results.dofit;
dobgsub = parser.Results.dobgsub;
bgval = parser.Results.bgval;
bgwell = parser.Results.bgwell;
linestyle = parser.Results.linestyle;
fitwindow = parser.Results.fitwindow;

% plot group
colors = lines;
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
        
        % plot time relative to t0
        t_vec = t_vec - t0;
        t_vec = t_vec * 24; % to hours
        
        % log transform
        if dolog
            od_vec = log2(od_vec);
        end
        
        % x-translate
        if ~isempty(xtranslate)
            t_vec = xtranslate(t_vec,od_vec);
        end
        
        % show colors by plate or by well
        if colorbyplate
            color = colors(p,:);
        else
            color = colors(k,:);
        end
        
        % plot growth curve
        if dofit
            % x axis is time
            h(k,p) = plot( t_vec, od_vec , '-','linewidth',1,'color',color);
            hold all;

            % fit growth rate
            [fitcoefs fitline] = growthratefit(t_vec, od_vec, fitwindow);
            gr(k,p) = fitcoefs(:,2);
            plot(fitline(:,1),fitline(:,2),'-','linewidth',3,'color',color);
        else
            % x axis is time
            h(k,p) = plot( t_vec, od_vec , linestyle{:}, 'color',color);
            hold all;
            
            % x axis is read number
%         plot( od_vec , '.-', 'MarkerSize', 10,'linewidth',1,...
%             'color',colors(p-12,:));   
        end
    end
end

% labelplot(num2str(gr))
% ylim([-10, 0 ]);
% xlim([0 26]);
% adjust_xticks(-80:8:80,1);
grid on

% xlabel('time after inoculation (min)')
% ylabel('log2 OD')
% ylabel('OD (linear)')
