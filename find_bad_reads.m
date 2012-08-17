function [idx resid] = find_bad_reads(x, y, k, thresh)
%FIND_BAD_READS return indexes of OD measurements that look like noise. It
%computes the percent difference between each data point and a linear fit
%to a window of K data points. If the data point is more than THRESH
%percent (THRESH=1 is 100%) different from the sliding window fit, its index is returned.
%Works best on data that is mostly clean already.
%
%   Created 20120730 JW
%   Updated 20120807
%   tested on [t33] data
if exist('k')~=1
    k = 10; % window size
end
if exist('thresh')~=1
    thresh = 0.5; % residual threshold
end


k = 10;
N = length(x);
if k>N
    k = N;
end

resid = [];
warning off all
for c=1:N
    window = c-round(k/2)+1:c+floor(k/2);
    if window(1) < 1;
        window = 1:k;
    elseif window(end)>N
        window = N-k+1:N;
    end
    brob=robustfit(x(window),y(window));
    expected = brob(1)+brob(2).*x(c);
    resid(c) = (y(c) - expected)./expected;
%     plot(x(window),brob(1)+brob(2).*x(window),'-');
end
warning on all

idx=[];
for c=1:N
    if resid(c)>thresh || resid(c) < -thresh
        % flag data point to remove
        idx(end+1) = c;
    end
end