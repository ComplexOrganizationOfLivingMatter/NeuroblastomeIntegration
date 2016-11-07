function [ output_args ] = pipelineAnalyzeNetworksWithGraphlets( marker )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    cd 'E:\Pablo\Neuroblastoma\NeuroblastomeIntegration\'
    
    getMinimumDistancesFromHexagonalGrid('..\Datos\Data\NuevosCasos160\Casos\Images\', strcat(marker, '_mask'));
    
    calculateLEDAFilesFromDirectory
end

