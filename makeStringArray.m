function [ array ] = makeStringArray( s, delim );

% make an array by tokenizing a string's tabs

tabs = strfind( s, delim );
array = [];
i1 = 0;

for i2=tabs
%    str = s(i1+1:i2-1);
    array{end+1} = s(i1+1:i2-1);
    i1 = i2;
end

array{end+1} = s(tabs(end)+1:length(s));