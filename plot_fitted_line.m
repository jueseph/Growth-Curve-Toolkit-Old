function out = plot_fitted_line(fhandle,fo)
% 20111127
% 20120123
xrange = xlim;
yrange = ylim;
line = fo(xrange);
figure(fhandle);
hold all;
plot(xrange,line,'--','color',[0.5 0.5 0.5]);
ylim(yrange);
end