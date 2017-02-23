function [percentageOfFibrePerFilledCell, quantityOfFibrePerFilledCell, percentageOfFibrePerCell, quantityOfFibrePerCell,distanceMatrix] = getBiologicalInfoFromHexagonalGrid(image, mask)
%GETBIOLOGICALINFOFROMHEXAGONALGRID Summary of this function goes here
%   Detailed explanation goes here
    [ distanceMatrix, centroidsFiltered, ImgMasked, classes] = getDistanceMatrixFromHexagonalGrid(image, mask);
    
    quantityOfFibrePerFilledCell = zeros(length(centroidsFiltered), 1);
    percentageOfFibrePerFilledCell = zeros(length(centroidsFiltered), 1);
    parfor i = 1:length(centroidsFiltered)
        quantityOfFibrePerFilledCell(i) = sum(sum(ImgMasked == classes(i)));
        percentageOfFibrePerFilledCell(i) = sum(sum(mask == classes(i)));
    end
    percentageOfFibrePerFilledCell = quantityOfFibrePerFilledCell ./ percentageOfFibrePerFilledCell;
    
    lengthAllCells = max(max(mask));
    quantityOfFibrePerCell = zeros(lengthAllCells, 1);
    percentageOfFibrePerCell = zeros(lengthAllCells, 1);
    parfor i = 1:lengthAllCells
        quantityOfFibrePerCell(i,1) = sum(sum(ImgMasked == i));
        percentageOfFibrePerCell(i,1) = sum(sum(mask == i));
    end
    percentageOfFibrePerCell = quantityOfFibrePerCell ./ percentageOfFibrePerCell;
end