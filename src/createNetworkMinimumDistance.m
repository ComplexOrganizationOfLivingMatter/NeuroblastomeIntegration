function [ ] = createNetworkMinimumDistance( currentPath, markerWeWant )
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

    lee_imagenes = dir(currentPath);
    lee_imagenes = lee_imagenes(3:size(lee_imagenes,1)-2);
    %We go through every image in the folder
    for imK = 1:size(lee_imagenes,1)
        %If it's a directory and positive image (marker positive). Also we exclude the files of col, ret, CD31 and GAG
        if lee_imagenes(imK).isdir == 0 && isempty(strfind(lower(lee_imagenes(imK).name), markerWeWant)) == 1
            lee_imagenes(imK).name
            Img=imread(lee_imagenes(imK).name);
			
			%Clusterize image
			Img = im2bw(Img(:,:,1), 0.2);
			C = logical(Img);
			S = regionprops(C,'Centroid');
			Centroids = vertcat(S.Centroid);

			% Measure pairwise distance
			distanceBetweenObjects = pdist(Centroids,'euclidean');
            
            %--------------------- minimumDistanceBetweenPairsIt ------------------%
            %Get output file names
            distanceBetweenObjects = squareform(distanceBetweenObjects);
            inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
            outputFileName = strcat('Adjacency\minimumDistanceClassesBetweenPairs', inNameFile(1), 'It1.mat');
			if exist(outputFileName{:}, 'file') ~= 2
                %minimumDistance algorithm that outputs an adjacencyMatrix which is connected (i.e. only one connected component).
                try
                    adjacencyMatrix = GetConnectedGraphWithMinimumDistancesBetweenPairsByIteration(distanceBetweenObjects , sparse(size(S,1), size(S,1)), zeros(1), inNameFile);
                catch exception
                    disp(exception)
                    %error('An unexpected error has occured')
                end
            end
            %--------------------------------------------------------%
		end
    end
end

