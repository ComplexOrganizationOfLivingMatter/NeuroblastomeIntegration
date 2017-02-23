function [ distanceMatrix, centroidsFiltered, ImgMasked ] = getDistanceMatrixFromHexagonalGrid(Img, mask)
%GETDISTANCEMATRIXFROMHEXAGONALGRID Summary of this function goes here
%   Detailed explanation goes here
    ImgMasked = Img .* mask;
    classes = unique(ImgMasked(ImgMasked>0));
    centroids = regionprops(ImgMasked, 'Centroid');
    centroidsFiltered = centroids(classes);
    distanceMatrix = pdist(vertcat(centroidsFiltered.Centroid), 'euclidean');
    distanceMatrix = squareform(distanceMatrix);
end

