function [ ] = getMinimumDistancesFromHexagonalGrid( )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    [stat,struc] = fileattrib;
    PathCurrent = struc.Name;
    lee_imagenes = getAllFiles(PathCurrent);
    for imK = 1:size(lee_imagenes,1)
        fullPathImage = lee_imagenes(imK);
        fullPathImage = fullPathImage{:};
        imageName = strsplit(fullPathImage, '\');
        imageName = imageName(10);
        imageName = imageName{1};
        if size(strfind(lower(imageName), 'ret_mask'),1) == 1
            imageName
            Img=imread(fullPathImage);
            Img = Img(:, :, 1);
            Img = im2bw(Img, 0.2);
            for numMask = [50] %5, 10, 15 remaining
                inNameFile = strsplit(strrep(imageName,' ','_'), '.');
                outputFileName = strcat('E:\Pablo\Neuroblastoma\Datos\Data\NuevosCasos160\Casos\Networks\DistanceMatrix\minimumDistanceClasses', inNameFile(1), 'ContigousHexagonalMeanAreaMask', num2str(numMask),'DiametDistanceMatrix.mat')
                distanceMatrix = '';
                if exist(outputFileName{:}, 'file') ~= 2
                    maskName = strcat('E:\Pablo\Neuroblastoma\Mascaras\HexagonalMask', num2str(numMask), 'Diamet.mat');
                    mask = importdata(maskName);
                    mask = mask(1:size(Img, 1), 1:size(Img,2));

                    distanceMatrix = getDistanceMatrixFromHexagonalGrid(Img, mask);
                    distanceBetweenObjects = distanceMatrix;
                    
                    save(outputFileName{:}, 'distanceBetweenObjects');
                else
                    distanceMatrix = importdata(outputFileName{:});
                end
                
                outputFileName = strcat('E:\Pablo\Neuroblastoma\Datos\Data\NuevosCasos160\Casos\Networks\DistanceMatrix\minimumDistanceClasses', inNameFile(1), 'ContigousHexagonalMeanAreaMask', num2str(numMask),'DiametDistanceMatrix.mat')
                
                radiusOfCircle = min(size(Img))/2;
                figure
                roiImage = imread(fullPathImage);
                imshow(roiImage);
                h = imellipse(gca, [0 0 radiusOfCircle*2 radiusOfCircle*2]);
                api = iptgetapi(h);

                fcn = getPositionConstraintFcn(h);

                api.setPositionConstraintFcn(fcn);

                maskImage = createMask(h);
                close all
                
                outputControlFile = strcat('E:\Pablo\Neuroblastoma\Datos\Data\NuevosCasos160\Casos\Networks\ControlNetwork\', inNameFile(1), num2str(numMask),'DiametControl.mat');
                if exist(outputControlFile{:}, 'file') ~= 2
                    outputControl = strcat('E:\Pablo\Neuroblastoma\Datos\Data\NuevosCasos160\Casos\Networks\ControlNetwork\', inNameFile(1), num2str(numMask),'DiametControl');
                    generateVoronoiInsideCircle(10, size(distanceMatrix, 1), radiusOfCircle, maskImage(1:radiusOfCircle*2, 1:radiusOfCircle*2), outputControl);
                end
                clear Img
                
                outputControlFileDistance = strcat('E:\Pablo\Neuroblastoma\Datos\Data\NuevosCasos160\Casos\Networks\ControlNetwork\', inNameFile(1), num2str(numMask),'DiametControlDistanceMatrix.mat');
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
                    inNameFile = strsplit(strrep(imageName,' ','_'), '.');
                    inNameFile = [strcat('Control', inNameFile(1),'_Radius' , num2str(numMask))];
                    outputFileName = strcat('E:\Pablo\Neuroblastoma\Datos\Data\NuevosCasos160\Casos\Networks\IterationAlgorithm\minimumDistanceClassesBetweenPairs', inNameFile(1), 'It1.mat')
                    if exist(outputFileName{:}, 'file') ~= 2
                        %minimumDistance algorithm that outputs an adjacencyMatrix which is connected (i.e. only one connected component).
                        GetConnectedGraphWithMinimumDistancesBetweenPairsByIteration(distanceMatrixControl , sparse(size(distanceMatrixControl, 1), size(distanceMatrixControl, 1)), zeros(1), inNameFile);
                    end
                    %--------------------------------------------------------%
                end
                
                if size(distanceMatrix, 1) > 0
                %--------------------- adjacencyMatrix_minimumDistanceBetweenPairsIt ------------------%
                    %Get output file names
                    inNameFile = strsplit(strrep(imageName,' ','_'), '.');
                    inNameFile = [strcat(inNameFile(1),'_Radius' , num2str(numMask))];
                    outputFileName = strcat('E:\Pablo\Neuroblastoma\Datos\Data\NuevosCasos160\Casos\Networks\IterationAlgorithm\minimumDistanceClassesBetweenPairs', inNameFile(1), 'It1.mat')
                    if exist(outputFileName{:}, 'file') ~= 2
                        %minimumDistance algorithm that outputs an adjacencyMatrix which is connected (i.e. only one connected component).
                        GetConnectedGraphWithMinimumDistancesBetweenPairsByIteration(distanceMatrix , sparse(size(distanceMatrix,1), size(distanceMatrix,1)), zeros(1), inNameFile);
                    end
                    %--------------------------------------------------------%

                    %--------------------- adjacencyMatrix_minimumDistanceIt ------------------%
                    %Get output file names
%                     inNameFile = strsplit(strrep(imageName.name,' ','_'), '.');
%                     inNameFile = [strcat(inNameFile(1),'_Radius' , num2str(numMask))];
%                     outputFileName = strcat('Adjacency\minimumDistanceClasses', inNameFile(1), 'It1.mat')
%                     if exist(outputFileName{:}, 'file') ~= 2
%                         %minimumDistance algorithm that outputs an adjacencyMatrix which is connected (i.e. only one connected component).
%                         GetConnectedGraphWithMinimumDistancesByIteration(distanceMatrix , sparse(size(distanceMatrix,1), size(distanceMatrix,1)), zeros(1), inNameFile);
%                     end
                    %--------------------------------------------------------%
                end
            end
        end
    end
end

