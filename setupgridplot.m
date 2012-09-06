function[ hf ha] = setupgridplot(nrows, ncols, width, height)

    margbot = 50;
    margtop = 25;
    margleft = 50;
    margright = 25;
    gapvert = 50;
    gaphorz = 50;
    
    figwidth = margleft + margright + ncols*width + (ncols-1)*gaphorz;
    figheight = margbot + margtop + nrows*height + (nrows-1)*gapvert;
    
    hf = figure('name','Growth Curves','position',[0 0 figwidth figheight]);
%     h = tight_subplot(3,3,[.05 .05],[.07 .03],[.02 .01]);
    ha = tight_subplot(nrows,ncols,[gapvert gaphorz],[margbot margtop],[margleft margright],'pixels');
    set(hf,'color','w')
    set(0,'defaulttextinterpreter','none')
    
end