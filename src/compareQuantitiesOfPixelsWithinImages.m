function [ ] = compareQuantitiesOfPixelsWithinImages( pathInfo1, strInfo1, pathInfo2, strInfo2 )
%COMPAREQUANTITIESOFPIXELSWITHINIMAGES Summary of this function goes here
%   Detailed explanation goes here
    files1 = getAllFiles(pathInfo1);
    files2 = getAllFiles(pathInfo2);
    files1 = files1(cellfun(@(x) isempty(strfind(lower(x), lower(strInfo1))) == 0, files1));
    files2 = files2(cellfun(@(x) isempty(strfind(lower(x), lower(strInfo2))) == 0, files2));
    
    
    fullPathImageSplitted = strsplit(pathInfo1, '\');
    basePath = strjoin(fullPathImageSplitted(1:end-3), '\');
    
    allImages = getAllFiles(strcat(basePath, '\Images\'));
    
    vtnDifferences = cell(length(files1), 1);
    meanVTNDifference = zeros(length(files1), 1);
    pacients = cell(length(files1), 1);
    for indexFile1 = 1:length(files1)
        fullPathImage = files1{indexFile1};
        fullPathImageSplitted = strsplit(fullPathImage, '\');
        imageName = fullPathImageSplitted(end);
        imageName = imageName{1};
        imageNameSplitted = strsplit(imageName, '_');
        
        if isempty(imageNameSplitted{1})
            caseName = imageNameSplitted{2};
        else
            caseName = imageNameSplitted{1};
        end
        
        imageNameTrimmed = strrep(imageName, 'DiametDistanceMatrix.mat', '');
        imageNameNumMask = strsplit(imageNameTrimmed, 'Mask');
        numMask = str2num(imageNameNumMask{end});
        
        infoFile1 = importdata(fullPathImage);
        
        imagesToGetSize = allImages(cellfun(@(x) isempty(strfind(x, caseName)) == 0 & isempty(strfind(lower(x), lower('Mask'))) == 0, allImages));
        Img = imread(imagesToGetSize{1});

        maskName = strcat('..\Mascaras\HexagonalMask', num2str(numMask), 'Diamet.mat');
        mask = importdata(maskName);
        mask = mask(1:size(Img, 1), 1:size(Img,2));

        centroidsAll = regionprops(mask, 'Centroid');
        distanceMatrixAll = squareform(pdist(vertcat(centroidsAll.Centroid)));

        foundFile = files2(cellfun(@(x) isempty(strfind(x, caseName)) == 0, files2));
        if length(foundFile) == 1
            infoFile2 = importdata(foundFile{:});

            allClasses = unique([infoFile1.ImgMasked, infoFile2.ImgMasked]);
            meanPercentageOfFibreWithinNeighborhoodFile1 = getMeanOfVariableFromNeighborhood(infoFile1.percentageOfFibrePerCell, distanceMatrixAll, allClasses, numMask);
            
            meanPercentageOfFibreWithinNeighborhoodFile2 = getMeanOfVariableFromNeighborhood(infoFile2.percentageOfFibrePerCell, distanceMatrixAll, allClasses, numMask);
            diffPercentageOfFibreWithinNeighborhood = meanPercentageOfFibreWithinNeighborhoodFile2 - meanPercentageOfFibreWithinNeighborhoodFile1;
            vtnDifferences(indexFile1) = {diffPercentageOfFibreWithinNeighborhood};
            meanVTNDifference(indexFile1) = mean(diffPercentageOfFibreWithinNeighborhood);
        else
            meanVTNDifference(indexFile1) = mean(infoFile1.percentageOfFibrePerFilledCell);
            vtnDifferences(indexFile1) = {infoFile1.percentageOfFibrePerFilledCell};
        end
        pacients(indexFile1) = {caseName};
    end
    pacients
    stdVTNDifference = cellfun(@(x) std(x), vtnDifferences);
    save(strcat(basePath, '\Networks\vtnDifferences'), 'pacients', 'meanVTNDifference', 'stdVTNDifference','vtnDifferences');
end

