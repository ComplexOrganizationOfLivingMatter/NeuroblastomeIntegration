function [ ] = getMinimumDistancesFromHexagonalGrid(PathCurrent, markerName)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%
%   Developed by Pablo Vicente-Munuera
    lee_imagenes = getAllFiles(PathCurrent);
    eulerNumberArray = {};
    imageNameArray = {};
    for imK = 1:size(lee_imagenes,1)
        fullPathImage = lee_imagenes(imK);
        fullPathImage = fullPathImage{:};
        fullPathImageSplitted = strsplit(fullPathImage, '\');
        imageName = fullPathImageSplitted(end);
        imageName = imageName{1};
        %Path name
        basePath = strjoin(fullPathImageSplitted(1:6), '\');

        if size(strfind(lower(imageName), lower(markerName)), 1) == 1
            imageName
            Img=imread(fullPathImage);
            Img = Img(:, :, 1);
            Img = im2bw(Img, 0.2);
            for numMask = [50] %100
                inNameFile = strsplit(strrep(imageName,' ','_'), '.');
                outputFileName = strcat(basePath, '\Networks\DistanceMatrixWeights\', inNameFile(1), 'ContigousHexagonalMeanAreaMask', num2str(numMask),'DiametDistanceMatrix.mat');
                distanceMatrix = '';
                eulerNumberArray(end+1) = {bweuler(Img, 4)};
                imageNameArray(end+1) = {imageName};
                if exist(outputFileName{:}, 'file') ~= 2
                    maskName = strcat('..\Mascaras\HexagonalMask', num2str(numMask), 'Diamet.mat');
                    mask = importdata(maskName);
                    mask = mask(1:size(Img, 1), 1:size(Img,2));

                    [quantityOfBranchesFilledPerCell, quantityOfBranchesPerCell, percentageOfFibrePerFilledCell, quantityOfFibrePerFilledCell, percentageOfFibrePerCell, quantityOfFibrePerCell, distanceMatrix, centroids, ImgMasked] = getBiologicalInfoFromHexagonalGrid(Img, mask);
                    
                    stdPercentageOfFibrePerFilledCell = std(percentageOfFibrePerFilledCell);
                    stdPercentageOfFibrePerCell = std(percentageOfFibrePerCell);
                    
                    meanPercentageOfFibrePerFilledCell = mean(percentageOfFibrePerFilledCell);
                    meanPercentageOfFibrePerCell = mean(percentageOfFibrePerCell);
                    
                    meanQuantityOfBranchesFilledPerCell = mean(quantityOfBranchesFilledPerCell);
                    meanQuantityOfBranchesPerCell = mean(quantityOfBranchesPerCell);
                    
                    centroidsAll = regionprops(mask, 'Centroid');
                    distanceMatrixAll = squareform(pdist(vertcat(centroidsAll.Centroid)));
                    meanPercentageOfFibreWithinNeighborhood = getMeanOfVariableFromNeighborhood(percentageOfFibrePerCell, distanceMatrixAll, unique(ImgMasked), numMask*2);
                    
                    distanceBetweenObjects = distanceMatrix;
                    
                    save(outputFileName{:}, 'distanceBetweenObjects', 'centroids', 'ImgMasked', 'meanPercentageOfFibreWithinNeighborhood','percentageOfFibrePerFilledCell', 'quantityOfFibrePerFilledCell', 'percentageOfFibrePerCell', 'quantityOfFibrePerCell', 'stdPercentageOfFibrePerFilledCell', 'stdPercentageOfFibrePerCell', 'meanPercentageOfFibrePerFilledCell', 'meanPercentageOfFibrePerCell', 'meanQuantityOfBranchesFilledPerCell', 'meanQuantityOfBranchesPerCell', 'eulerNumberArray');
                else
                    matrixData = importdata(outputFileName{:});
                    if isfield(matrixData, 'distanceBetweenObjects')
                        distanceMatrix = matrixData.distanceBetweenObjects;
                    else
                        distanceMatrix = [];
                    end
                end
                if size(distanceMatrix, 1) > 15 && isempty(strfind(lower(imageName), lower('NEG'))) == 1
                    createNetworksWithControls(fullPathImage, Img, distanceMatrix, basePath, numMask, inNameFile, imageName);
                end
            end
        end
    end
end

