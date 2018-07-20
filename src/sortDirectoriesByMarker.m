function [] = sortDirectoriesByMarker(directoryToSort, markerOld, markerNew, newDirectory)
%SORTDIRECTORIESBYMARKER Summary of this function goes here
%   Detailed explanation goes here

    allTifFiles = dir(strcat(directoryToSort, '**\*.tif'));
    allJpgFiles = dir(strcat(directoryToSort, '**\*.jpg'));
    
    allFiles = vertcat(allJpgFiles, allTifFiles);
    
    mkdir(newDirectory);
    
    for numFile = 1:length(allFiles)
        actualFile = allFiles(numFile);
        if contains(actualFile.name, markerOld)
            source = strcat(actualFile.folder, '\', actualFile.name);
            destination = strcat(newDirectory, strrep(actualFile.name, markerOld, markerNew));
            destination = strrep(destination, 'mascara', strcat(markerNew, '_mask'));
            movefile(source, destination);
        end
    end
end

