function [output] = quantifyingIntraCellularVN(inputFile)
%QUANTIFYINGINTRACELLULARVN Summary of this function goes here
%   Detailed explanation goes here
allFiles = dir(strcat(inputFile, '*.tif'));
intraCellularThreshold = 8;

negativeCellsFile = allFiles(cellfun(@(x) contains(x, 'CELS', 'IgnoreCase', true), {allFiles.name}));
negCellsImg = imread(strcat(negativeCellsFile.folder, '\', negativeCellsFile.name));
negCellsImg = negCellsImg(:, :, 1) == 255;

periIntraCellularFile = allFiles(cellfun(@(x) contains(x, 'MACR_MASK', 'IgnoreCase', true), {allFiles.name}));
periIntraCellImg = imread(strcat(periIntraCellularFile.folder, '\', periIntraCellularFile.name));
periIntraCellImg = periIntraCellImg(:, :, 1) > 0;

centroidsNegCells = regionprops(negCellsImg, 'Centroid');
centroidsNegCellsCentroids = round(vertcat(centroidsNegCells.Centroid));

[x, y] = find(periIntraCellImg);
periIntraCellPixels = horzcat(y, x);

%Closest VN
distanceCentroids = pdist2(centroidsNegCellsCentroids, periIntraCellPixels, 'euclidean', 'Smallest', 1);

output = mean(distanceCentroids);

%Quantify intracellular
negCellsCentroidsImg = zeros(size(negCellsImg));
for numCentroid = 1:size(centroidsNegCellsCentroids, 1)
    negCellsCentroidsImg(centroidsNegCellsCentroids(numCentroid, 2), centroidsNegCellsCentroids(numCentroid, 1)) = 1;
end
distImgNegCells = bwdist(negCellsCentroidsImg);

totalPeriIntraCellVTN = sum(periIntraCellImg(:));
totalIntraCellVN = sum(periIntraCellImg(distImgNegCells < intraCellularThreshold));

percentageOfIntraCellVN = totalIntraCellVN/totalPeriIntraCellVTN;

output = percentageOfIntraCellVN;
end

