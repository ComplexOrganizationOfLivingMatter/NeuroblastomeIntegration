function [ adjacencyMatrix ] = GetCompleteGraphWithMinimumDistanceBetweenPairs( distanceBetweenClusters, adjacencyMatrix, C)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    mDistanceBetweenClusters = squareform(distanceBetweenClusters);
    mDistanceBetweenClusters(logical(eye(size(mDistanceBetweenClusters)))) = intmax('int16');

	for i=1:size(adjacencyMatrix, 1)
        minimumDistance = min(mDistanceBetweenClusters(i,:));
        [rowMin, colMin] = find(mDistanceBetweenClusters == minimumDistance, 1);
        if size(C,1) > 1
           class1 = find(C == rowMin, 1);
            class2 = find(C == colMin, 1);
            adjacencyMatrix(class1, class2) = mDistanceBetweenClusters(rowMin, colMin);
            adjacencyMatrix(class2, class1) = mDistanceBetweenClusters(rowMin, colMin);
        else
            adjacencyMatrix(rowMin, colMin) = mDistanceBetweenClusters(rowMin, colMin);
            adjacencyMatrix(colMin, rowMin) = mDistanceBetweenClusters(rowMin, colMin);
        end
        
        
        mDistanceBetweenClusters(rowMin, colMin) = intmax('int16');
        mDistanceBetweenClusters(colMin, rowMin) = intmax('int16');
		
		if graphconncomp(adjacencyMatrix, 'Directed', 'false') == 1
			break
		end
    end
end

