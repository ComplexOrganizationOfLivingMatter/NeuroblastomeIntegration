function [] = unifyExcelsOfMarkers(outputDir, directoryNames)
%UNIFYEXCELSOFMARKERS Summary of this function goes here
%   Detailed explanation goes here

    allData = {};
    for numDirectory = 1:size(directoryNames{1}, 2)
        xlsFiles = dir(fullfile(outputDir, directoryNames{2}{numDirectory}, 'unified_Characteristics*.xlsx'));
        
        [~, ~, rawInfo] = xlsread(fullfile(xlsFiles(1).folder, xlsFiles(1).name));
        
        if numDirectory > 1
            rawInfo(1, :) = cellfun(@(x) [directoryNames{1}{numDirectory}, ' - ', x], rawInfo(1, :), 'UniformOutput', false);
            allData = horzcat(allData, rawInfo(:, 6:end));
        else
            allData = rawInfo;
        end
    end
    outputFile = fullfile('..\Results\capturingFeatures\Mice', strcat('setOfFeatures_', date, '.xlsx'));
    xlswrite(outputFile, allData);
end

for numCentroid = 1:4000
    x = randi([1 size(img, 1)]);
    y = randi([1 size(img, 1)]);
    img(x, y) = 1;
end
