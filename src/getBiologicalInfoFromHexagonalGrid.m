function [numberOfHolesPerFilledCell, numberOfHolesPerCell, eulerNumberPerFilledCell, eulerNumberPerCell, quantityOfBranchesFilledPerCell, quantityOfBranchesPerCell, percentageOfFibrePerFilledCell, quantityOfFibrePerFilledCell, percentageOfFibrePerCell, quantityOfFibrePerCell, distanceMatrix, centroidsFiltered, ImgMasked] = getBiologicalInfoFromHexagonalGrid(image, mask)
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
    eulerNumberPerFilledCell = zeros(length(centroidsFiltered), 1);
    numberOfHolesPerFilledCell = zeros(length(centroidsFiltered), 1);
    quantityOfFibrePerCell = zeros(lengthAllCells, 1);
    percentageOfFibrePerCell = zeros(lengthAllCells, 1);
    quantityOfBranchesPerCell = zeros(lengthAllCells, 1);
    eulerNumberPerCell = zeros(length(lengthAllCells), 1);
    numberOfHolesPerCell = zeros(length(lengthAllCells), 1);
    
    for i = 1:lengthAllCells
        num = classes(classes == i);
        if num > 0
            eulerNumberPerCell(i) = bweuler(ImgMasked == num, 8);
            imageObjects = regionprops(ImgMasked == num, 'EulerNumber');
            numberOfObjects = size(imageObjects, 1);
            numberOfHolesPerCell(i) = numberOfObjects - sum([imageObjects.EulerNumber]);
            quantityOfBranchesPerCell(i) = sum(sum(imgBranchingPoints == num));
            quantityOfFibrePerCell(i) = sum(sum(ImgMasked == num));
            percentageOfFibrePerCell(i) = sum(sum(mask == num)); %total pixels per cell
        else
            quantityOfBranchesPerCell(i) = 0;
            quantityOfFibrePerCell(i) = 0;
            percentageOfFibrePerCell(i) = 1;
        end
    end
    
    numberOfHolesPerFilledCell = numberOfHolesPerCell(classes);
    eulerNumberPerFilledCell = eulerNumberPerCell(classes);
    quantityOfBranchesFilledPerCell = quantityOfBranchesPerCell(classes);
    quantityOfFibrePerFilledCell = quantityOfFibrePerCell(classes);
    percentageOfFibrePerFilledCell = percentageOfFibrePerCell(classes);
    
    percentageOfFibrePerFilledCell = quantityOfFibrePerFilledCell ./ percentageOfFibrePerFilledCell*100;
    percentageOfFibrePerCell = quantityOfFibrePerCell ./ percentageOfFibrePerCell*100;
end