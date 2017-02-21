function [ ] = createMinimumSpanningTreeFromNetworks( currentPath, markerWeWant )
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

    allFiles = getAllFiles(currentPath);
    for imK = 1:size(allFiles,1)
        fullPathFileName = allFiles(imK);
        fullPathFileName = fullPathFileName{:};
        fullPathFileNameSplitted = strsplit(fullPathFileName, '\');
        fileName = fullPathFileNameSplitted(end);
        fileName = fileName{1};
        %Path name
        basePath = strjoin(fullPathFileNameSplitted(1:6), '\');
        %If it's a directory and positive image (marker positive). Also we exclude the files of col, ret, CD31 and GAG
        if isempty(strfind(lower(fullPathFileName), lower(markerWeWant))) == 0 && isempty(strfind(lower(fullPathFileName), lower('CELS'))) == 1
            nameFileNoExtension = strsplit(strrep(fileName(1:end-18),' ','_'), '.');
            outputFileName = strcat(basePath, '\Networks\MinimumSpanningTree\mst_', nameFileNoExtension{1}, '.mat');
            if exist(outputFileName, 'file') ~= 2 && isempty(strfind(fileName, 'DistanceMatrix')) == 0
                fileName
                if exist(strrep(fullPathFileName, '.mat', '.csv'), 'file') ~= 2
                    load(fullPathFileName);
                else
                    distanceBetweenObjects = dlmread(strrep(fullPathFileName{:}, '.mat', '.csv'), ' ');
                end
                
                if exist('distanceBetweenObjects', 'var') == 1
                    distanceMatrix = distanceBetweenObjects;
                elseif exist('distanceBetweenClusters', 'var') == 1
                    distanceMatrix = distanceBetweenClusters;
                end
                
                if exist('distanceMatrix', 'var') == 1
                    if length(distanceMatrix) > 15
                        adjacencyMatrix = graphminspantree(sparse(distanceMatrix));
                        save(outputFileName, 'adjacencyMatrix', '-v7.3');
                    end
%                 else
%                     distanceMatrix = distanceMatrixControl;
%                     
                end
            end
        end
    end
    
end