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
        if (lee_matrices(imK).isdir == 0 && size(strfind(lower(lee_matrices(imK).name), 'distancematrix'),1) == 0)
            lee_matrices(imK).name
            inNameFile = strsplit(lee_matrices(imK).name, '.');
            outputLEDAFileName = strcat('../GraphletVectors/', inNameFile(1), '.gw')
            outputLEDAFileNameExists = strcat('../GraphletVectors/RET/', inNameFile(1), '.gw')
            if exist(outputLEDAFileNameExists{:}, 'file') ~= 2
                load(lee_matrices(imK).name);
                if exist('adjacencyMatrix', 'var') == 1
                    adjacencyMatrix(adjacencyMatrix > 0) = 1;
                    try
                        generateLEDAFromAdjacencyMatrix(sparse(adjacencyMatrix), outputLEDAFileName{:})
                        clear adjacencyMatrix
                    catch exception
                        disp(exception)
                        generateLEDAFromAdjacencyMatrix(adjacencyMatrix, outputLEDAFileName{:})
                        %error('An unexpected error has occured')
                    end
                end
                if exist('adjacencyMatrixComplete', 'var') == 1
                    try
                        generateLEDAFromAdjacencyMatrix(adjacencyMatrixComplete, outputLEDAFileName{:})
                        clear adjacencyMatrixComplete
                    catch exception
                        disp(exception)
                        %error('An unexpected error has occured')
                    end
                end
            end
        end
    end
end

