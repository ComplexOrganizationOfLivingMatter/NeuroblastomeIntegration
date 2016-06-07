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
			Img = im2bw(Img(:,:,1), 0.2);
			C = bwlabel(Img);
			S = regionprops(C,'Centroid');
			Centroids = vertcat(S.Centroid);

			%// Measure pairwise distance
			distanceBetweenObjects = pdist(Centroids,'euclidean');
			
            inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
            outputFileName = strcat('Adjacency\minimumDistanceClasses', inNameFile(1), '.mat')
            outputFileNameSif = strcat('visualize\minimumDistanceClasses', inNameFile(1), '.cvs');
            if exist(outputFileName{:}, 'file') ~= 2
                adjacencyMatrixComplete = GetConnectedGraphWithMinimumDistances(distanceBetweenObjects , sparse(size(S,1), size(S,1)), zeros(1));
                %Saving file
                save(outputFileName{:}, 'adjacencyMatrixComplete', '-v7.3');
                generateSIFFromAdjacencyMatrix(adjacencyMatrixComplete, outputFileNameSif{:});
			elseif exist(outputFileNameSif{:}, 'file') ~= 2
				load(outputFileName{:},'-mat')
				generateSIFFromAdjacencyMatrix(adjacencyMatrixComplete, outputFileNameSif{:});
            end
			
            inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
            outputFileName = strcat('Adjacency\minimumDistanceClassesBetweenPairs', inNameFile(1), '.mat')
			outputFileNameSif = strcat('visualize\minimumDistanceClassesBetweenPairs', inNameFile(1), '.cvs');
			%Another type of graph
            if exist(outputFileName{:}, 'file') ~= 2
                adjacencyMatrixComplete = GetConnectedGraphWithMinimumDistanceBetweenPairs(distanceBetweenObjects , sparse(size(S,1), size(S,1)), zeros(1));
                %Saving file
                save(outputFileName{:}, 'adjacencyMatrixComplete', '-v7.3');
                generateSIFFromAdjacencyMatrix(adjacencyMatrixComplete, outputFileNameSif{:});
			elseif exist(outputFileNameSif{:}, 'file') ~= 2
				clear adjacencyMatrixComplete
				load(outputFileName{:},'-mat')
				generateSIFFromAdjacencyMatrix(adjacencyMatrixComplete, outputFileNameSif{:});
            end
			
			%CompleteGraph
            inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
            outputFileName = strcat('Adjacency\everyDistanceClasses', inNameFile(1), '.mat')
			outputFileNameSif = strcat('visualize\everyDistanceClasses', inNameFile(1), '.cvs');
            if exist(outputFileName{:}, 'file') ~= 2
                adjacencyMatrixComplete = GetCompleteGraphWithEveryDistance(distanceBetweenObjects , zeros(size(S,1), size(S,1)), zeros(1));
                %Saving file
                save(outputFileName{:}, 'adjacencyMatrixComplete', '-v7.3');
                generateSIFFromAdjacencyMatrix(adjacencyMatrixComplete, outputFileNameSif{:});
			elseif exist(outputFileNameSif{:}, 'file') ~= 2
				clear adjacencyMatrixComplete
				load(outputFileName{:},'-mat')
				generateSIFFromAdjacencyMatrix(adjacencyMatrixComplete, outputFileNameSif{:});
            end
		end
    end
end

