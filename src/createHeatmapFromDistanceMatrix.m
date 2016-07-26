function [] = createHeatmapFromDistanceMatrix( distanceMatrix, nameFiles, markersNames, markersWeWantToShow, algorithm, algorithmWeWantToShow )
%CREATEHEATMAPFROMDISTANCEMATRIX Summary of this function goes here
%   Detailed explanation goes here

    [newNames, newMatrix, splittedNames] = removeNaNs(distanceMatrix, nameFiles);
    
    splittedNamesDataset = cell2dataset([{'Marker', 'Case', 'Iteration', 'Algorithm', 'Positive', 'Core', 'MatrixPosition'}; splittedNames]);
    
    for actualAlgorithm = 1:size(algorithmWeWantToShow, 2)
        algorithmFilter = splittedNamesDataset(ismember(splittedNamesDataset.Algorithm, algorithmWeWantToShow(actualAlgorithm)), :);
        if size(algorithmFilter, 1) > 0
            newOrder = zeros(size(distanceMatrix, 1), 1);
            actualRow = 1;
            for actualCase = 1 %:11
                caseFilter = algorithmFilter(algorithmFilter.Case == actualCase, :);
                if isempty(caseFilter)
                    for actualMarker = 1:size(markersWeWantToShow, 2)
                        markerFilter = caseFilter(caseFilter.Marker == markersWeWantToShow(actualMarker), :);
                        if isempty(markerFilter)
                            for actualPositive = 0:1
                                positiveFilter = markerFilter(markerFilter.Positive == actualPositive, :);
                                if isempty(positiveFilter)
                                    for actualCore = ['A', 'B']
                                        coreFilter = positiveFilter(positiveFilter.Core == actualCore, :);
                                        if isempty(coreFilter)
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
end

