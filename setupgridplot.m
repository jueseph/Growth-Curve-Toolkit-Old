function[ hf ha] = setupgridplot(nrows, ncols, width, height)
%SETUPGRIDPLOT creates a figure with a grid of NROWS x NCOLS plots, each of
%which is WIDTH pixels wide and HEIGHT pixels high. Margins and gaps are
%hard-coded for a typical screen setup to leave room for axes labels
% 
%   Created 20120912 JW

margbot = 50;
margtop = 25;
margleft = 60;
margright = 25;
gapvert = 50;
gaphorz = 50;

figwidth = margleft + margright + ncols*width + (ncols-1)*gaphorz;
figheight = margbot + margtop + nrows*height + (nrows-1)*gapvert;

hf = figure('position',[0 0 figwidth figheight]);
%     h = tight_subplot(3,3,[.05 .05],[.07 .03],[.02 .01]);
ha = tight_subplot(nrows,ncols,[gapvert gaphorz],[margbot margtop],[margleft margright],'pixels');
set(hf,'color','w')
set(0,'defaulttextinterpreter','none')
    
end