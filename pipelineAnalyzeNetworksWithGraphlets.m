function [ ] = pipelineAnalyzeNetworksWithGraphlets( marker, dirName, pathFiles )
%PIPELINEANALYZENETWORKSWITHGRAPHLETS Summary of this function goes here
%   Detailed explanation goes here
    addpath(genpath('src'));
    
    if exist('pathFiles', 'var') == 0
        pathFiles = '..\Datos\Data\NuevosCasos160\Casos\';
    end
    
    basePath = strcat(pathFiles, dirName);
    mkdir(basePath, '\Networks\ControlNetwork');
    %mkdir(basePath, '\Networks\DistanceMatrix');
    mkdir(basePath, '\Networks\DistanceMatrixWeights');
    mkdir(basePath, '\Networks\IterationAlgorithm');
    mkdir(basePath, '\Networks\SortingAlgorithm');
    
    %mkdir(basePath, '\Networks\IterationUsingWeightsAlgorithm');
    %mkdir(basePath, '\Networks\SortingUsingWeightsAlgorithm');
    
    mkdir(basePath, '\Networks\GraphletVectors');
    mkdir(basePath, '\Networks\MinimumSpanningTree');
    
    if isequal(marker, 'VTN')
        getMinimumDistancesFromHexagonalGrid(strcat(basePath, '\Images\'), strcat(marker, '_HEPA_mask'));
        getMinimumDistancesFromHexagonalGrid(strcat(basePath, '\Images\'), strcat(marker, '_MACR_mask'));
        %createNetworkMinimumDistance(strcat(basePath, '\Images\'), strcat(marker, '_CELS_'));
        compareQuantitiesOfPixelsWithinImages( strcat(basePath, '\Networks\DistanceMatrixWeights\'), strcat(marker, '_HEPA_mask'), strcat(basePath, '\Networks\DistanceMatrixWeights\'), strcat(marker, '_MACR_mask') );
        createMinimumSpanningTreeFromNetworks(strcat(basePath, '\Networks\DistanceMatrixWeights'), marker);
    elseif isequal(lower(marker), lower('RET')) || isequal(dirName, 'VasosSanguineos') ||  isequal(lower(marker), lower('COL')) ||  isequal(lower(marker), lower('GAGs')) || isequal(lower(marker), lower('CD240')) || isequal(lower(marker), lower('LYVE1'))
        %createNetworkMinimumDistance(strcat(basePath, '\Images\'), strcat(marker, '_CELS_'));
        getMinimumDistancesFromHexagonalGrid(strcat(basePath, '\Images\'), strcat(marker, '_mask'));
        createMinimumSpanningTreeFromNetworks(strcat(basePath, '\Networks\DistanceMatrixWeights'), marker);
    else
        createNetworkMinimumDistance(strcat(basePath, '\Images\'), '_POSITIVAS_');
        createNetworkMinimumDistance(strcat(basePath, '\Images\'), '_NEGATIVAS_');
    end
    
     if isequal(marker, 'VTN')
         exportCharacteristicsAsCSV(strcat(basePath, '\Networks\DistanceMatrixWeights'), '_HEPA_');
         exportCharacteristicsAsCSV(strcat(basePath, '\Networks\DistanceMatrixWeights'), '_MACR_');
         compareNegativeAndPositiveImages(strcat(basePath, '\Images\'), marker);
     else
         exportCharacteristicsAsCSV(strcat(basePath, '\Networks\DistanceMatrixWeights'), []);
     end
          

    %Execute minimumDistances.py to get the networks with the Sorting
    %algorithm
    answer = 'n';
    while answer ~= 'y'
        answer = input('Have you executed minimumDistance.py? [y/n] ');
    end
    
    disp('Leda files...');
     disp('Iteration');
    calculateLEDAFilesFromDirectory(strcat(basePath, '\Networks\IterationAlgorithm\'), marker);
    %calculateLEDAFilesFromDirectory(strcat(basePath, '\Networks\IterationUsingWeightsAlgorithm\'), marker);
    disp('Sorting');
    calculateLEDAFilesFromDirectory(strcat(basePath, '\Networks\SortingAlgorithm\'), marker);
    %calculateLEDAFilesFromDirectory(strcat(basePath, '\Networks\SortingUsingWeightsAlgorithm\'), marker);
    disp('MST');
    calculateLEDAFilesFromDirectory(strcat(basePath, '\Networks\MinimumSpanningTree\'), marker);
%     
%     %divide by paciente the ndump2 files
%     graphletResultsDir = strcat('..\Results\graphletsCount\NuevosCasos\Markers\', upper(marker), '\NDUMP2\DivideByPacient\');
%     if exist(graphletResultsDir, 'dir') ~= 7
%         mkdir(graphletResultsDir);
%     end
end

