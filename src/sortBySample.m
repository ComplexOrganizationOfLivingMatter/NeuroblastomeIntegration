function [ ] = sortBySample( directoryToSort, marker )
%SORTBYSAMPLE Summary of this function goes here
%   Detailed explanation goes here

    filesToSort = dir(strcat(directoryToSort, '/*.ndump2'));
    
    for numFile = 1:length(filesToSort)
        actualFileName = filesToSort(numFile).name;
        actualFileNameTrimmed = strrep(actualFileName, 'minimumDistanceClassesBetweenPairs', '');
        actualFileNameTrimmed = strrep(actualFileNameTrimmed, 'sorting_', '');
        actualFileNameTrimmed = strrep(actualFileNameTrimmed, 'mst_', '');
        actualFileNameSplitted = strsplit(actualFileNameTrimmed, '_Mask');
        fullNameFile = actualFileNameSplitted{1};
        sampleName = strsplit(fullNameFile, marker);
        sampleNameFinal = sampleName{2};
        dirName = strcat(directoryToSort, sampleNameFinal(2:end-1));
        mkdir(dirName);
        source = strcat(directoryToSort, actualFileName);
        destination = strcat(dirName, '\', actualFileName);
        destination = regexprep(destination, '\\+', '/');
        movefile(source, regexprep(destination, '\\+', '/'));
    end
end

