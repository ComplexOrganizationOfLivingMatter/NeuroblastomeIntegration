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
    mstWTMeanArray = {};
    
    for numFile = 1:size(graphletFiles,1)
        
        fullPathGraphlet = graphletFiles{numFile};
        graphletNameSplitted = strsplit(fullPathGraphlet, '\');
        graphletName = graphletNameSplitted(end);
        graphletName = graphletName{1};

        if size(strfind(graphletName, typeOfDistance), 1) > 0
            
            if isempty(strfind(graphletNameSplitted{end-2} , 'Control')) == 0
                    graphletNameSplitted(end-1)
                    distanceMatrix = dlmread(fullPathGraphlet, '\t', 1, 1);
                    names = importfileNames(fullPathGraphlet);
                    names = cellfun(@(x) strsplit(x, '/'), names, 'UniformOutput', false);
                    names = cellfun(@(x) x{end}, names, 'UniformOutput', false);
                    markerFilter = cellfun(@(x) size(strfind(x, marker), 1) > 0, names);
                    names = names(markerFilter);
                    distanceMatrix = distanceMatrix(markerFilter, markerFilter);
                    algorithmsFilter = cellfun(@(x) size(strfind(x, 'BetweenPairs'), 1) > 0, names);

                    sortingFilter = cellfun(@(x) size(strfind(x, 'sorting'), 1) > 0, names);
                    sortingAlgorithm = distanceMatrix(sortingFilter == 1, sortingFilter == 1);
                    sortingNames = names(sortingFilter == 1);
                    sortingControlFilter = cellfun(@(x) size(strfind(x, 'Control'), 1) > 0, sortingNames);
                    sortingWTNames = sortingNames(sortingControlFilter == 0);
                    sortingWT = sortingAlgorithm(sortingControlFilter == 0, sortingControlFilter);
                    sortingWTMean = mean(sortingWT, 2)';
                    if isempty(sortingWTMean)
                        sortingWTMean = 0;
                    end
    %                 differenceGraphletsSorting = zeros(size(sortingWTMean, 2) - 1, 1);
    % 
    %                 for i = 1:size(differenceGraphletsSorting, 1)
    %                     differenceGraphletsSorting(i) = sortingWTMean(i + 1) - sortingWTMean(i);
    %                 end

                    iterationAlgorithm = distanceMatrix(algorithmsFilter == 1, algorithmsFilter == 1);
                    iterationNames = names(algorithmsFilter);
                    iterationControlFilter = cellfun(@(x) size(strfind(x, 'Control'), 1) > 0, iterationNames);
                    iterationWTNames = iterationNames(iterationControlFilter == 0);
                    %iterationWTNamesSplitted = cellfun(@(x) strsplit(x, 'It'), iterationWTNames, 'UniformOutput', false);
    %                 [~, it] = sort(cellfun(@(x) str2num(x{end}), iterationWTNamesSplitted));
    %                 iterationWTNames = iterationWTNames(it);
                    iterationWT = iterationAlgorithm(iterationControlFilter == 0, iterationControlFilter);

                    %iterationWTMean = mean(iterationWT(it, :), 2)';
                    iterationWTMean = mean(iterationWT(:, :), 2)';
    %                 differenceGraphletsIteration = zeros(size(iterationWTMean, 2) - 1, 1);
    % 
    %                 for i = 1:size(differenceGraphletsIteration, 1)
    %                     differenceGraphletsIteration(i) = iterationWTMean(i + 1) - iterationWTMean(i);
    %                 end
                    mstNames = names(algorithmsFilter == 0 & sortingFilter == 0);
                    mstAlgorithm = distanceMatrix(algorithmsFilter == 0 & sortingFilter == 0, algorithmsFilter);
                    mstWT = mstAlgorithm(:, iterationControlFilter);
                    mstWTMean = mean(mstWT(:, :), 2)';
                    if isempty(mstWTMean)
                        mstWTMean = 0;
                    end
                    
                    if isempty(iterationWTMean)
                        iterationWTMean = 0;
                    end
                    outputFile = strjoin(graphletNameSplitted(1:end-1), '\');
                    save(strcat(outputFile, '\meanDistanceWithControl', upper(typeOfDistance) ,'.mat'), 'sortingWTNames', 'sortingWTMean', 'iterationWTNames', 'iterationWTMean', 'mstNames', 'mstWTMean');
            else
                graphletNameSplitted(end-1)
                distanceMatrixInit = dlmread(fullPathGraphlet, '\t', 1, 1);
                names = importfileNames(fullPathGraphlet);
                [names, it] = sort(names);
                distanceMatrix = distanceMatrixInit(it, it);
                pacientArray(end+1, 1) = graphletNameSplitted(end-1);
                
                algorithmsFilter = cellfun(@(x) isempty(strfind(x, 'BetweenPairs')) == 0, names);
                sortingWTMean = distanceMatrix(1, algorithmsFilter == 0);
                sortingWTMean = sortingWTMean(2:end);
                
                differenceGraphletsSorting = zeros(size(sortingWTMean, 2) - 1, 1);

                for i = 1:size(differenceGraphletsSorting, 1)
                    differenceGraphletsSorting(i) = sortingWTMean(i + 1) - sortingWTMean(i);
                end
                
                iterationWTNames = names(algorithmsFilter);
                iterationWTNamesSplitted = cellfun(@(x) strsplit(x, 'It'), iterationWTNames, 'UniformOutput', false);
                [~, it] = sort(cellfun(@(x) str2num(x{end}), iterationWTNamesSplitted));
                iterationWTNames = iterationWTNames(it);
                iterationWTMean = distanceMatrix(1, algorithmsFilter);
                iterationWTMean = iterationWTMean(it);
%                 differenceGraphletsIteration = zeros(size(iterationWTMean, 2) - 1, 1);
% 
%                 for i = 1:size(differenceGraphletsIteration, 1)
%                     differenceGraphletsIteration(i) = iterationWTMean(i + 1) - iterationWTMean(i);
%                 end
            end
            
            pacientArray(end+1, 1) = graphletNameSplitted(end-1);
            mstWTMeanArray(end+1, 1) = {mstWTMean'};
            sortingWTMeanArray(end+1, 1) = {sortingWTMean'};
            %sortingWTSizeArray(end+1, 1) = {size(sortingWTMean, 2)};
            %differenceGraphletsSortingArray(end+1, 1) = {differenceGraphletsSorting};
            iterationWTMeanArray(end+1, 1) = {iterationWTMean'};
            %iterationWTSizeArray(end+1, 1) = {size(iterationWTMean, 2)};
            
            %differenceGraphletsIterationArray(end+1, 1) = {differenceGraphletsIteration};
        end
    end
    
    pacientArray;
    sortingWTMeanArray = padcat(sortingWTMeanArray{:});
    %differenceGraphletsSortingArray = padcat(differenceGraphletsSortingArray{:});
    %sortingWTSizeArray = cell2mat(sortingWTSizeArray);
    sortingCharacteristics = [sortingWTMeanArray];
    
    iterationWTMeanArray = padcat(iterationWTMeanArray{:});
    %differenceGraphletsIterationArray = padcat(differenceGraphletsIterationArray{:});
    %iterationWTSizeArray = cell2mat(iterationWTSizeArray);
    iterationCharacteristics = [iterationWTMeanArray];
    mstWTMeanArray = cell2mat(mstWTMeanArray);
    mstCharacteristics = [mstWTMeanArray];

    allCharacteristics = [sortingCharacteristics, iterationCharacteristics, mstCharacteristics];
    
    outputFile = strjoin(graphletNameSplitted(1:end-2), '\');
    csvwrite(strcat(outputFile, '\characteristics_', marker, '_', upper(typeOfDistance), '.csv'), allCharacteristics);
end

