function [ ] = generateLEDAFromAdjacencyMatrix( adjacencyMatrix, nameFile )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    %adjacencyMatrix = full(adjacencyMatrix);
    idTril = tril(true(size(adjacencyMatrix)), -1);
    idTriu = triu(true(size(adjacencyMatrix)), -1);
    adjacencyMatrixAux = adjacencyMatrix;
    adjacencyMatrix(idTril) = 0;
    adjacencyMatrixAux(idTriu) = 0;
    adjacencyMatrix = adjacencyMatrixAux' | adjacencyMatrix;
    clear adjacencyMatrixAux idTriu idTril
    adjacencyMatrix = full(adjacencyMatrix);
    
    fileID = fopen(nameFile,'w');
    %Header leda file
    fprintf(fileID, 'LEDA.GRAPH\n');
    fprintf(fileID, 'void\n');
    fprintf(fileID, 'void\n');
    fprintf(fileID, '-2\n'); %Undirected graph
    %Nodes section
    fprintf(fileID, '%d\n', size(adjacencyMatrix, 1)); %Number of nodes
    for node = 1:size(adjacencyMatrix, 1)
        fprintf(fileID, '|{}|\n'); %Node
    end
    %Edges section
    fprintf(fileID, '%d\n', size(adjacencyMatrix(adjacencyMatrix>0), 1)); %Number of nodes
    for i = 1:size(adjacencyMatrix,1)
        for j = 1:size(adjacencyMatrix,2)
            if adjacencyMatrix(i,j) > 0
                fprintf(fileID, '%d %d 0 |{}|\n', i, j);
            end
        end
    end
    fclose(fileID);

end
