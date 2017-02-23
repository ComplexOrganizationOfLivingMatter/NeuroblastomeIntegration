function [percentageOfFibrePerFilledCell, quantityOfFibrePerFilledCell, percentageOfFibrePerCell, quantityOfFibrePerCell,distanceMatrix] = getBiologicalInfoFromHexagonalGrid(image, mask)
%GETBIOLOGICALINFOFROMHEXAGONALGRID Summary of this function goes here
%   Detailed explanation goes here
    [ distanceMatrix, centroidsFiltered, ImgMasked, classes] = getDistanceMatrixFromHexagonalGrid(image, mask);
    
    lengthAllCells = max(max(mask));
    quantityOfFibrePerFilledCell = zeros(length(centroidsFiltered), 1);
    percentageOfFibrePerFilledCell = zeros(length(centroidsFiltered), 1);
    quantityOfFibrePerCell = zeros(lengthAllCells, 1);
    percentageOfFibrePerCell = zeros(lengthAllCells, 1);
    parfor i = 1:lengthAllCells
        num = classes(classes == i);
        if num > 0
            quantityOfFibrePerCell(i) = sum(sum(ImgMasked == num));
            percentageOfFibrePerCell(i) = sum(sum(mask == num));
        else
            quantityOfFibrePerCell(i) = 0;
            percentageOfFibrePerCell(i) = 1;
        end
    end
    
    quantityOfFibrePerFilledCell = quantityOfFibrePerCell(classes);
    percentageOfFibrePerFilledCell = percentageOfFibrePerCell(classes);
    
    percentageOfFibrePerFilledCell = quantityOfFibrePerFilledCell ./ percentageOfFibrePerFilledCell;
    percentageOfFibrePerCell = quantityOfFibrePerCell ./ percentageOfFibrePerCell;
end