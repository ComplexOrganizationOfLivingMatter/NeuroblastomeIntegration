function [ adjacencyMatrixWeights ] = GetConnectedGraphWithMinimumDistancesByIteration( distanceBetweenClusters, adjacencyMatrixWeights, C, inNameFile)
%GETCONNECTEDGRAPHWITHMINIMUMDISTANCES Summary of this function goes here
%   Detailed explanation goes here
%
%   Developed by Pablo Vicente-Munuera
    adjacencyMatrix = adjacencyMatrixWeights;
    if graphconncomp(adjacencyMatrixWeights, 'Directed', 'false') == 1
        outputFileName = strcat('Adjacency\minimumDistanceClasses', inNameFile(1), 'It1.mat')
        outputFileNameSif = strcat('visualize\minimumDistanceClasses', inNameFile(1), 'It1.cvs');
        save(outputFileName{:}, 'adjacencyMatrixWeights', '-v7.3');
        generateSIFFromAdjacencyMatrix(adjacencyMatrixWeights, outputFileNameSif{:});
		return
    end

    if size(distanceBetweenClusters, 1) ~= size(distanceBetweenClusters, 2)
        mDistanceBetweenClusters = squareform(distanceBetweenClusters);
    else
        mDistanceBetweenClusters = distanceBetweenClusters;
    end
    mDistanceBetweenClusters(logical(eye(size(mDistanceBetweenClusters)))) = NaN;

    iteration = 1;
    while 1
        if min(sum(adjacencyMatrix(:,:))) >= iteration
            outputFileName = strcat('Adjacency\minimumDistanceClasses', inNameFile(1), 'It', num2str(iteration) ,'.mat')
            outputFileNameSif = strcat('visualize\minimumDistanceClasses', inNameFile(1), 'It', num2str(iteration) ,'.cvs');
            save(outputFileName{:}, 'adjacencyMatrix', '-v7.3');
            generateSIFFromAdjacencyMatrix(adjacencyMatrixWeights, outputFileNameSif{:});
            
			if 1 == graphconncomp(adjacencyMatrixWeights, 'Directed', 'false')
				return
            end
            iteration = iteration + 1; 
        end
        minimumDistance = min(mDistanceBetweenClusters(:));
        [rowMin, colMin] = find(mDistanceBetweenClusters == minimumDistance, 1);
        if size(C,2) > 1
           class1 = find(C == rowMin, 1);
            class2 = find(C == colMin, 1);
            adjacencyMatrixWeights(class1, class2) = mDistanceBetweenClusters(rowMin, colMin);
            adjacencyMatrixWeights(class2, class1) = mDistanceBetweenClusters(rowMin, colMin);
            adjacencyMatrix(class1, class2) = adjacencyMatrix(class1, class2) + 1;
            adjacencyMatrix(class2, class1) = adjacencyMatrix(class2, class1) + 1;
            
        else
            adjacencyMatrixWeights(rowMin, colMin) = mDistanceBetweenClusters(rowMin, colMin);
            adjacencyMatrixWeights(colMin, rowMin) = mDistanceBetweenClusters(rowMin, colMin);
            adjacencyMatrix(rowMin, colMin) = adjacencyMatrix(rowMin, colMin) + 1;
            adjacencyMatrix(colMin, rowMin) = adjacencyMatrix(colMin, rowMin) + 1;
        end
        
        
        mDistanceBetweenClusters(rowMin, colMin) = NaN;
        mDistanceBetweenClusters(colMin, rowMin) = NaN;
    end
end

