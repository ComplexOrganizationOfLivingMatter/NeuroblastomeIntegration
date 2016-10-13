function [ ] = analyzeGraphletsDistances( )
%analyzeGraphletsDistances Summary of this function goes here
%   Detailed explanation goes here
    graphletFiles = getAllFiles('E:\Pablo\Neuroblastoma\Results\graphletsCount\NuevosCasos\RET\NDUMP2\DivideByPacient\');

    
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
        graphletNameSplitted(end-1)
        graphletName = graphletNameSplitted(end);
        graphletName = graphletName{1};


        
        if size(strfind(graphletName, 'gcd73'), 1) > 0
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
            save(strcat(outputFile, '\meanDistanceWithControl.mat'), 'sortingWTNames', 'sortingWTMean', 'iterationWTNames', 'iterationWTMean');
            
            pacientArray(end+1) = {graphletNameSplitted(end-1)};
            sortingWTMeanArray(end+1) = {sortingWTMean};
            sortingWTSizeArray(end+1) = {size(sortingWTMean, 2)};
            differenceGraphletsSortingArray(end+1) = {differenceGraphletsSorting};
            iterationWTMeanArray(end+1) = {iterationWTMean};
            iterationWTSizeArray(end+1) = {size(iterationWTMean, 2)};
            differenceGraphletsIterationArray(end+1) = {differenceGraphletsIteration};

        end
    end
    
    
    padcat(sortingWTMeanArray{:}, differenceGraphletsSortingArray{:});
    fid = fopen(strcat(strjoin(graphletNameSplitted(1:end-2), '\') ,'caracteristics.csv'), 'w');

    fclose(fid);

end

