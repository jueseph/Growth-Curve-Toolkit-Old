function h = plotwells(wells, allplates, varargin)
%   20120730
%   20120803 updated
%   tested on [t33] data, added optional params for [t34]
p = inputParser;
addRequired(p,'wells',@iscell);
if ischar(wells)
    wells = {wells};
end
addRequired(p,'allplates',@isstruct);
addParamValue(p,'t0',0,@isnumeric);
addParamValue(p,'xtranslate',[],@(h)isa(h, 'function_handle'));
addParamValue(p,'colorbyplate',false,@islogical);
addParamValue(p,'dolog',true,@islogical);
addParamValue(p,'dofit',false,@islogical);
addParamValue(p,'dobgsub',true,@islogical);
addParamValue(p,'bgwell','h2',@ischar);
addParamValue(p,'linestyle',{'o-','markersize',5,'linewidth',1},@iscell);

parse(p,wells,allplates,varargin{:});

t0 = p.Results.t0;
xtranslate = p.Results.xtranslate;
colorbyplate = p.Results.colorbyplate;
dolog = p.Results.dolog;
dofit = p.Results.dofit;
dobgsub = p.Results.dobgsub;
bgwell = p.Results.bgwell;
linestyle = p.Results.linestyle;

% plot group
colors = lines;
h = [];
for k=1:length(wells)
%     disp(['Now plotting ' wells{k}]);
    [r,c] = well2coord(wells{k});
    
    % get data
    for p = 1:length(allplates)
        t_vec = allplates(p).time;
        od_vec = allplates(p).data{r,c}.OD600;
        
        % background subtraction
        if dobgsub
            % H2 ismedia control
            [a,b] = well2coord(bgwell);
            ctwell = allplates(p).data{a,b}.OD600;
            od_vec = od_vec - median(ctwell(1:10));
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
            h(k) = plot( t_vec, od_vec , '-','linewidth',1,'color',color);
            hold all;

            % fit growth rate
            [fitcoefs fitline] = growthratefit(t_vec, od_vec, 5);
            plot(fitline(:,1),fitline(:,2),'-','linewidth',3,'color',color);
        else
            % x axis is time
            h(k) = plot( t_vec, od_vec , linestyle{:}, 'color',color);
            hold all;
            
            % x axis is read number
%         plot( od_vec , '.-', 'MarkerSize', 10,'linewidth',1,...
%             'color',colors(p-12,:));   
        end
    end
end

% ylim([-10, 0 ]);
% xlim([0 26]);
% adjust_xticks(-80:8:80,1);
grid on

% xlabel('time after inoculation (min)')
% ylabel('log2 OD')
% ylabel('OD (linear)')
