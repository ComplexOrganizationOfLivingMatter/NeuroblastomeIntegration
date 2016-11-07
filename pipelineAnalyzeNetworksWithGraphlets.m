function [ output_args ] = pipelineAnalyzeNetworksWithGraphlets( marker )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    cd 'E:\Pablo\Neuroblastoma\NeuroblastomeIntegration\'
    
    getMinimumDistancesFromHexagonalGrid('..\Datos\Data\NuevosCasos160\Casos\Images\', strcat(marker, '_mask'));
    
    disp('Leda files...');
    disp('Iteration');
    calculateLEDAFilesFromDirectory('..\Datos\Data\NuevosCasos160\Casos\Networks\IterationAlgorithm\', marker);
    disp('Sorting');
    calculateLEDAFilesFromDirectory('..\Datos\Data\NuevosCasos160\Casos\Networks\SortingAlgorithm\', marker);
    
    %divide by paciente the ndump2 files
    graphletResultsDir = strcat('..\Results\graphletsCount\NuevosCasos\', upper(marker), '\NDUMP2\DivideByPacient\');
    if exist(graphletResultsDir, 'dir') ~= 7
        mkdir(graphletResultsDir);
    end
    answer = 'n';
    while answer ~= 'y'
        answer = input('Are .ndump2 created? [y/n] ');
    end
    
    disp('Analyzing .ndump2 results...');
    analyzeGraphletsDistances(strcat('..\Results\graphletsCount\NuevosCasos\', upper(marker), '\NDUMP2\DivideByPacient\'), 'gdda');
end

