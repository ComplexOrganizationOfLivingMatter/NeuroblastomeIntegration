function [ ] = analyzeGraphletsDistances(currentPath, marker, typeOfDistance)
%analyzeGraphletsDistances Summary of this function goes here
%   Detailed explanation goes here
    graphletFiles = getAllFiles(currentPath);

    pacientArray = {};
    sortingWTMeanArray = {};
    sortingWTSizeArray = {};
    differenceGraphletsSortingArray = {};
    iterationWTMeanArray = {};
    iterationWTSizeArray = {};
    differenceGraphletsIterationArray = {};
    
    for numFile = 1:size(graphletFiles,1)
        
        fullPathGraphlet = graphletFiles{numFile};
        graphletNameSplitted = strsplit(fullPathGraphlet, '\');
        graphletName = graphletNameSplitted(end);
        graphletName = graphletName{1};

        if size(strfind(graphletName, typeOfDistance), 1) > 0
            
            graphletNameSplitted(end-1);
            distanceMatrix = dlmread(fullPathGraphlet, '\t', 1, 1);
            names = importfileNames(fullPathGraphlet);
            algorithmsFilter = cellfun(@(x) size(strfind(x, 'BetweenPairs'), 1) > 0, names);

            sortingAlgorithm = distanceMatrix(algorithmsFilter == 0, algorithmsFilter == 0);
            sortingNames = names(algorithmsFilter == 0);
            sortingControlFilter = cellfun(@(x) size(strfind(x, 'Control'), 1) > 0, sortingNames);
            sortingWTNames = sortingNames(sortingControlFilter == 0);
            sortingWT = sortingAlgorithm(sortingControlFilter == 0, sortingControlFilter);
            sortingWTMean = mean(sortingWT, 2)';
            differenceGraphletsSorting = zeros(size(sortingWTMean, 2) - 1, 1);
            
            for i = 1:size(differenceGraphletsSorting, 1)
                differenceGraphletsSorting(i) = sortingWTMean(i + 1) - sortingWTMean(i);
            end

            iterationAlgorithm = distanceMatrix(algorithmsFilter == 1, algorithmsFilter == 1);
            iterationNames = names(algorithmsFilter);
            iterationControlFilter = cellfun(@(x) size(strfind(x, 'Control'), 1) > 0, iterationNames);
            iterationWTNames = iterationNames(iterationControlFilter == 0);
            iterationWT = iterationAlgorithm(iterationControlFilter == 0, iterationControlFilter);
            iterationWTMean = mean(iterationWT, 2)';
            differenceGraphletsIteration = zeros(size(iterationWTMean, 2) - 1, 1);
            
            for i = 1:size(differenceGraphletsIteration, 1)
                differenceGraphletsIteration(i) = iterationWTMean(i + 1) - iterationWTMean(i);
            end
            
            outputFile = strjoin(graphletNameSplitted(1:end-1), '\');
            save(strcat(outputFile, '\meanDistanceWithControl', upper(typeOfDistance) ,'.mat'), 'sortingWTNames', 'sortingWTMean', 'iterationWTNames', 'iterationWTMean');
            
            pacientArray(end+1, 1) = graphletNameSplitted(end-1);
            sortingWTMeanArray(end+1, 1) = {sortingWTMean'};
            sortingWTSizeArray(end+1, 1) = {size(sortingWTMean, 2)};
            differenceGraphletsSortingArray(end+1, 1) = {differenceGraphletsSorting};
            iterationWTMeanArray(end+1, 1) = {iterationWTMean'};
            iterationWTSizeArray(end+1, 1) = {size(iterationWTMean, 2)};
            
            differenceGraphletsIterationArray(end+1, 1) = {differenceGraphletsIteration};

        end
    end
    
    pacientArray;
    sortingWTMeanArray = padcat(sortingWTMeanArray{:});
    differenceGraphletsSortingArray = padcat(differenceGraphletsSortingArray{:});
    sortingWTSizeArray = cell2mat(sortingWTSizeArray);
    sortingCharacteristics = [sortingWTMeanArray', sortingWTSizeArray, differenceGraphletsSortingArray'];
    
    iterationWTMeanArray = padcat(iterationWTMeanArray{:});
    differenceGraphletsIterationArray = padcat(differenceGraphletsIterationArray{:});
    iterationWTSizeArray = cell2mat(iterationWTSizeArray);
    iterationCharacteristics = [iterationWTMeanArray', iterationWTSizeArray, differenceGraphletsIterationArray'];

    allCharacteristics = [sortingCharacteristics, iterationCharacteristics];
    
    outputFile = strjoin(graphletNameSplitted(1:end-3), '\');
    csvwrite(strcat(outputFile, '\characteristics_', marker, '_', upper(typeOfDistance), '.csv'), allCharacteristics);
end

