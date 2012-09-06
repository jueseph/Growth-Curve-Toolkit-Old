function savefig(fn)
global figdir;
export_fig([figdir getfigname(fn)],'-png');
figdir