function [ adjacencyMatrix ] = GetConnectedGraphWithMinimumDistancesBetweenPairsByIteration( distanceBetweenClusters, adjacencyMatrix, C, outputFileName)
%GETCONNECTEDGRAPHWITHMINIMUMDISTANCEBETWEENPAIRS Summary of this function goes here
%   Detailed explanation goes here
%
%   Developed by Pablo Vicente-Munuera

	connectedComps = graphconncomp(adjacencyMatrix, 'Directed', 'false');
    if connectedComps == 1
        save(outputFileName{:}, 'adjacencyMatrix', '-v7.3');
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
            outputFileIter = strsplit(outputFileName{:}, 'It');
            outputFileIter = strcat(strjoin(outputFileIter(1:end-1), 'It'), 'It', num2str(iteration), '.mat');
            save(outputFileIter, 'adjacencyMatrix', '-v7.3');
            
            if 1 == graphconncomp(adjacencyMatrix, 'Directed', 'false') || isempty(strfind(outputFileName{:}, 'Control')) == 0
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

