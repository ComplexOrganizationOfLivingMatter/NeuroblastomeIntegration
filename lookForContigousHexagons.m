function [ contigousHexagons ] = lookForContigousHexagons(x, y, mask)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    contigousHexagons = [];
    for i=1:size(x,1)
       x1 = x(i);
       y1 = y(i);
       x1 = x1 + 3; % 0 + 3
       contigousHexagons = [contigousHexagons; mask(x1, y1)];
       y1 = y1 + 3; % +3 +3
       contigousHexagons = [contigousHexagons; mask(x1, y1)];
       x1 = x(i); % +3 0
       contigousHexagons = [contigousHexagons; mask(x1, y1)];
       x1 = x1 - 3; %+3 -3
       contigousHexagons = [contigousHexagons; mask(x1, y1)];
       y1 = y(i); %0 -3
       contigousHexagons = [contigousHexagons; mask(x1, y1)];
       y1 = y1 - 3; % -3 -3
       contigousHexagons = [contigousHexagons; mask(x1, y1)];
       x1 = x(i); % -3 0
       contigousHexagons = [contigousHexagons; mask(x1, y1)];
       x1 = x1 + 3; %-3 +3
       contigousHexagons = [contigousHexagons; mask(x1, y1)];
    end
end

