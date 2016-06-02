function [ adjacencyMatrix ] = GetCompleteGraphWithMinimumDistances( distanceBetweenClusters, adjacencyMatrix, C, bg)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    while conncomp(bg) == 1
        [rowMin, colMin] = find(distanceBetweenClusters == min(distanceBetweenClusters));
        adjacencyMatrix(rowMin, colMin) = distanceBetweenClusters(rowMin, colMin);
        adjacencyMatrix(colMin, rowMin) = distanceBetweenClusters(rowMin, colMin);
        
        distanceBetweenClusters(rowMin, colMin) = intmax('int8');
    end
end

