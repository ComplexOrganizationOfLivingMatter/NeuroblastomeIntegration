function [ adjacencyMatrixComplete ] = minimumDistanceBetweenNeighbourGraph( image )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%http://stackoverflow.com/questions/31388681/distance-between-connected-components?answertab=votes#tab-top
Img = im2bw(image, 0.2);

C = bwlabel(Img);

S = regionprops(C,'Centroid');

Centroids = vertcat(S.Centroid);

%// Measure pairwise distance
distanceBetweenObjects = pdist(Centroids,'euclidean');

adjacencyMatrixComplete = GetCompleteGraphWithMinimumDistances(distanceBetweenObjects , zeros(max(C(C~=0))), C);

end

