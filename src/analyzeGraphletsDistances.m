function [ ] = analyzeGraphletsDistances( )
%analyzeGraphletsDistances Summary of this function goes here
%   Detailed explanation goes here
    graphletFiles = getAllFiles('E:\Pablo\Neuroblastoma\Results\graphletsCount\NuevosCasos\RET\NDUMP2\DivideByPacient\');

    for numFile = 1:size(graphletFiles,1)
        fullPathGraphlet = graphletFiles{numFile};
        graphletNameSplitted = strsplit(fullPathGraphlet, '\');
        graphletName = graphletNameSplitted(end);
        graphletName = graphletName{1};
        
        fid = fopen(strcat(strjoin(graphletNameSplitted(1:end-2), '\') ,'caracteristics.csv'), 'w');
        
        if size(strfind(graphletName, 'gcd73'), 1) > 0
            distanceMatrix = importfile(fullPathGraphlet);
            names = importfileNames(fullPathGraphlet);
            algorithmsFilter = cellfun(@(x) size(strfind(x, 'BetweenPairs'), 1) > 0, names);

            sortingAlgorithm = distanceMatrix(algorithmsFilter == 0, algorithmsFilter == 0);
            sortingNames = names(algorithmsFilter == 0);
            sortingControlFilter = cellfun(@(x) size(strfind(x, 'Control'), 1) > 0, sortingNames);
            sortingWTNames = sortingNames(sortingControlFilter == 0);
            sortingWT = sortingAlgorithm(sortingControlFilter == 0, sortingControlFilter);
            sortingWT = mean(sortingWT, 2);

            iterationAlgorithm = distanceMatrix(algorithmsFilter == 1, algorithmsFilter == 1);
            iterationNames = names(algorithmsFilter);
            iterationControlFilter = cellfun(@(x) size(strfind(x, 'Control'), 1) > 0, iterationNames);
            iterationWTNames = sortingNames(iterationControlFilter == 0);
            iterationWT = iterationAlgorithm(iterationControlFilter == 0, iterationControlFilter);
            iterationWT = mean(iterationWT, 2);
            
            outputFile = strjoin(graphletNameSplitted(1:end-1), '\');
            save(strcat(outputFile, '\meanDistanceWithControl.mat'), 'sortingWTNames', 'sortingWT', 'iterationWTNames', 'iterationWT');
            
            fprintf(fid, 
        end
        
        fclose(fid);
    end

end

