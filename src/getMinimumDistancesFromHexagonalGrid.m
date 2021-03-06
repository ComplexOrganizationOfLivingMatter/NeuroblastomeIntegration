function [ ] = getMinimumDistancesFromHexagonalGrid(PathCurrent, markerName, outputDir)
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

        if size(strfind(lower(imageName), lower(markerName)), 1) == 1
            imageName
            Img=imread(fullPathImage);
            Img = Img(:, :, 1);
            Img = im2bw(Img, 0.2);
            for numMask = [50] %100
                inNameFile = strsplit(strrep(imageName,' ','_'), '.tif');
                inNameFile(1) = strrep(inNameFile(1), '.', '-');
                outputFileName = strcat(outputDir, '\DistanceMatrixWeights\', inNameFile(1), 'ContigousHexagonalMeanAreaMask', num2str(numMask),'DiametDistanceMatrix.mat');
                distanceMatrix = '';
                eulerNumberArray(end+1) = {bweuler(Img, 4)};
                imageNameArray(end+1) = {imageName};
                if exist(outputFileName{:}, 'file') ~= 2
                    maskName = strcat('..\Mascaras\HexagonalMask', num2str(numMask), 'Diamet.mat');
                    mask = importdata(maskName);
                    mask = mask(1:size(Img, 1), 1:size(Img,2));

                    [numberOfHolesPerFilledCell, numberOfHolesPerCell, eulerNumberPerFilledCell, eulerNumberPerCell, quantityOfBranchesFilledPerCell, quantityOfBranchesPerCell, percentageOfFibrePerFilledCell, quantityOfFibrePerFilledCell, percentageOfFibrePerCell, quantityOfFibrePerCell, distanceMatrix, centroids, ImgMasked] = getBiologicalInfoFromHexagonalGrid(Img, mask);
                    
                    stdPercentageOfFibrePerFilledCell = std(percentageOfFibrePerFilledCell);
                    stdPercentageOfFibrePerCell = std(percentageOfFibrePerCell);
                    
                    meanPercentageOfFibrePerFilledCell = mean(percentageOfFibrePerFilledCell);
                    meanPercentageOfFibrePerCell = mean(percentageOfFibrePerCell);
                    
                    meanQuantityOfBranchesFilledPerCell = mean(quantityOfBranchesFilledPerCell);
                    meanQuantityOfBranchesPerCell = mean(quantityOfBranchesPerCell);
                    
                    meanNumberOfHolesPerFilledCell = mean(numberOfHolesPerFilledCell);
                    meanNumberOfHolesPerCell = mean(numberOfHolesPerCell);
                    
                    eulerNumberPerFilledCell = mean(eulerNumberPerFilledCell);
                    eulerNumberPerCell = mean(eulerNumberPerCell);
                    
                    centroidsAll = regionprops(mask, 'Centroid');
                    distanceMatrixAll = squareform(pdist(vertcat(centroidsAll.Centroid)));
                    meanPercentageOfFibreWithinNeighborhood = getMeanOfVariableFromNeighborhood(percentageOfFibrePerCell, distanceMatrixAll, unique(ImgMasked), numMask*2);
                    
                    distanceBetweenObjects = distanceMatrix;
                    
                    eulerNumber = bweuler(Img, 8);
                    
                    imageObjects = regionprops(Img, 'EulerNumber');
                    numberOfObjects = size(imageObjects, 1);
                    numberOfHoles = numberOfObjects - sum([imageObjects.EulerNumber]);
                    
                    eulerNumberPerObject = eulerNumber / numberOfObjects;
                    numberOfHolesPerObject = numberOfHoles / numberOfObjects;
                    holesObjects = bwconncomp(logical(1-Img), 4);
                    if numberOfHoles > 0
                        areaOfHoles = cellfun(@(x) size(x, 1), holesObjects.PixelIdxList(2:end));
                        meanAreaOfHoles = mean(areaOfHoles);
                        stdAreaOfHoles = std(areaOfHoles);
                    else
                        meanAreaOfHoles = 0;
                        stdAreaOfHoles = 0;
                    end
                    
                    save(outputFileName{:}, 'distanceBetweenObjects', 'centroids', 'ImgMasked', 'meanPercentageOfFibreWithinNeighborhood','percentageOfFibrePerFilledCell', 'quantityOfFibrePerFilledCell', 'percentageOfFibrePerCell', 'quantityOfFibrePerCell', 'stdPercentageOfFibrePerFilledCell', 'stdPercentageOfFibrePerCell', 'meanPercentageOfFibrePerFilledCell', 'meanPercentageOfFibrePerCell', 'meanQuantityOfBranchesFilledPerCell', 'meanQuantityOfBranchesPerCell', 'meanNumberOfHolesPerFilledCell', 'meanNumberOfHolesPerCell', 'eulerNumberPerFilledCell', 'eulerNumberPerCell', 'eulerNumberPerObject', 'numberOfHolesPerObject', 'meanAreaOfHoles', 'stdAreaOfHoles', 'eulerNumber', 'numberOfObjects', 'numberOfHoles');
                else
                    matrixData = importdata(outputFileName{:});
                    if isfield(matrixData, 'distanceBetweenObjects')
                        distanceMatrix = matrixData.distanceBetweenObjects;
                    else
                        distanceMatrix = [];
                    end
                end
                if size(distanceMatrix, 1) > 15 && isempty(strfind(lower(imageName), lower('NEG'))) == 1
                    createNetworksWithControls(fullPathImage, Img, distanceMatrix, outputDir, numMask, inNameFile, markerName);
                end
            end
        end
    end
end

