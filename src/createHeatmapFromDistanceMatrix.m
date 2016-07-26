function [] = createHeatmapFromDistanceMatrix( distanceMatrix, nameFiles, markersNames, markersWeWantToShow, algorithm, algorithmWeWantToShow )
%CREATEHEATMAPFROMDISTANCEMATRIX Summary of this function goes here
%   Detailed explanation goes here

    [newNames, newMatrix, splittedNames] = removeNaNs(distanceMatrix, nameFiles);
    
    splittedNamesDataset = cell2dataset([{'Marker', 'Case', 'Iteration', 'Algorithm', 'Positive', 'Core', 'MatrixPosition'}; splittedNames]);
    
    for actualAlgorithm = 1:size(algorithmWeWantToShow, 2)
        algorithmFilter = splittedNamesDataset(ismember(splittedNamesDataset.Algorithm, algorithmWeWantToShow(actualAlgorithm)), :);
        if isempty(algorithmFilter) == 0
            newOrder = zeros(size(distanceMatrix, 1), 1);
            actualRow = 1;
            for actualCase = 1 %:11
                caseFilter = algorithmFilter(str2num(cell2mat(algorithmFilter.Case(:))) == actualCase, :);
                if isempty(caseFilter) == 0
                    for actualMarker = 1:size(markersWeWantToShow, 2)
                        markerFilter = caseFilter(ismember(markersNames(caseFilter.Marker), markersWeWantToShow(actualMarker)), :);

                        if isempty(markerFilter) == 0
                            for actualPositive = 0:1
                                positiveFilter = markerFilter(markerFilter.Positive == actualPositive, :);
                                if isempty(positiveFilter) == 0
                                    for actualCore = ['A', 'B']
                                        coreFilter = positiveFilter(ismember(positiveFilter.Core, actualCore), :);
                                        if isempty(coreFilter) == 0
                                            iters = sort(coreFilter.Iteration);
                                            for actualIter = 1:size(iters,1)
                                                newOrder(actualRow) = coreFilter(coreFilter.Iteration == iters(actualIter), :).MatrixPosition;
                                                actualRow = actualRow + 1;
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    newOrder = newOrder(newOrder ~= 0);
    
    distanceMatrixFiltered = zeros(size(newOrder,1), size(newOrder,1));
    for row = 1:size(newOrder,1)
       for col = 1:size(newOrder,1)
           distanceMatrixFiltered(row, col) = distanceMatrix(newOrder(row), newOrder(col));
       end
    end
    %HeatMap(distanceMatrixFiltered);
    distanceMatrix = distanceMatrixFiltered/max(distanceMatrixFiltered(:))*255;
    image(distanceMatrix);
end

