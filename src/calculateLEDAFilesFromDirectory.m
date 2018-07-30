function [ ] = calculateLEDAFilesFromDirectory(PathCurrent)
%calculateLEDAFilesFromDirectory generates a LEDA file from every .mat file of the current directory
%   It takes the .mat files of a given directory and generates a LEDA file (.gw), which will contain
%   an undirected, no-duplicates (edges) network, from an adjacency matrix found on the .mat file.
%
%   Developed by Pablo Vicente-Munuera
    lee_matrices = dir(PathCurrent);
    lee_matrices = lee_matrices(3:size(lee_matrices,1));
    for imK = 1:size(lee_matrices,1)
        fullPathImage = strcat(PathCurrent, lee_matrices(imK).name);
        fullPathImageSplitted = strsplit(fullPathImage, '\');
        if (lee_matrices(imK).isdir == 0 && isempty(strfind(lower(lee_matrices(imK).name), lower('cels'))) && (size(strfind(lower(lee_matrices(imK).name), lower('ItFinal')), 1) == 1 || isempty(strfind(lower(lee_matrices(imK).name), lower('It'))) == 1))
            lee_matrices(imK).name
            inNameFile = strsplit(lee_matrices(imK).name, '.');
            outputLEDAFileName = strcat(strjoin(fullPathImageSplitted(1:end-2), '\'), '\GraphletsCount\', inNameFile(1), '.gw');
            outputLEDAFileNameExists = strcat(strjoin(fullPathImageSplitted(1:end-2), '\'), '\GraphletVectors\', inNameFile(1), '.gw');
            if exist(outputLEDAFileNameExists{:}, 'file') ~= 2 && exist(outputLEDAFileName{:}, 'file') ~= 2
                fileObj = matfile(fullPathImage);
                vars = whos(fileObj);
                if ismember('adjacencyMatrix', {vars.name})
                    adjacencyMatrix = fileObj.adjacencyMatrix;
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
                if ismember('adjacencyMatrixComplete', {vars.name})
                    adjacencyMatrixComplete = fileObj.adjacencyMatrixComplete;
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

