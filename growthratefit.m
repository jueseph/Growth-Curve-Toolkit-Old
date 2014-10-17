function [fitcoefs, fitline] = growthratefit(X, Y, H, startH)
%GROWTHRATEFIT calculates a growth rate from a growth curve by fitting a
%line to successive windows of points that comprise H time units of data.
%
%   20120731 JW
%   20121017 JW
if length(X)~=length(Y)
    error('X and Y must have same number of data points.');
end

if exist('startH')~=1
    startH = 3;
end

%% debug
% X = 1:10;
% Y = X.^2;
% H = 4;
% figure,plot(X,Y,'.')

N = length(X);
fitarray = struct;

warning off all
start = 1;
% exclude first startH hours
for start=1:N
    if X(start)>=startH
        break;
    end
end

% fit all possible sliding windows
% don't take too short of a fit
for c=start:N
    for cend = start+1:N
        if X(cend)-X(c) > H
            break;
        end
    end
    idx=c:cend;
    
    if length(idx)<5
        fitarray(c).slope = -1;
    else
        b = robustfit(X(idx), Y(idx));
        
        fitarray(c).idx = idx;
        fitarray(c).intercept = b(1);
        fitarray(c).slope = b(2);
        
    end

    if cend==N
        break;
    end
end
fitarray(1:start-1)=[];
warning on all

% choose largest slope as best fit
[~, idxmax] = max([fitarray.slope]);
fitcoefs = [fitarray(idxmax).intercept fitarray(idxmax).slope];

% line through best-fit window
idx = fitarray(idxmax).idx;
fitline = [X(idx([1 end]))' fitcoefs(1)+fitcoefs(2).*X(idx([1 end]))'];
