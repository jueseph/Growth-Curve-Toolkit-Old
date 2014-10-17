function newplates = removegcdatapoint(allplates,p,n)
%REMOVEGCDATAPOINT
% 
%   20121023
newplates = allplates;
for r=1:8
    for c=1:12
        newplates(p).data{r,c}.OD600(n) = [];
    end
end
newplates(p).time(n) = [];

