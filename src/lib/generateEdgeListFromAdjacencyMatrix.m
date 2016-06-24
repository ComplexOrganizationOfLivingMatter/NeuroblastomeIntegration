function [ ] = generateSIFFromAdjacencyMatrix( adjacencyMatrix, nameFile )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    fileID = fopen(nameFile,'w');
    adjacencyMatrix = full(adjacencyMatrix);
    for i = 1:size(adjacencyMatrix,1)
        for j = 1:size(adjacencyMatrix,2)
            if adjacencyMatrix(i,j) > 0
                fprintf(fileID, '%d %d\n', i, j);
            end
        end
    end
    fclose(fileID);

end

