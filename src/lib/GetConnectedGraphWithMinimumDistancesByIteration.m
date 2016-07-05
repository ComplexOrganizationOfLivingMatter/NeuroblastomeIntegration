function [ adjacencyMatrix ] = GetConnectedGraphWithMinimumDistancesByIteration( distanceBetweenClusters, adjacencyMatrix, C, inNameFile)
%GETCONNECTEDGRAPHWITHMINIMUMDISTANCES Summary of this function goes here
%   Detailed explanation goes here
%
%   Developed by Pablo Vicente-Munuera

    if graphconncomp(adjacencyMatrix, 'Directed', 'false') == 1
        outputFileName = strcat('Adjacency\minimumDistanceClasses', inNameFile(1), 'It1.mat')
        outputFileNameSif = strcat('visualize\minimumDistanceClasses', inNameFile(1), 'It1.cvs');
        save(outputFileName{:}, 'adjacencyMatrix', '-v7.3');
        generateSIFFromAdjacencyMatrix(adjacencyMatrix, outputFileNameSif{:});
		return
    end

    mDistanceBetweenClusters = squareform(distanceBetweenClusters);
    mDistanceBetweenClusters(logical(eye(size(mDistanceBetweenClusters)))) = intmax('int32');

    i = 1;
    iteration = 1;
    while connectedComps > 1
        if i > size(adjacencyMatrix,1)
            outputFileName = strcat('Adjacency\minimumDistanceClasses', inNameFile(1), 'It', num2str(iteration) ,'.mat')
            outputFileNameSif = strcat('visualize\minimumDistanceClasses', inNameFile(1), 'It', num2str(iteration) ,'.cvs');
            save(outputFileName{:}, 'adjacencyMatrix', '-v7.3');
            generateSIFFromAdjacencyMatrix(adjacencyMatrix, outputFileNameSif{:});
            
			if 1 == graphconncomp(adjacencyMatrix, 'Directed', 'false')
				return
			end
            i=1;
            iteration = iteration + 1;
        end
        minimumDistance = min(mDistanceBetweenClusters(:));
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
        
        
        mDistanceBetweenClusters(rowMin, colMin) = intmax('int32');
        mDistanceBetweenClusters(colMin, rowMin) = intmax('int32');
		
        i = i + 1;
    end
end

