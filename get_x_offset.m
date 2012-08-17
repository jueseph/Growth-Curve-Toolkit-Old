function offset = get_x_offset(X,Y,x0,y0)
%GET_X_OFFSET calculates what needs to be added to all elements in X so
%that the plot of Y versus X goes through the point (x0,y0)

%% debug
% x0 = 0;
% y0 = -5;
% X = [1 12]
% Y = [-7 5]

idx = find(Y>y0);
if ~isempty(idx) && idx(1) >= 1
    idx = idx(1);
    m = (Y(idx)-Y(idx-1))./(X(idx)-X(idx-1));
    xp1 = (y0-Y(idx-1)+m.*X(idx-1))./m;
    offset = x0-xp1;
else
    offset = 0;
end
    
