function [ ] = calculateBasicMeasuresOfAllNetworksOfDirectory( )
%calculateBasicMeasuresOfAllNetworksOfDirectory Calculate basic measures of all the .mat found in the current path
%   It calculates cClustering Coefficient UU, Clustering Coefficient WU, Assortivity, Density UU, Efficiency, 
%	Diameter and Characteristic path length of every adjacency matrix found. Then it exports all the measures
%	within a .csv file.
%
%   Developed by Pablo Vicente-Munuera

    [stat,struc] = fileattrib;
    PathCurrent = struc.Name;
    lee_matrices = dir(PathCurrent);
    lee_matrices = lee_matrices(3:size(lee_matrices,1));
    for imK = 1:size(lee_matrices,1)
         lee_matrices(imK).name
         inNameFile = strsplit(lee_matrices(imK).name, '.');
         outputFileName = strcat('..\..\stats', inNameFile(1), '.csv')
         if exist(outputFileName{:}, 'file') ~= 2
            fileID = fopen(outputFileName{:}, 'w');
            fprintf(fileID, 'Type, Clustering Coefficient UU, Clustering Coefficient WU, Assortivity, Density UU, Efficiency, Diameter, Characteristic path length\r\n');
            load(lee_matrices(imK).name);
            if exist('adjacencyMatrix', 'var') == 1
                fprintf(fileID, 'Clusters, %s\r\n', calculateBasicMeasuresOfNetwork(adjacencyMatrix));
                clear adjacencyMatrix
            end
            if exist('adjacencyMatrixComplete', 'var') == 1
                fprintf(fileID, 'Connected, %s\r\n', calculateBasicMeasuresOfNetwork(adjacencyMatrixComplete));
                clear adjacencyMatrixComplete
            end
            fclose(fileID);
         end
    end

end

