function [ contigousHexagons ] = connectedHexagons( mask, i, j )
%CONNECTEDHEXAGONS It looks for contigous hexagons within the hexagonal mask having the position of one pixel.
%	We go through the 6 possible hexagons (1 for each side). In reality,
%   if we create the hexagonal grid with a number higher than 10, we'll only get 2 or 
%   three contigous hexagons. In smaller radius(apothem), we should get even the 6 
%   contigous hexagons. This script/function only want to traspass the existing sides
%   adding 1 to X and Y in all the existing possiblities.
%   Then we check if we go beyond the limits of the image and, if not, we add it to the 
%   contigousHexagons variable, which will end up as an edge between these two classes.
%	-Input-
%	mask: The mask of classes
%	i: pixel of axis X
%	j: pixel of axis Y
%	-Output-
%	contigousHexagons: a vector with the contigous classes.
%
%   Developed by Pablo Vicente-Munuera

	contigousHexagons = [];
	for i1 = i-1:i+1 
		%If it doesn't go beyond limits of the image
		if i1 > 0 && i1 < size(mask, 1)
			for j1 = j-1:j+1
				%If it doesn't go beyond limits of the image
				if j1 > 0 && j1 < size(mask, 2)
					%Append the new class
					contigousHexagons = [contigousHexagons;mask(i1,j1)];
				end
			end
		end
	end
	%We don't want duplicates
	contigousHexagons = unique(contigousHexagons);
	contigousHexagons(contigousHexagons==0) = [];
end
