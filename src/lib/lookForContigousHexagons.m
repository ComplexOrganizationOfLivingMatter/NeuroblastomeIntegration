function [ contigousHexagons ] = lookForContigousHexagons(x, y, mask)
%LOOKFORCONTIGOUSHEXAGONS Within the hexagonal mask having the position of one class
%   We go through the 6 possible hexagons (1 for each side). In reality,
%   if we create the hexagonal grid with a number higher than 10, we'll only get 2 or 
%   three contigous hexagons. In smaller radius(apothem), we should get even the 6 
%   contigous hexagons. This script/function only want to traspass the existing sides
%   adding 3 to X and Y in all the existing possiblities.
%   Then we check if we go beyond the limits of the image and, if not, we add it to the 
%   contigousHexagons variable, which will end up as an edge between these two classes.
%   -Input-
%   x: The pixel positions X of a given hexagon (or class)
%   y: The pixel positions Y of a given hexagon (or class)
%   mask: The hexagonal mask, each hexagon has 0 as sides and the class number
%   as the inner hexagon
%   -Output-
%   contigousHexagons: a vector with the contigous classes.
%
%   Developed by Pablo Vicente-Munuera

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

