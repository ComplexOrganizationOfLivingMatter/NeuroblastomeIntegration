function [ ] = exportCharacteristicsAsCSV( pathOfInfo )
%EXPORTCHARACTERISTICSASCSV Summary of this function goes here
%   Detailed explanation goes here
    
    allImages = getAllFiles(pathOfInfo);
    characteristics = cell(length(allImages), 7);
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
        characteristics(numImg, :) = {fileNameFinal, meanPercentageOfFibrePerCell, stdPercentageOfFibrePerCell, meanPercentageOfFibrePerFilledCell, stdPercentageOfFibrePerFilledCell, meanQuantityOfBranchesPerCell, meanQuantityOfBranchesFilledPerCell};
    end
    characteristicsTable = cell2table(characteristics);
    writetable(characteristicsTable, strcat(strjoin(fileNameSplitted(1:end - 2), '\'), '\characteristics', fileNameSplitted{end - 3} ,'.xls'));
end

