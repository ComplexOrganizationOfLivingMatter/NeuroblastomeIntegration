function [ ] = generateEdgeListFromAdjacencyMatrix( adjacencyMatrix, nameFile )
%GENERATEEDGELISTFROMADJACENCYMATRIX Generates .edgelist file from an adjacency matrix
%   Generates a .edgelist file with the edges on each line.
%
%   Developed by Pablo Vicente-Munuera

    %Open the output file
    fileID = fopen(nameFile,'w');
    %Transform the sparse matrix into a full one
    adjacencyMatrix = full(adjacencyMatrix);

    %Go through all the positions of the matrix
    for i = 1:size(adjacencyMatrix,1)
        for j = 1:size(adjacencyMatrix,2)
            %If an edge exist
            if adjacencyMatrix(i,j) > 0
                %print the edge on the file
                fprintf(fileID, '%d %d\n', i, j);
            end
        end
    end
    fclose(fileID);
end