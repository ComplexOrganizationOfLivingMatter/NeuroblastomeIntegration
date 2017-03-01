function [ ] = compareNegativeAndPositiveImages( currentPath, markerWeWant )
%COMPARENEGATIVEANDPOSITIVEIMAGES Summary of this function goes here
%   Detailed explanation goes here
    allFiles = getAllFiles(currentPath);
    for imK = 1:size(allFiles,1)
        fullPathFileName = allFiles(imK);
        fullPathFileName = fullPathFileName{:};
        fullPathFileNameSplitted = strsplit(fullPathFileName, '\');
        fileName = fullPathFileNameSplitted(end);
        fileName = fileName{1};
        %Path name
        basePath = strjoin(fullPathFileNameSplitted(1:6), '\');
        %If it's a directory and positive image (marker positive). Also we exclude the files of col, ret, CD31 and GAG
        if isempty(strfind(lower(fullPathFileName), lower(markerWeWant))) == 0
            
        end
    end
end

