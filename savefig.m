function savefig(fn,format)
%SAVEFIG saves a figure with filename FN (with a date and time stamp
%appended) in a figure folder defined by the global variable FIGDIR in
%format FORMAT.
%
%   Created 20120912
global figdir;

if exist('format')~=1
    format = '-png';
end
export_fig([figdir getfigname(fn)],format);