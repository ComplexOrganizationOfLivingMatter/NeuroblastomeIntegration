function [ v ] = connectedHexagons( Img, i, j )
%CONNECTEDHEXAGONS Summary of this function goes here
%   Detailed explanation goes here
    v = [];
    for i1 = i-1:i+1
       for j1 = j-1:j+1
          v = [v;Img(i1,j1)]; 
       end
    end
    v = unique(v);
    v(v==0) = [];
end

