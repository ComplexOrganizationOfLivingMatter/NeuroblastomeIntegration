function [ adjacencyMatrix ] = GetCompleteGraphWithMinimumDistances( distanceBetweenClusters, adjacencyMatrix, C)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    mDistanceBetweenClusters = squareform(distanceBetweenClusters);
    mDistanceBetweenClusters(logical(eye(size(mDistanceBetweenClusters)))) = intmax('int32');

    for i = 1:size(mDistanceBetweenClusters,1)
		for j = 1:size(mDistanceBetweenClusters,2)
			rowMin = i;
            colMin = j;
			if size(C,1) > 1
			   class1 = find(C == rowMin, 1);
			   class2 = find(C == colMin, 1);
			   adjacencyMatrix(class1, class2) = mDistanceBetweenClusters(rowMin, colMin);
			   adjacencyMatrix(class2, class1) = mDistanceBetweenClusters(rowMin, colMin);
			else
				adjacencyMatrix(rowMin, colMin) = mDistanceBetweenClusters(rowMin, colMin);
				adjacencyMatrix(colMin, rowMin) = mDistanceBetweenClusters(rowMin, colMin);
			end
		end
    end
end

