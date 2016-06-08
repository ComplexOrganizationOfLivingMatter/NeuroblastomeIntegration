function [ ] = calculateBasicMeasuresOfAllNetworksOfDirectory( )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
    cd 'Adjacency'
    [stat,struc] = fileattrib;
    PathCurrent = struc.Name;
    lee_matrices = dir(PathCurrent);
    lee_matrices = lee_matrices(1:size(lee_matrices,1));
    for imK = 1:size(lee_matrices,1)
         lee_imagenes(imK).name
         inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
         outputFileName = strcat('..\..\stats', inNameFile(1), '.csv')
         if exist(outputFileName{:}, 'file') ~= 2
            load(lee_imagenes(imK).name);
            if exist('adjacencyMatrix', 'var') == 1
                calculateBasicMeasuresOfNetwork(adjacencyMatrix);
            end
            if exist('adjacencyMatrixComplete', 'var') == 1
                calculateBasicMeasuresOfNetwork(adjacencyMatrixComplete);
            end
         end
    end

end

