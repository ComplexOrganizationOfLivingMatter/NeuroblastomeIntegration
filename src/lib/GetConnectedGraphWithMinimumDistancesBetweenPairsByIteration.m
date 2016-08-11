function [ adjacencyMatrix ] = GetConnectedGraphWithMinimumDistancesBetweenPairsByIteration( distanceBetweenClusters, adjacencyMatrix, C, inNameFile)
%GETCONNECTEDGRAPHWITHMINIMUMDISTANCEBETWEENPAIRS Summary of this function goes here
%   Detailed explanation goes here
%
%   Developed by Pablo Vicente-Munuera

	connectedComps = graphconncomp(adjacencyMatrix, 'Directed', 'false');
    if connectedComps == 1
        outputFileName = strcat('Adjacency\minimumDistanceClassesBetweenPairs', inNameFile(1), 'It1.mat')
        outputFileNameSif = strcat('visualize\minimumDistanceClassesBetweenPairs', inNameFile(1), 'It1.cvs');
        save(outputFileName{:}, 'adjacencyMatrix', '-v7.3');
        %exporting to siff
        generateSIFFromAdjacencyMatrix(adjacencyMatrix, outputFileNameSif{:});
		return
    end
	
    if size(distanceBetweenClusters, 1) ~= size(distanceBetweenClusters, 2)
        mDistanceBetweenClusters = squareform(distanceBetweenClusters);
    else
        mDistanceBetweenClusters = distanceBetweenClusters;
    end
    mDistanceBetweenClusters(logical(eye(size(mDistanceBetweenClusters)))) = NaN;

	i = 1;
    iteration = 1;
    while 1
        if i > size(adjacencyMatrix,1)
            outputFileName = strcat('Adjacency\minimumDistanceClassesBetweenPairs', inNameFile(1), 'It', num2str(iteration) ,'.mat')
            outputFileNameSif = strcat('visualize\minimumDistanceClassesBetweenPairs', inNameFile(1), 'It', num2str(iteration) ,'.cvs');
            save(outputFileName{:}, 'adjacencyMatrix', '-v7.3');
            generateSIFFromAdjacencyMatrix(adjacencyMatrix, outputFileNameSif{:});
            
            if 1 == graphconncomp(adjacencyMatrix, 'Directed', 'false')
				return
			end
            i=1;
            iteration = iteration + 1;
        end
        minimumDistance = min(mDistanceBetweenClusters(i,:));
        [rowMin, colMin] = find(mDistanceBetweenClusters == minimumDistance, 1);
        if size(C,2) > 1
           class1 = find(C == rowMin, 1);
            class2 = find(C == colMin, 1);
            adjacencyMatrix(class1, class2) = mDistanceBetweenClusters(rowMin, colMin);
            adjacencyMatrix(class2, class1) = mDistanceBetweenClusters(rowMin, colMin);
        else
            adjacencyMatrix(rowMin, colMin) = mDistanceBetweenClusters(rowMin, colMin);
            adjacencyMatrix(colMin, rowMin) = mDistanceBetweenClusters(rowMin, colMin);
        end
        
        
        mDistanceBetweenClusters(rowMin, colMin) = NaN;
        mDistanceBetweenClusters(colMin, rowMin) = NaN;
        
        i = i + 1;
    end
end

