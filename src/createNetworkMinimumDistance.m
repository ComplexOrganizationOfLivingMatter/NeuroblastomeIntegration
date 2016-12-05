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

    lee_imagenes = getAllFiles(currentPath);
    for imK = 1:size(lee_imagenes,1)
        fullPathImage = lee_imagenes(imK);
        fullPathImage = fullPathImage{:};
        fullPathImageSplitted = strsplit(fullPathImage, '\');
        imageName = fullPathImageSplitted(end);
        imageName = imageName{1};
        %Path name
        basePath = strjoin(fullPathImageSplitted(1:6), '\');
        %If it's a directory and positive image (marker positive). Also we exclude the files of col, ret, CD31 and GAG
        if isempty(strfind(lower(lee_imagenes{imK}), lower(markerWeWant))) == 0
            fullPathImage = lee_imagenes{imK};
            fullPathImageSplitted = strsplit(fullPathImage, '\');
            imageName = fullPathImageSplitted(end);
            imageName = imageName{1};
            %Path name
            basePath = strjoin(fullPathImageSplitted(1:6), '\');
            Img=imread(fullPathImage);
			
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
            inNameFile = strsplit(strrep(imageName,' ','_'), '.');
            outputFileName = strcat(basePath, '\Networks\DistanceMatrix\minimumDistanceClasses', inNameFile(1), 'DistanceMatrix.mat');
            if exist(outputFileName{:}, 'file') ~= 2
                save(outputFileName{:}, 'distanceBetweenObjects');
            end

            
            createNetworksWithControls(fullPathImage, Img, distanceBetweenObjects, basePath, 0, inNameFile, imageName);
            
%             radiusOfCircle = min(size(Img))/2;
%             maskImage = generateCircularRoiFromImage(fullPathImage, radiusOfCircle );
%             
%             inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
%             outputFileName = strcat('Adjacency\minimumDistanceClassesBetweenPairs', inNameFile(1), 'It1.mat');
% 			if exist(outputFileName{:}, 'file') ~= 2
%                 %minimumDistance algorithm that outputs an adjacencyMatrix which is connected (i.e. only one connected component).
%                 try
%                     adjacencyMatrix = GetConnectedGraphWithMinimumDistancesBetweenPairsByIteration(distanceBetweenObjects , sparse(size(S,1), size(S,1)), zeros(1), inNameFile);
%                 catch exception
%                     disp(exception)
%                     %error('An unexpected error has occured')
%                 end
%             end
%             
%             
%             
%             %--------------------------------------------------------%
		end
    end
end

