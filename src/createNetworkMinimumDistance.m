function [ ] = createNetworkMinimumDistance( )
%CREATENETWORKMINIMUMDISTANCE Applies 3 minimumDistance algorithms to the images found on the current directory
%   We go through every image in the folder and get three network each one in a different way:
%   - minimumDistanceClasses: given the vector of distances between every nodes ordered from low to high. 
%   We take the lowest and removes it from the vector. Also we add an edge between those two nodes. 
%   This is done until the graph is connected.
%   - minimumDistanceClassesBetweenPairs: It returns an sparse connected matrix. We run the algorithm through N iterations. On each iteration we connect the N-th closest neighbour of each node (not connected before) until the graph is connected. We always end up with nodes with N edges at least.
%   - everyDistanceClasses: It returns the distance matrix of every node against every node.
%
%   Then, we output every network to a mat file and the associated siff file to visualize it on cytoscape (e.g).
%
%   Developed by Pablo Vicente-Munuera
    [stat,struc] = fileattrib;
    PathCurrent = struc.Name;
    lee_imagenes = dir(PathCurrent);
    lee_imagenes = lee_imagenes(3:size(lee_imagenes,1)-2)
    %We go through every image in the folder
    for imK = 1:size(lee_imagenes,1)
        %If it's a directory and positive image (marker positive). Also we exclude the files of col, ret, CD31 and GAG
        if (lee_imagenes(imK).isdir == 0 && size(strfind(lower(lee_imagenes(imK).name), 'neg'),1) == 0 && (size(strfind(lee_imagenes(imK).name, 'COL'),1) == 0 && size(strfind(lee_imagenes(imK).name, 'CD31'),1) == 0 && size(strfind(lee_imagenes(imK).name, 'RET'),1) == 0 && size(strfind(lee_imagenes(imK).name, 'GAG'),1) == 0))
            lee_imagenes(imK).name
            Img=imread(lee_imagenes(imK).name);
			
			%Clusterize image
			Img = im2bw(Img(:,:,1), 0.2);
			C = bwlabel(Img);
			S = regionprops(C,'Centroid');
			Centroids = vertcat(S.Centroid);

			% Measure pairwise distance
			distanceBetweenObjects = pdist(Centroids,'euclidean');
			
            %--------------------- minimumDistance ------------------%
            %Get output file names
            inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
            outputFileName = strcat('Adjacency\minimumDistanceClasses', inNameFile(1), '.mat')
            outputFileNameSif = strcat('visualize\minimumDistanceClasses', inNameFile(1), '.cvs');
            if exist(outputFileName{:}, 'file') ~= 2
                %minimumDistance algorithm that outputs an adjacencyMatrix which is connected (i.e. only one connected component).
                adjacencyMatrix = GetConnectedGraphWithMinimumDistances(distanceBetweenObjects , sparse(size(S,1), size(S,1)), zeros(1));
                %Saving file
                save(outputFileName{:}, 'adjacencyMatrix', '-v7.3');
                generateSIFFromAdjacencyMatrix(adjacencyMatrix, outputFileNameSif{:});
			elseif exist(outputFileNameSif{:}, 'file') ~= 2 %In case the sif doesn't exist, we create it
				load(outputFileName{:},'-mat')
				generateSIFFromAdjacencyMatrix(adjacencyMatrix, outputFileNameSif{:});
            end
            %--------------------------------------------------------%

            %--------------------- minimumDistanceClassesBetweenPairs ------------------%
			%Get output file names
            inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
            outputFileName = strcat('Adjacency\minimumDistanceClassesBetweenPairs', inNameFile(1), '.mat')
			outputFileNameSif = strcat('visualize\minimumDistanceClassesBetweenPairs', inNameFile(1), '.cvs');
			%Another type of graph
            if exist(outputFileName{:}, 'file') ~= 2 
                adjacencyMatrix = GetConnectedGraphWithMinimumDistanceBetweenPairs(distanceBetweenObjects , sparse(size(S,1), size(S,1)), zeros(1));
                %Saving file
                save(outputFileName{:}, 'adjacencyMatrix', '-v7.3');
                %exporting to siff
                generateSIFFromAdjacencyMatrix(adjacencyMatrix, outputFileNameSif{:});
			elseif exist(outputFileNameSif{:}, 'file') ~= 2 %In case the sif doesn't exist, we create it
				clear adjacencyMatrix
				load(outputFileName{:},'-mat')
				generateSIFFromAdjacencyMatrix(adjacencyMatrix, outputFileNameSif{:});
            end
            %--------------------------------------------------------%
			
            %--------------------- everyDistanceClasses ------------------%
			%Get output file names
            inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
            outputFileName = strcat('Adjacency\everyDistanceClasses', inNameFile(1), '.mat')
			outputFileNameSif = strcat('visualize\everyDistanceClasses', inNameFile(1), '.cvs');
            if exist(outputFileName{:}, 'file') ~= 2
                adjacencyMatrixComplete = GetCompleteGraphWithEveryDistance(distanceBetweenObjects , zeros(size(S,1), size(S,1)), zeros(1));
                %Saving file
                save(outputFileName{:}, 'adjacencyMatrixComplete', '-v7.3');
                %exporting to siff
                generateSIFFromAdjacencyMatrix(adjacencyMatrixComplete, outputFileNameSif{:});
			elseif exist(outputFileNameSif{:}, 'file') ~= 2 %In case the sif doesn't exist, we create it
				clear adjacencyMatrixComplete
				load(outputFileName{:},'-mat')
				generateSIFFromAdjacencyMatrix(adjacencyMatrixComplete, outputFileNameSif{:});
            end

            %--------------------------------------------------------%
            
            %--------------------- minimumDistanceIt ------------------%
            %Get output file names
            inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
            outputFileName = strcat('Adjacency\minimumDistanceClasses', inNameFile(1), 'It1.mat')
            if exist(outputFileName{:}, 'file') ~= 2
                %minimumDistance algorithm that outputs an adjacencyMatrix which is connected (i.e. only one connected component).
                adjacencyMatrix = GetConnectedGraphWithMinimumDistancesByIteration(distanceBetweenObjects , sparse(size(S,1), size(S,1)), zeros(1), inNameFile);
            end
            %--------------------------------------------------------%
            
            %--------------------- minimumDistanceBetweenPairsIt ------------------%
            %Get output file names
            inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
            outputFileName = strcat('Adjacency\minimumDistanceClassesBetweenPairs', inNameFile(1), 'It1.mat')
			if exist(outputFileName{:}, 'file') ~= 2
                %minimumDistance algorithm that outputs an adjacencyMatrix which is connected (i.e. only one connected component).
                adjacencyMatrix = GetConnectedGraphWithMinimumDistancesBetweenPairsByIteration(distanceBetweenObjects , sparse(size(S,1), size(S,1)), zeros(1), inNameFile);
            end
            %--------------------------------------------------------%
		end
    end
end

