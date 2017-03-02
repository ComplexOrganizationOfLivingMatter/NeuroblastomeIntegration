function [quantityOfBranchesFilledPerCell, quantityOfBranchesPerCell, percentageOfFibrePerFilledCell, quantityOfFibrePerFilledCell, percentageOfFibrePerCell, quantityOfFibrePerCell, distanceMatrix, centroidsFiltered, ImgMasked] = getBiologicalInfoFromHexagonalGrid(image, mask)
%GETBIOLOGICALINFOFROMHEXAGONALGRID Summary of this function goes here
    %   Detailed explanation goes here
    [ distanceMatrix, centroidsFiltered, ImgMasked, classes] = getDistanceMatrixFromHexagonalGrid(image, mask);

    imgSkel = bwmorph(image,'skel',inf);
    imgBranchingPoints = bwmorph(imgSkel,'branchpoints');

    imgBranchingPoints = imgBranchingPoints .* ImgMasked;
%     figure;
%     subplot(1,2,1), subimage(imgPositiveLogSkel)
%     subplot(1,2,2), subimage(imgPositiveBranchingPoints)
    
    lengthAllCells = max(max(mask));
    quantityOfFibrePerFilledCell = zeros(length(centroidsFiltered), 1);
    percentageOfFibrePerFilledCell = zeros(length(centroidsFiltered), 1);
    quantityOfBranchesPerFilledCell = zeros(length(centroidsFiltered), 1);
    quantityOfFibrePerCell = zeros(lengthAllCells, 1);
    percentageOfFibrePerCell = zeros(lengthAllCells, 1);
    quantityOfBranchesPerCell = zeros(lengthAllCells, 1);
    parfor i = 1:lengthAllCells
        num = classes(classes == i);
        if num > 0
            quantityOfBranchesPerCell(i) = sum(sum(imgBranchingPoints == num));
            quantityOfFibrePerCell(i) = sum(sum(ImgMasked == num));
            percentageOfFibrePerCell(i) = sum(sum(mask == num)); %total pixels per cell
        else
            quantityOfBranchesPerCell(i) = 0;
            quantityOfFibrePerCell(i) = 0;
            percentageOfFibrePerCell(i) = 1;
        end
    end
    
    quantityOfBranchesFilledPerCell = quantityOfBranchesPerCell(classes);
    quantityOfFibrePerFilledCell = quantityOfFibrePerCell(classes);
    percentageOfFibrePerFilledCell = percentageOfFibrePerCell(classes);
    
    percentageOfFibrePerFilledCell = quantityOfFibrePerFilledCell ./ percentageOfFibrePerFilledCell*100;
    percentageOfFibrePerCell = quantityOfFibrePerCell ./ percentageOfFibrePerCell*100;
end