function [ ] = compareNegativeAndPositiveImages( currentPath, markerWeWant )
%COMPARENEGATIVEANDPOSITIVEIMAGES Summary of this function goes here
%   Detailed explanation goes here
    NUM_MASK = 50;
    allFiles = getAllFiles(currentPath);
    allFiles = sort(allFiles);
    meanMinDistanceBetweenPositiveAndNegativeVector = {};
    fileNamePositiveVector = {};
    fileNameNegativeVector = {};
    for numFile = 1:size(allFiles,1)
        fullPathFileName = allFiles(numFile);
        fullPathFileName = fullPathFileName{:};
        fullPathFileNameSplitted = strsplit(fullPathFileName, '\');
        fileName = fullPathFileNameSplitted(end);
        fileName = fileName{1};
        %Path name
        basePath = strjoin(fullPathFileNameSplitted(1:6), '\');
        %If it's a directory and positive image (marker positive). Also we exclude the files of col, ret, CD31 and GAG
        if isempty(strfind(lower(fullPathFileName), lower(markerWeWant))) == 0 && isempty(strfind(lower(fullPathFileName), lower('mask'))) == 0 && isempty(strfind(lower(fullPathFileName), lower('CELS'))) == 1 && isempty(strfind(lower(fullPathFileName), '.txt')) == 1
            fileNameSplitted = strsplit(fileName, '_');
            
            if isempty(fileNameSplitted{1})
                fileNamePositive = fileNameSplitted{2};
                fileNameNegative = cellfun(@(x) isempty(strfind(x, fileNameSplitted{2})) == 0 & isempty(strfind(lower(x), 'cels')) == 0, allFiles);
            else
                fileNamePositive = fileNameSplitted{1};
                fileNameNegative = cellfun(@(x) isempty(strfind(x, fileNameSplitted{1})) == 0 & isempty(strfind(lower(x), 'cels')) == 0, allFiles);
            end
            
            if sum(fileNameNegative) > 0
                if sum(fileNameNegative) > 1
                    fileNameNegativeFinal = allFiles(fileNameNegative);
                    fileNameNegativeFinal = fileNameNegativeFinal{cellfun(@(x) isempty(strfind(lower(x), 'mask')) == 0, allFiles(fileNameNegative))};
                else
                    fileNameNegativeFinal = allFiles{fileNameNegative};
                end

                imgNegative = imread(fileNameNegativeFinal);
                imgNegative = im2bw(imgNegative(:,:,1), 0.2);
                imgNegativeLog = logical(imgNegative);
                imgNegativeCentroids = regionprops(imgNegativeLog,'Centroid');
                imgNegativeCentroids = vertcat(imgNegativeCentroids.Centroid);

                imgPositive = imread(allFiles{numFile});
                imgPositive = im2bw(imgPositive(:,:,1), 0.2);
                imgPositiveLog = logical(imgPositive);
                maskName = strcat('..\Mascaras\HexagonalMask', num2str(NUM_MASK), 'Diamet.mat');
                mask = importdata(maskName);
                mask = mask(1:size(imgPositiveLog, 1), 1:size(imgPositiveLog,2));
                [ distanceMatrixPositive, centroidsFilteredPositive, ImgMaskedPositive, classesPositive] = getDistanceMatrixFromHexagonalGrid(imgPositiveLog, mask);
                centroidsFilteredPositive = vertcat(centroidsFilteredPositive.Centroid);
                distanceBetweenPositiveAndNegative = pdist2(centroidsFilteredPositive, imgNegativeCentroids);
                minDistanceBetweenPositiveAndNegative = min(distanceBetweenPositiveAndNegative);
                meanMinDistanceBetweenPositiveAndNegative = mean(minDistanceBetweenPositiveAndNegative);
                meanMinDistanceBetweenPositiveAndNegativeVector{end+1} = meanMinDistanceBetweenPositiveAndNegative;
                fileNamePositiveVector{end+1} = fileNamePositive;
                fileNameNegativeVector{end+1} = fileNameNegativeFinal;
            else
                disp('No negative cells!');
                fileNamePositive
            end
        end
    end
    xlswrite(strcat(basePath, '\negativeVsPositive.xls'), padcat(fileNamePositiveVector', fileNameNegativeVector', meanMinDistanceBetweenPositiveAndNegativeVector'));
end

