function [ ] = compareQuantitiesOfPixelsWithinImages( pathInfo1, strInfo1, pathInfo2, strInfo2 )
%COMPAREQUANTITIESOFPIXELSWITHINIMAGES Summary of this function goes here
%   Detailed explanation goes here
    files1 = getAllFiles(pathInfo1);
    files2 = getAllFiles(pathInfo2);
    files1 = files1(cellfun(@(x) isempty(strfind(x, strInfo1)) == 0, files1));
    files2 = files2(cellfun(@(x) isempty(strfind(x, strInfo2)) == 0, files2));
    
    for indexFile1 = 1:length(files1)
        fullPathImage = files1{indexFile1};
        fullPathImageSplitted = strsplit(fullPathImage, '\');
        imageName = fullPathImageSplitted(end);
        imageName = imageName{1};
        imageNameSplitted = strsplit(imageName, '_');
        if isempty(imageNameSplitted(1))
            caseName = imageNameSplitted{2};
        else
            caseName = imageNameSplitted{1};
        end
        
        imageNameTrimmed = strrep(imageName, 'DiametDistanceMatrix', '');
        imageNameNumMask = strsplit(imageNameTrimmed, 'Mask');
        numMask = str2num(imageNameNumMask{end});
        
        infoFile1 = importdata(fullPathImage);
        
        foundFile = files2(cellfun(@(x) isempty(strfind(x, caseName)) == 0, files2));
        if length(foundFile) == 1
            infoFile2 = importdata(foundFile);
            allClasses = unique(infoFile1.ImgMasked, infoFile2.ImgMasked);
            meanPercentageOfFibreWithinNeighborhoodFile1 = getMeanOfVariableFromNeighborhood(infoFile1.percentageOfFibrePerCell, , allClasses, numMask*2);
            meanPercentageOfFibreWithinNeighborhoodFile2 = getMeanOfVariableFromNeighborhood(infoFile2.percentageOfFibrePerCell, , allClasses, numMask*2);
            diffPercentageOfFibreWithinNeighborhood = meanPercentageOfFibreWithinNeighborhoodFile2 - meanPercentageOfFibreWithinNeighborhoodFile1;
        end
    end
end

