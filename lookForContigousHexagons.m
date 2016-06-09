function [ contigousHexagons ] = lookForContigousHexagons(x, y, mask)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    contigousHexagons = [];
    for i=1:size(x,1)
       x1 = x(i);
       y1 = y(i);
       x1 = x1 + 3; % 0 + 3
       if x1 <= size(mask, 1)
        contigousHexagons = [contigousHexagons; mask(x1, y1)];
       end
       y1 = y1 + 3; % +3 +3
       if y1 <= size(mask, 2) && x1 <= size(mask, 1)
        contigousHexagons = [contigousHexagons; mask(x1, y1)];
       end
       x1 = x(i); % +3 0
       if y1 <= size(mask, 2)
        contigousHexagons = [contigousHexagons; mask(x1, y1)];
       end
       x1 = x1 - 3; %+3 -3
       if x1 > 0 && y1 <= size(mask, 2)
        contigousHexagons = [contigousHexagons; mask(x1, y1)];
       end
       y1 = y(i); %0 -3
       if x1 > 0
        contigousHexagons = [contigousHexagons; mask(x1, y1)];
       end
       y1 = y1 - 3; % -3 -3
       if x1 > 0 && y1 > 0
        contigousHexagons = [contigousHexagons; mask(x1, y1)];
       end
       x1 = x(i); % -3 0
       if y1 > 0
        contigousHexagons = [contigousHexagons; mask(x1, y1)];
       end
       x1 = x1 + 3; %-3 +3
       if y1 > 0 && x1 <= size(mask,1)
        contigousHexagons = [contigousHexagons; mask(x1, y1)];
       end
    end
end

