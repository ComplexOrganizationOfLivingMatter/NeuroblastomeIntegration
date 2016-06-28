function [ ] = calculateLEDAFilesFromDirectory( )
%calculateLEDAFilesFromDirectory generates a LEDA file from every .mat file of the current directory
%   It takes the .mat files of a given directory and generates a LEDA file (.gw), which will contain 
%   an undirected, no-duplicates (edges) network, from an adjacency matrix found on the .mat file.
%
%   Developed by Pablo Vicente-Munuera

    [stat,struc] = fileattrib;
    PathCurrent = struc.Name;
    lee_matrices = dir(PathCurrent);
    lee_matrices = lee_matrices(3:size(lee_matrices,1));
    for imK = 1:size(lee_matrices,1)
         lee_matrices(imK).name
         inNameFile = strsplit(lee_matrices(imK).name, '.');
         outputLEDAFileName = strcat('../visualize/', inNameFile(1), '.gw')
         %if exist(outputLEDAFileName{:}, 'file') ~= 2
            load(lee_matrices(imK).name);
            if exist('adjacencyMatrix', 'var') == 1
                generateLEDAFromAdjacencyMatrix(adjacencyMatrix, outputLEDAFileName{:})
                clear adjacencyMatrix
            end
            if exist('adjacencyMatrixComplete', 'var') == 1
                generateLEDAFromAdjacencyMatrix(adjacencyMatrixComplete, outputLEDAFileName{:})
                clear adjacencyMatrixComplete
            end
         %end
    end

end

