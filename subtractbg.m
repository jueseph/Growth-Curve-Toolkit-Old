function odnew = subtractbg(odraw, bg)
% 20131102
% subtract a fixed background from od data and take log 2. anything that's negative gets
% turned into 2^-10

odnew = max(odraw-bg,2^-10);
odnew = log2(odnew);