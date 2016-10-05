function [ distanceMatrix ] = generateRandomPointsInsideCircle(maxPoints)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    x1 = 0;
    y1 = 0;
    rc = 100;

    x(1) = 0;
    y(1) = 0;
    for i = 1:maxPoints-1
        a = 2*pi*rand;
        r = sqrt(rand);
        x = [x; (rc*r)*cos(a) + x1];
        y = [y; (rc*r)*sin(a) + y1];
    end
    distanceMatrix = pdist([x, y], 'euclidean');
    distanceMatrix = squareform(distanceMatrix);
end

