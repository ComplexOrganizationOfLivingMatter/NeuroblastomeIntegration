function [ ] = exportCharacteristicsAsCSV( pathOfInfo, filter )
%EXPORTCHARACTERISTICSASCSV Summary of this function goes here
%   Detailed explanation goes here
    
    allImages = getAllFiles(pathOfInfo);
    if isempty(filter) == 0
        allImages = allImages(cellfun(@(x) isempty(strfind(lower(x), lower(filter))) == 0, allImages));
    end
    characteristics = cell(length(allImages), 13);
    for numImg = 1:size(allImages,1)
        fullPathFile = allImages{numImg};
        fileNameSplitted = strsplit(fullPathFile, '\');
        fileName = fileNameSplitted(end);
        fileName = fileName{1};
        fileNameSplittedSplitted = strsplit(fileName, '_');
        if isempty(fileNameSplittedSplitted{1})
            fileNameFinal = fileNameSplittedSplitted{2};
        else
            fileNameFinal = fileNameSplittedSplitted{1};
        end
        load(fullPathFile);
        characteristics(numImg, :) = {fileNameFinal, meanPercentageOfFibrePerCell, stdPercentageOfFibrePerCell, meanPercentageOfFibrePerFilledCell, stdPercentageOfFibrePerFilledCell, meanQuantityOfBranchesPerCell, meanQuantityOfBranchesFilledPerCell, eulerNumberPerObject, eulerNumberPerCell, eulerNumberPerFilledCell, numberOfHolesPerObject, meanAreaOfHoles, stdAreaOfHoles};
    end
    characteristicsTable = cell2table(characteristics);
    if isempty(filter)
        writetable(characteristicsTable, strcat(strjoin(fileNameSplitted(1:end - 2), '\'), '\characteristics', fileNameSplitted{end - 3} ,'.xls'));
    else
        writetable(characteristicsTable, strcat(strjoin(fileNameSplitted(1:end - 2), '\'), '\characteristics', fileNameSplitted{end - 3} , '_', filter, '.xls'));
    end
end

