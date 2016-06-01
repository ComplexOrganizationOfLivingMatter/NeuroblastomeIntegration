function [ output_args ] = minimumDistanceBetweenNeighbourGraph( image )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%http://stackoverflow.com/questions/31388681/distance-between-connected-components?answertab=votes#tab-top
S = regionprops(bwlabel(image,4),'Centroid')

Centroids = vertcat(S.Centroid)

%// Measure pairwise distance
D = pdist(Centroids,'euclidean')

end

