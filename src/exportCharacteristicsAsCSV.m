function [ ] = exportCharacteristicsAsCSV( pathOfInfo, filter )
%EXPORTCHARACTERISTICSASCSV Summary of this function goes here
%   Detailed explanation goes here
    
    allImages = getAllFiles(pathOfInfo);
    if isempty(filter) == 0
        allImages = allImages(cellfun(@(x) isempty(strfind(lower(x), lower(filter))) == 0, allImages));
    end
   	characteristicsTable = [];
    for numImg = 1:size(allImages,1)
        fullPathFile = allImages{numImg};
        fileNameSplitted = strsplit(fullPathFile, '\');
        fileName = fileNameSplitted(end);
        fileName = fileName{1};
        fileNameSplittedSplitted = strsplit(fileName, '_');
        if isempty(fileNameSplittedSplitted{1})
            fileNameFinal = {strjoin(fileNameSplittedSplitted(2:end-1), '_')};
        else
            fileNameFinal = {strjoin(fileNameSplittedSplitted(1:end-1), '_')};
        end
        load(fullPathFile);
        if isempty(characteristicsTable)
            characteristicsTable = table(fileNameFinal, meanPercentageOfFibrePerCell, stdPercentageOfFibrePerCell, meanPercentageOfFibrePerFilledCell, stdPercentageOfFibrePerFilledCell, meanQuantityOfBranchesPerCell, meanQuantityOfBranchesFilledPerCell, eulerNumberPerObject, eulerNumberPerCell, eulerNumberPerFilledCell, numberOfHolesPerObject, meanAreaOfHoles, stdAreaOfHoles);
        else
            characteristicsTable = [characteristicsTable; table(fileNameFinal, meanPercentageOfFibrePerCell, stdPercentageOfFibrePerCell, meanPercentageOfFibrePerFilledCell, stdPercentageOfFibrePerFilledCell, meanQuantityOfBranchesPerCell, meanQuantityOfBranchesFilledPerCell, eulerNumberPerObject, eulerNumberPerCell, eulerNumberPerFilledCell, numberOfHolesPerObject, meanAreaOfHoles, stdAreaOfHoles)];
        end
    end
    
    if isempty(filter)
        writetable(characteristicsTable, strcat(strjoin(fileNameSplitted(1:end - 2), '\'), '\characteristics', fileNameSplitted{end - 3} , '_', date, '.xls'));
    else
        writetable(characteristicsTable, strcat(strjoin(fileNameSplitted(1:end - 2), '\'), '\characteristics', fileNameSplitted{end - 3} , '_', filter, '_', date,'.xls'));
    end
end

