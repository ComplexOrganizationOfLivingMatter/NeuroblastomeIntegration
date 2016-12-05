function [ ] = createNetworksWithControls(fullPathImage, Img, distanceMatrix, basePath, numMask, inNameFile, imageName)
%CREATENETWORKSWITHCONTROLS Summary of this function goes here
%   Detailed explanation goes here
    radiusOfCircle = min(size(Img))/2;
    maskImage = generateCircularRoiFromImage(fullPathImage, radiusOfCircle );

    for numControl = 1:10
        if numMask > 0
            maskName = strcat(inNameFile(1), num2str(numMask), 'Diamet');
        else
            maskName = inNameFile(1);
        end

        outputControlFile = strcat(basePath, '\Networks\ControlNetwork\', maskName , 'Control', num2str(numControl), '.mat');
        if exist(outputControlFile{:}, 'file') ~= 2
            outputControl = strcat(basePath, '\Networks\ControlNetwork\', maskName, 'Control', num2str(numControl));
            generateVoronoiInsideCircle(10, size(distanceMatrix, 1), radiusOfCircle, maskImage(1:radiusOfCircle*2, 1:radiusOfCircle*2), outputControl);
        end
        clear Img

        outputControlFileDistance = strcat(basePath, '\Networks\ControlNetwork\', maskName ,'Control', num2str(numControl), 'DistanceMatrix.mat');
        if exist(outputControlFileDistance{:}, 'file') ~= 2
            load(outputControlFile{:});
            distanceMatrixControl = pdist(initCentroids, 'euclidean');
            distanceMatrixControl = squareform(distanceMatrixControl);
            save(outputControlFileDistance{:}, 'distanceMatrixControl');
        end

        load(outputControlFileDistance{:});
        if size(distanceMatrixControl, 1) > 0
            %--------------------- adjacencyMatrix_minimumDistanceBetweenPairsIt ------------------%
            %Get output file names
            minDistNameFile = strsplit(strrep(imageName,' ','_'), '.');
            if numMask > 0
                minDistNameFile = [strcat('Control', num2str(numControl), '_', minDistNameFile(1),'_Radius' , num2str(numMask))];
            else
                minDistNameFile = [strcat('Control', num2str(numControl), '_', minDistNameFile(1))];
            end
            outputFileName = strcat(basePath, '\Networks\IterationAlgorithm\minimumDistanceClassesBetweenPairs', minDistNameFile(1), 'It1.mat');
            if exist(outputFileName{:}, 'file') ~= 2
                %minimumDistance algorithm that outputs an adjacencyMatrix which is connected (i.e. only one connected component).
                GetConnectedGraphWithMinimumDistancesBetweenPairsByIteration(distanceMatrixControl , sparse(size(distanceMatrixControl, 1), size(distanceMatrixControl, 1)), zeros(1), outputFileName);
            end
            %--------------------------------------------------------%
        end

        if size(distanceMatrix, 1) > 0 && numControl == 1
            %--------------------- adjacencyMatrix_minimumDistanceBetweenPairsIt ------------------%
            %Get output file names
            minDistNameFile = strsplit(strrep(imageName,' ','_'), '.');
            if numMask > 0
                minDistNameFile = [strcat(minDistNameFile(1),'_Radius' , num2str(numMask))];
            end
            outputFileName = strcat(basePath, '\Networks\IterationAlgorithm\minimumDistanceClassesBetweenPairs', minDistNameFile(1), 'It1.mat');
            if exist(outputFileName{:}, 'file') ~= 2
                %minimumDistance algorithm that outputs an adjacencyMatrix which is connected (i.e. only one connected component).
                GetConnectedGraphWithMinimumDistancesBetweenPairsByIteration(distanceMatrix , sparse(size(distanceMatrix,1), size(distanceMatrix,1)), zeros(1), outputFileName);
            end
            %--------------------------------------------------------%
        end
    end
end

