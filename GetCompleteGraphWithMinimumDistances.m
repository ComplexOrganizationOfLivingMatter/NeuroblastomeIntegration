function [ adjacencyMatrix ] = GetCompleteGraphWithMinimumDistances( distanceBetweenClusters, adjacencyMatrix, C)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    mDistanceBetweenClusters = squareform(distanceBetweenClusters);
    mDistanceBetweenClusters(logical(eye(size(mDistanceBetweenClusters)))) = intmax('int8');

    adjacencyMatrix = sparse(adjacencyMatrix);
    while graphconncomp(adjacencyMatrix) > 1
        [rowMin, colMin] = find(mDistanceBetweenClusters == min(mDistanceBetweenClusters(:)), 1);
        class1 = find(C == rowMin, 1);
        class2 = find(C == colMin, 1);
        adjacencyMatrix(class1, class2) = mDistanceBetweenClusters(rowMin, colMin);
        adjacencyMatrix(class2, class1) = mDistanceBetweenClusters(rowMin, colMin);
        
        mDistanceBetweenClusters(rowMin, colMin) = intmax('int32');
        mDistanceBetweenClusters(colMin, rowMin) = intmax('int32');
    end
end

