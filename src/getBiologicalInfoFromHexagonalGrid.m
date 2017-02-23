function [weightsOfVertices, weightsOfEdges, distanceMatrix] = getBiologicalInfoFromHexagonalGrid(image, mask)
%GETBIOLOGICALINFOFROMHEXAGONALGRID Summary of this function goes here
%   Detailed explanation goes here
    [ distanceMatrix, centroidsFiltered, ImgMasked, classes] = getDistanceMatrixFromHexagonalGrid(image, mask);
    quantityOfFiberPerCell = zeros(length(centroidsFiltered), 1);
    for i = 1:length(centroidsFiltered)
        quantityOfFiberPerCell(i) = sum(sum(ImgMasked == classes(i)));
    end
    quantityOfFiberPerCell
end