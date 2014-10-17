function alignfunc = getgcalignment(t0, od0)
% 20120924
alignfunc = @(X,Y) X+get_x_offset(X,Y, t0, od0);