function [ ] = pipelineAnalyzeNetworksWithGraphlets( marker, dirName, pathFiles )
%PIPELINEANALYZENETWORKSWITHGRAPHLETS Summary of this function goes here
%   Detailed explanation goes here
    addpath(genpath('src'));

    if exist('pathFiles', 'var') == 0
        pathFiles = '..\Datos\Data\NuevosCasos160\Casos\';
        outputDir = strcat('..\Results\capturingFeatures\Human\NuevosCasos160\MarkersFeatures\', dirName);
    else
        pathFilesSplitted = strsplit(pathFiles, '\\Data');
        outputDir = strcat('..\Results\capturingFeatures\', pathFilesSplitted{end},'\MarkersFeatures\', dirName);
    end

    basePath = strcat(pathFiles, dirName);

    mkdir(outputDir, '\ControlNetwork');
    mkdir(outputDir, '\DistanceMatrixWeights');
    mkdir(outputDir, '\IterationAlgorithm');
    mkdir(outputDir, '\SortingAlgorithm');
    mkdir(outputDir, '\MinimumSpanningTree');

    mkdir(outputDir, '\GraphletVectors');
    mkdir(outputDir, '\GraphletsCount');

    if isequal(marker, 'VTN')
        getMinimumDistancesFromHexagonalGrid(strcat(basePath, '\Images\'), strcat(marker, '_HEPA_mask'), outputDir);
        getMinimumDistancesFromHexagonalGrid(strcat(basePath, '\Images\'), strcat(marker, '_MACR_mask'), outputDir);
        %createNetworkMinimumDistance(strcat(basePath, '\Images\'), strcat(marker, '_CELS_'));
        compareQuantitiesOfPixelsWithinImages( strcat(outputDir, '\DistanceMatrixWeights\'), strcat(marker, '_HEPA_mask'), strcat(outputDir, '\DistanceMatrixWeights\'), strcat(marker, '_MACR_mask'), basePath );
        createMinimumSpanningTreeFromNetworks(strcat(outputDir, '\DistanceMatrixWeights'), marker);
    elseif isequal(lower(marker), lower('RET')) || isequal(dirName, 'VasosSanguineos') ||  isequal(lower(marker), lower('COL')) ||  isequal(lower(marker), lower('GAGs')) || isequal(lower(marker), lower('CD240')) || isequal(lower(marker), lower('LYVE1'))
        %createNetworkMinimumDistance(strcat(basePath, '\Images\'), strcat(marker, '_CELS_'));
        getMinimumDistancesFromHexagonalGrid(strcat(basePath, '\Images\'), strcat(marker, '_mask'), outputDir);
        createMinimumSpanningTreeFromNetworks(strcat(outputDir, '\DistanceMatrixWeights'), marker);
    else
        %This functions may not work
        createNetworkMinimumDistance(strcat(basePath, '\Images\'), '_POSITIVAS_');
        createNetworkMinimumDistance(strcat(basePath, '\Images\'), '_NEGATIVAS_');
    end

    if isequal(marker, 'VTN')
        exportCharacteristicsAsCSV(strcat(outputDir, '\DistanceMatrixWeights'), '_HEPA_');
        exportCharacteristicsAsCSV(strcat(outputDir, '\DistanceMatrixWeights'), '_MACR_');
        compareNegativeAndPositiveImages(strcat(basePath, '\Images\'), marker);
    else
        exportCharacteristicsAsCSV(strcat(outputDir, '\DistanceMatrixWeights'), []);
    end
          

%     %Execute minimumDistances.py to get the networks
%     answer = 'n';
%     while answer ~= 'y'
%         answer = input('Have you executed minimumDistance.py? [y/n] ');
%     end

    disp('Leda files...');
    disp('Iteration');
    calculateLEDAFilesFromDirectory(strcat(outputDir, '\IterationAlgorithm\'));
    disp('Sorting');
    calculateLEDAFilesFromDirectory(strcat(outputDir, '\SortingAlgorithm\'));
    disp('MST');
    calculateLEDAFilesFromDirectory(strcat(outputDir, '\MinimumSpanningTree\'));
    
%     %Execute ./runGraphletCounter.sh to get graphlets
%     answer = 'n';
%     while answer ~= 'y'
%         answer = input('Have you executed ./runGraphletCounter.sh? [y/n] ');
%     end
    
    sortBySample(strcat(outputDir, '\GraphletsCount\'), marker);
    
%     %Execute ./runNetworkComparisonGraphlets.sh  to get the distances between real image and control
%     answer = 'n';
%     while answer ~= 'y'
%         answer = input('Have you executed ./runNetworkComparisonGraphlets.sh? [y/n] ');
%     end
    if isequal(marker, 'VTN')
        analyzeGraphletsDistances(strcat(outputDir, '\GraphletsCount\'), 'MACR', 'gdda');
        analyzeGraphletsDistances(strcat(outputDir, '\GraphletsCount\'), 'HEPA', 'gdda');
    else
        analyzeGraphletsDistances(strcat(outputDir, '\GraphletsCount\'), marker, 'gdda');
    end
    
end

