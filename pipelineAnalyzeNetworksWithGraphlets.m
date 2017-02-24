function [ ] = pipelineAnalyzeNetworksWithGraphlets( marker, dirName )
%PIPELINEANALYZENETWORKSWITHGRAPHLETS Summary of this function goes here
%   Detailed explanation goes here
    cd 'D:\Pablo\Neuroblastoma\NeuroblastomeIntegration\'
    
    basePath = strcat('..\Datos\Data\NuevosCasos160\Casos\', dirName);
    mkdir(basePath, '\Networks\ControlNetwork');
    mkdir(basePath, '\Networks\DistanceMatrix');
    mkdir(basePath, '\Networks\DistanceMatrixWeights');
    mkdir(basePath, '\Networks\IterationAlgorithm');
    mkdir(basePath, '\Networks\SortingAlgorithm');
    mkdir(basePath, '\Networks\GraphletVectors');
    mkdir(basePath, '\Networks\MinimumSpanningTree');
%     
    %VASOS SANGUINEOS CON HEXAGONAL GRID!!!!
    if isequal(marker, 'VTN')
        getMinimumDistancesFromHexagonalGrid(strcat(basePath, '\Images\'), strcat(marker, '_HEPA_mask'));
        getMinimumDistancesFromHexagonalGrid(strcat(basePath, '\Images\'), strcat(marker, '_MACR_mask'));
        createNetworkMinimumDistance(strcat(basePath, '\Images\'), strcat(marker, '_CELS_'));
    elseif isequal(lower(marker), lower('RET')) || isequal(dirName, 'VasosSanguineos') ||  isequal(lower(marker), lower('COL')) ||  isequal(lower(marker), lower('GAGs'))
        createNetworkMinimumDistance(strcat(basePath, '\Images\'), strcat(marker, '_CELS_'));
        getMinimumDistancesFromHexagonalGrid(strcat(basePath, '\Images\'), strcat(marker, '_mask'));
    else
        createNetworkMinimumDistance(strcat(basePath, '\Images\'), '_POSITIVAS_');
        createNetworkMinimumDistance(strcat(basePath, '\Images\'), '_NEGATIVAS_');
    end
    
    %exportCharacteristicsAsCSV(strcat(basePath, '\Networks\DistanceMatrixWeights'));

%     createMinimumSpanningTreeFromNetworks(strcat(basePath, '\Networks\DistanceMatrix'), marker);
%     %createMinimumSpanningTreeFromNetworks(strcat(basePath, '\Networks\ControlNetwork'), marker);
%     
%     %Execute minimumDistances.py to get the networks with the Sorting
%     %algorithm
%     answer = 'n';
%     while answer ~= 'y'
%         answer = input('Have you executed minimumDistance.py? [y/n] ');
%     end
%     
%     disp('Leda files...');
%     disp('Iteration');
%     calculateLEDAFilesFromDirectory(strcat(basePath, '\Networks\IterationAlgorithm\'), marker);
%     disp('Sorting');
%     calculateLEDAFilesFromDirectory(strcat(basePath, '\Networks\SortingAlgorithm\'), marker);
%     disp('MST');
%     calculateLEDAFilesFromDirectory(strcat(basePath, '\Networks\MinimumSpanningTree\'), marker);
%     
%     %divide by paciente the ndump2 files
%     graphletResultsDir = strcat('..\Results\graphletsCount\NuevosCasos\Markers\', upper(marker), '\NDUMP2\DivideByPacient\');
%     if exist(graphletResultsDir, 'dir') ~= 7
%         mkdir(graphletResultsDir);
%     end
end

