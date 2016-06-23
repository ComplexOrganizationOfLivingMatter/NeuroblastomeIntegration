function [ adjacencyMatrix ] = GetGraphWithRadiousDistance(distanceBetweenObjects , adjacencyMatrix, radius)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    mDistanceBetweenObjects = squareform(distanceBetweenObjects);
    mDistanceBetweenObjects(logical(eye(size(distanceBetweenObjects)))) = intmax('int32');
    pairsWithinRadius = mDistanceBetweenObjects <= radius;
    pairsWithinRadius(logical(eye(size(pairsWithinRadius)))) = 0;
    adjacencyMatrix = adjacencyMatrix | pairsWithinRadius;
end

