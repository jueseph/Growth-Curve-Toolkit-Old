function[ hf ha] = setupgridplot(varargin)
%SETUPGRIDPLOT creates a figure with a grid of NROWS x NCOLS plots, each of
%which is WIDTH pixels wide and HEIGHT pixels high. Margins and gaps are
%hard-coded for a typical screen setup to leave room for axes labels
% 
%   Created 20120912 JW
%   Updated 20120927 JW
%   Updated 20131101 JW renamed to 'gridplot', now just redirecting to that
%   function.

[hf ha] = gridplot(varargin{:});