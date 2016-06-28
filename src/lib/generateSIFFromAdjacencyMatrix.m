function [ ] = generateSIFFromAdjacencyMatrix( adjacencyMatrix, nameFile )
%GENERATESIFFROMADJACENCYMATRIX Generates a sif file from an adjacency matrix
%   Generates a .sif file that will allow us to visualize the network (found 
%   inside adjacencyMatrix) with cytoscape (or, maybe, other similar programs).
%   
%   Format of a .sif file:
%   Vertex1 pp Vertex2 WeightOfEdge
%   However, as header we have:
%   source interaction target weight
%
%   -Input-
%   adjacencyMatrix:
%   nameFile:
%
%   Developed by Pablo Vicente-Munuera

    %Open file
    fileID = fopen(nameFile,'w');
    %Get the full matrix from a sparse one
    adjacencyMatrix = full(adjacencyMatrix);
    %Header of the file
    fprintf(fileID, 'source interaction target weight\n');
    for i = 1:size(adjacencyMatrix,1)
        for j = 1:size(adjacencyMatrix,2)
            %If there's an edge
            if adjacencyMatrix(i,j) > 0
                %Vertex1 pp Vertex2 WeightOfEdge
                fprintf(fileID, '%d pp %d %d\n', i, j, adjacencyMatrix(i,j));
            end
        end
    end
    fclose(fileID);

end

