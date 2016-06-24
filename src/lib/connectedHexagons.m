function [ v ] = connectedHexagons( Img, i, j )
%CONNECTEDHEXAGONS Summary of this function goes here
%   Detailed explanation goes here
    v = [];
    for i1 = i-1:i+1 
       if i1 > 0 && i1 < size(Img, 1)
           for j1 = j-1:j+1
               if j1 > 0 && j1 < size(Img, 2)
                v = [v;Img(i1,j1)];
               end
           end
       end
    end
    v = unique(v);
    v(v==0) = [];
end

