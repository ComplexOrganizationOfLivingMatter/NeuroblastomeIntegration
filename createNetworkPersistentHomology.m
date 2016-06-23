function [ ] = createNetworkPersistentHomology( )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    [stat,struc] = fileattrib;
    PathCurrent = struc.Name;
    lee_imagenes = dir(PathCurrent);
    lee_imagenes = lee_imagenes(3:size(lee_imagenes,1)-2)
    for imK = 1:size(lee_imagenes,1)
        if (lee_imagenes(imK).isdir == 0 && size(strfind(lower(lee_imagenes(imK).name), 'pos'),1) == 0 && (size(strfind(lee_imagenes(imK).name, 'COL'),1) == 0 && size(strfind(lee_imagenes(imK).name, 'CD31'),1) == 0 && size(strfind(lee_imagenes(imK).name, 'RET'),1) == 0 && size(strfind(lee_imagenes(imK).name, 'GAG'),1) == 0))
            lee_imagenes(imK).name
            Img=imread(lee_imagenes(imK).name);
			
			%Clusterize image
			Img = im2bw(Img(:,:,1), 0.2);
			C = bwlabel(Img);
			S = regionprops(C,'Centroid');
			Centroids = vertcat(S.Centroid);

			%// Measure pairwise distance
			distanceBetweenObjects = pdist(Centroids,'euclidean');
			if size(distanceBetweenObjects, 2) > 1
                inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
                outputFileNameDistanceMatrix = strcat('visualize\persistentHomology', inNameFile(1), 'DistanceMatrix.distmat')
                fileID = fopen(outputFileNameDistanceMatrix{:}, 'w');
                fprintf(fileID,'%d\r\n', size(squareform(distanceBetweenObjects),1));
                fprintf(fileID, '5 10 1000 2\r\n');
                fclose(fileID);
                dlmwrite(outputFileNameDistanceMatrix{:}, squareform(distanceBetweenObjects), '-append');
            end
%             adjacencyMatrix = sparse(size(S,1), size(S,1));
%             for radious = vecRadious
%                 outputFileName = strcat('Adjacency\persistentHomology', inNameFile(1), 'WithRadious', num2str(radious) ,'.mat')
%                 outputFileNameSif = strcat('visualize\persistentHomology', inNameFile(1), 'WithRadious', num2str(radious) ,'.cvs');
%                 outputFileNameEdgeList = strcat('visualize\persistentHomology', inNameFile(1), 'WithRadious', num2str(radious) ,'.edgelist');
%                 if exist(outputFileName{:}, 'file') ~= 2
%                     adjacencyMatrix = GetGraphWithRadiousDistance(distanceBetweenObjects , adjacencyMatrix , radious);
%                     %Saving file
%                     save(outputFileName{:}, 'adjacencyMatrix', '-v7.3');
%                     generateSIFFromAdjacencyMatrix(adjacencyMatrix, outputFileNameSif{:});
%                     generateEdgeListFromAdjacencyMatrix(adjacencyMatrix, outputFileNameEdgeList{:});
%                 end
%             end
        end
    end
end

