function [ ] = pipelineAnalyzeNetworksWithGraphlets( marker, dirName )
%PIPELINEANALYZENETWORKSWITHGRAPHLETS Summary of this function goes here
%   Detailed explanation goes here
    cd 'E:\Pablo\Neuroblastoma\NeuroblastomeIntegration\'
    
    basePath = strcat('..\Datos\Data\NuevosCasos160\Casos\', dirName);
    mkdir(basePath, '\Networks\ControlNetwork');
    mkdir(basePath, '\Networks\DistanceMatrix');
    mkdir(basePath, '\Networks\IterationAlgorithm');
    mkdir(basePath, '\Networks\SortingAlgorithm');
    
    if isequal(marker, 'VTN')
        getMinimumDistancesFromHexagonalGrid(strcat(basePath, '\Images\'), strcat(marker, '_HEPA_mask'));
        getMinimumDistancesFromHexagonalGrid(strcat(basePath, '\Images\'), strcat(marker, '_MACR_mask'));
    elseif isequal(lower(marker), lower('RET'))
        createNetworkMinimumDistance(strcat(basePath, '\Images\'), strcat(marker, '_CELS_'));
        getMinimumDistancesFromHexagonalGrid(strcat(basePath, '\Images\'), strcat(marker, '_mask'));
    else
        createNetworkMinimumDistance(strcat(basePath, '\Images\'), '_POSITIVAS_');
        createNetworkMinimumDistance(strcat(basePath, '\Images\'), '_NEGATIVAS_');
    end

    
    %Execute minimumDistances.py to get the networks with the Sorting
    %algorithm
    answer = 'n';
    while answer ~= 'y'
        answer = input('Have you executed minimumDistance.py? [y/n] ');
    end
    
    disp('Leda files...');
    disp('Iteration');
    mkdir(strcat(basePath, '\Networks\IterationAlgorithm\'));
    calculateLEDAFilesFromDirectory(strcat(basePath, '\Networks\IterationAlgorithm\'), marker);
    disp('Sorting');
    mkdir(strcat(basePath, '\Networks\SortingAlgorithm\'));
    calculateLEDAFilesFromDirectory(strcat(basePath, '\Networks\SortingAlgorithm\'), marker);
    
    %divide by paciente the ndump2 files
    graphletResultsDir = strcat('..\Results\graphletsCount\NuevosCasos\', upper(marker), '\NDUMP2\DivideByPacient\');
    if exist(graphletResultsDir, 'dir') ~= 7
        mkdir(graphletResultsDir);
    end
%     answer = 'n';
%     while answer ~= 'y'
%         answer = input('Are .ndump2 created? [y/n] ');
%     end
%     
%     disp('Analyzing .ndump2 results...');
%     analyzeGraphletsDistances(strcat('..\Results\graphletsCount\NuevosCasos\', upper(marker), '\NDUMP2\DivideByPacient\'), marker ,'gdda');
end

