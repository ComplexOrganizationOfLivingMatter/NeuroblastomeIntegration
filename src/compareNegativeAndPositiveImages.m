function [ ] = compareNegativeAndPositiveImages( currentPath, markerWeWant )
%COMPARENEGATIVEANDPOSITIVEIMAGES Summary of this function goes here
%   Detailed explanation goes here
    allFiles = getAllFiles(currentPath);
    allFiles = sort(allFiles);
    for numFile = 1:size(allFiles,1)
        fullPathFileName = allFiles(numFile);
        fullPathFileName = fullPathFileName{:};
        fullPathFileNameSplitted = strsplit(fullPathFileName, '\');
        fileName = fullPathFileNameSplitted(end);
        fileName = fileName{1};
        %Path name
        basePath = strjoin(fullPathFileNameSplitted(1:6), '\');
        %If it's a directory and positive image (marker positive). Also we exclude the files of col, ret, CD31 and GAG
        if isempty(strfind(lower(fullPathFileName), lower(markerWeWant))) == 0 && isempty(strfind(lower(fullPathFileName), lower('CELS'))) == 1
            imgNegative = imread(allFiles{numFile-1});
            imgNegative = im2bw(imgNegative(:,:,1), 0.2);
            imgNegativeLog = logical(imgNegative);
            
            imgPositive = imread(allFiles{numFile-1});
            imgPositive = im2bw(imgPositive(:,:,1), 0.2);
			imgPositiveLog = logical(imgPositive);
            
            
        end
    end
end

