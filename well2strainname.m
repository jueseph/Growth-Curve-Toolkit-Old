function names = well2strainname(strnames, wells)
%WELL2STRAINNAME converts a cell array of well addresses to a list of
%strain names.
%
%   Created 20120814 JW
names = {};
[rows cols] = well2coord(wells);
for k=1:length(rows)
    names{k} = strnames{rows(k), cols(k)};
end