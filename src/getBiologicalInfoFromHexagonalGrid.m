function [percentageOfFibrePerFilledCell, quantityOfFibrePerFilledCell, percentageOfFibrePerCell, quantityOfFibrePerCell,distanceMatrix] = getBiologicalInfoFromHexagonalGrid(image, mask)
%GETBIOLOGICALINFOFROMHEXAGONALGRID Summary of this function goes here
%   Detailed explanation goes here
    [ distanceMatrix, centroidsFiltered, ImgMasked, classes] = getDistanceMatrixFromHexagonalGrid(image, mask);
    
    quantityOfFibrePerFilledCell = zeros(length(centroidsFiltered), 1);
    percentageOfFibrePerFilledCell = zeros(length(centroidsFiltered), 1);
    for i = 1:length(centroidsFiltered)
        quantityOfFibrePerFilledCell(i) = sum(sum(ImgMasked == classes(i)));
        percentageOfFibrePerFilledCell(i) = sum(sum(mask == classes(i)));
    end
    percentageOfFibrePerFilledCell = quantityOfFibrePerFilledCell / percentageOfFibrePerFilledCell;
    
    quantityOfFibrePerCell = zeros(max(max(mask)), 1);
    percentageOfFibrePerCell = zeros(max(max(mask)), 1);
    for i = 1:max(mask)
        quantityOfFibrePerCell(i) = sum(sum(ImgMasked == i));
        percentageOfFibrePerCell(i) = sum(sum(mask == i));
    end
    percentageOfFibrePerCell = quantityOfFibrePerCell / percentageOfFibrePerCell;
end