function [ ] = createNetworkMinimumDistance( )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    [stat,struc] = fileattrib;
    PathCurrent = struc.Name;
    lee_imagenes = dir(PathCurrent);
    lee_imagenes = lee_imagenes(3:size(lee_imagenes,1))
    for imK = 1:size(lee_imagenes,1)
        if (lee_imagenes(imK).isdir == 0 && size(strfind(lower(lee_imagenes(imK).name), 'neg'),1) == 0)
            lee_imagenes(imK).name
            Img=imread(lee_imagenes(imK).name);
			
			%Clusterize image
			Img = im2bw(Img, 0.2);
			C = bwlabel(Img);
			S = regionprops(C,'Centroid');
			Centroids = vertcat(S.Centroid);

			%// Measure pairwise distance
			distanceBetweenObjects = pdist(Centroids,'euclidean');
			
			adjacencyMatrixComplete = GetConnectedGraphWithMinimumDistances(distanceBetweenObjects , sparse(size(S,1), size(S,1)), zeros(1));
            %Saving file
            inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
            outputFileName = strcat('Adjacency\minimumDistanceClasses', inNameFile(1), '.mat')
            save(outputFileName{:}, 'adjacencyMatrixComplete', '-v7.3');
            outputFileNameSif = strcat('visualize\minimumDistanceClasses', inNameFile(1), '.cvs');
            generateSIFFromAdjacencyMatrix(adjacencyMatrixComplete, outputFileNameSif{:});
			
			%Another type of graph
			adjacencyMatrixComplete = GetConnectedGraphWithMinimumDistanceBetweenPairs(distanceBetweenObjects , sparse(size(S,1), size(S,1)), zeros(1));
            %Saving file
            inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
            outputFileName = strcat('Adjacency\minimumDistanceClassesBetweenPairs', inNameFile(1), '.mat')
            save(outputFileName{:}, 'adjacencyMatrixComplete', '-v7.3');
            outputFileNameSif = strcat('visualize\minimumDistanceClasses', inNameFile(1), '.cvs');
            generateSIFFromAdjacencyMatrix(adjacencyMatrixComplete, outputFileNameSif{:});
			
			%CompleteGraph
			adjacencyMatrixComplete = GetCompleteGraphWithEveryDistance(distanceBetweenObjects , sparse(size(S,1), size(S,1)), zeros(1));
            %Saving file
            inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
            outputFileName = strcat('Adjacency\everyDistanceClasses', inNameFile(1), '.mat')
            save(outputFileName{:}, 'adjacencyMatrixComplete', '-v7.3');
            outputFileNameSif = strcat('visualize\minimumDistanceClasses', inNameFile(1), '.cvs');
            generateSIFFromAdjacencyMatrix(adjacencyMatrixComplete, outputFileNameSif{:});
        end
    end
end

