function [ ] = exportCharacteristicsAsCSV( pathOfInfo )
%EXPORTCHARACTERISTICSASCSV Summary of this function goes here
%   Detailed explanation goes here
    
    allImages = getAllFiles(pathOfInfo);
    characteristics = cell(length(allImages), 5);
    for numImg = 1:size(allImages,1)
        fullPathFile = allImages{numImg};
        fileNameSplitted = strsplit(fullPathFile, '\');
        fileName = fileNameSplitted(end);
        fileName = fileName{1};
        load(fullPathFile);
        characteristics(numImg, :) = {fileName(1:end-61), meanPercentageOfFibrePerCell, stdPercentageOfFibrePerCell, meanPercentageOfFibrePerFilledCell, stdPercentageOfFibrePerFilledCell};
    end
    characteristicsTable = cell2table(characteristics);
    writetable(strcat(strjoin(fileNameSplitted(1:end - 1), '\'), '\characteristics', fileNameSplitted{end - 3} ,'.csv'), characteristicsTable, ';');
end

