function [ ] = getMinimumDistancesFromHexagonalGrid(PathCurrent, markerName)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%
%   Developed by Pablo Vicente-Munuera
    lee_imagenes = getAllFiles(PathCurrent);
    for imK = 1:size(lee_imagenes,1)
        fullPathImage = lee_imagenes(imK);
        fullPathImage = fullPathImage{:};
        fullPathImageSplitted = strsplit(fullPathImage, '\');
        imageName = fullPathImageSplitted(end);
        imageName = imageName{1};
        if size(strfind(lower(imageName), markerName),1) == 1
            imageName;
            Img=imread(fullPathImage);
            Img = Img(:, :, 1);
            Img = im2bw(Img, 0.2);
            for numMask = [50] %100
                inNameFile = strsplit(strrep(imageName,' ','_'), '.');
                outputFileName = strcat(strjoin(fullPathImageSplitted(1:5), '\'), '\Networks\DistanceMatrix\minimumDistanceClasses', inNameFile(1), 'ContigousHexagonalMeanAreaMask', num2str(numMask),'DiametDistanceMatrix.mat')
                distanceMatrix = '';
                if exist(outputFileName{:}, 'file') ~= 2
                    maskName = strcat('..\Mascaras\HexagonalMask', num2str(numMask), 'Diamet.mat');
                    mask = importdata(maskName);
                    mask = mask(1:size(Img, 1), 1:size(Img,2));

                    distanceMatrix = getDistanceMatrixFromHexagonalGrid(Img, mask);
                    distanceBetweenObjects = distanceMatrix;
                    
                    save(outputFileName{:}, 'distanceBetweenObjects');
                else
                    distanceMatrix = importdata(outputFileName{:});
                end
                
                radiusOfCircle = min(size(Img))/2;
                maskImage = generateCircularRoiFromImage(fullPathImage, radiusOfCircle );
                
                for numControl = 1:10
                    outputControlFile = strcat(strjoin(fullPathImageSplitted(1:5), '\'), '\Networks\ControlNetwork\', inNameFile(1), num2str(numMask),'DiametControl', num2str(numControl), '.mat');
                    if exist(outputControlFile{:}, 'file') ~= 2
                        outputControl = strcat(strjoin(fullPathImageSplitted(1:5), '\'), '\Networks\ControlNetwork\', inNameFile(1), num2str(numMask),'DiametControl', num2str(numControl));
                        generateVoronoiInsideCircle(10, size(distanceMatrix, 1), radiusOfCircle, maskImage(1:radiusOfCircle*2, 1:radiusOfCircle*2), outputControl);
                    end
                    clear Img

                    outputControlFileDistance = strcat(strjoin(fullPathImageSplitted(1:5), '\'), '\Networks\ControlNetwork\', inNameFile(1), num2str(numMask),'DiametControl', num2str(numControl), 'DistanceMatrix.mat');
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
                        minDistNameFile = [strcat('Control', num2str(numControl), '_', minDistNameFile(1),'_Radius' , num2str(numMask))];
                        outputFileName = strcat(strjoin(fullPathImageSplitted(1:5), '\'), '\Networks\IterationAlgorithm\minimumDistanceClassesBetweenPairs', minDistNameFile(1), 'It1.mat');
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
                        minDistNameFile = [strcat(minDistNameFile(1),'_Radius' , num2str(numMask))];
                        outputFileName = strcat(strjoin(fullPathImageSplitted(1:5), '\'), '\Networks\IterationAlgorithm\minimumDistanceClassesBetweenPairs', minDistNameFile(1), 'It1.mat')
                        if exist(outputFileName{:}, 'file') ~= 2
                            %minimumDistance algorithm that outputs an adjacencyMatrix which is connected (i.e. only one connected component).
                            GetConnectedGraphWithMinimumDistancesBetweenPairsByIteration(distanceMatrix , sparse(size(distanceMatrix,1), size(distanceMatrix,1)), zeros(1), outputFileName);
                        end
                        %--------------------------------------------------------%
                    end
                end
            end
        end
    end
end

