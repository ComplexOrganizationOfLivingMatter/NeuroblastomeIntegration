function [ ] = exportCharacteristicsAsCSV( pathOfInfo )
%EXPORTCHARACTERISTICSASCSV Summary of this function goes here
%   Detailed explanation goes here
    
    allImages = getAllFiles(pathOfInfo);
    characteristics = zeros(length(allImages), 4);
    pacientName = {};
    for numImg = 1:size(allImages,1)
        fullPathFile = allImages{numImg};
        fileNameSplitted = strsplit(fullPathFile, '\');
        fileName = fileNameSplitted(end);
        fileName = fileName{1};
        pacientName(end + 1, 1) = {fileName}
        load(fullPathFile);
        characteristics(numImg, :) = [meanPercentageOfFibrePerCell, stdPercentageOfFibrePerCell, meanPercentageOfFibrePerFilledCell, stdPercentageOfFibrePerFilledCell];
    end
    dlmwrite(strcat(strjoin(fileNameSplitted, '\'), '\characteristics', fileNameSplitted{end - 3} ,'.csv'), characteristics, ';');
end

