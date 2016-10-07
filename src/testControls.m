function [ ] = testControls( )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    inNameFile = '07B00317B_Y07A_RET_Mask';
    
    Img=imread('E:\Pablo\Neuroblastoma\Datos\Data\NuevosCasos160\Casos\Images\07B00317_B_Y07A\07B00317B_Y07A_RET_Mask.tif');
    Img = Img(:, :, 1);
    Img = im2bw(Img, 0.2);

    radiusOfCircle = min(size(Img))/2;
    figure
    roiImage = imread('E:\Pablo\Neuroblastoma\Datos\Data\NuevosCasos160\Casos\Images\07B00317_B_Y07A\07B00317B_Y07A_RET_Mask.tif');
    imshow(roiImage);
    h = imellipse(gca, [0 0 radiusOfCircle*2 radiusOfCircle*2]);
    api = iptgetapi(h);

    fcn = getPositionConstraintFcn(h);

    api.setPositionConstraintFcn(fcn);

    maskImage = createMask(h);
    close all


    for i = 1:10
        outputControl = strcat('E:\Pablo\Neuroblastoma\NeuroblastomeIntegration\TempResults\Test07B00317B_Y07A_RET', num2str(i), 'Control');
        generateVoronoiInsideCircle(10, 2231, radiusOfCircle, maskImage(1:radiusOfCircle*2, 1:radiusOfCircle*2), {outputControl});
        outputControlFileDistance = strcat('E:\Pablo\Neuroblastoma\NeuroblastomeIntegration\TempResults\Test', inNameFile, num2str(i),'DiametControlDistanceMatrix.mat');
        load(outputControl);
        distanceMatrixControl = pdist(initCentroids, 'euclidean');
        distanceMatrixControl = squareform(distanceMatrixControl);
        save(outputControlFileDistance{:}, 'distanceMatrixControl');
        outputControlFileDistance = strcat('E:\Pablo\Neuroblastoma\NeuroblastomeIntegration\TempResults\Test', inNameFile, num2str(i),'DiametControlDistanceMatrix.mat');
        load(outputControlFileDistance{:});
        if size(distanceMatrixControl, 1) > 0
            %--------------------- adjacencyMatrix_minimumDistanceBetweenPairsIt ------------------%
            %Get output file names
            inNameFile = strsplit(strrep(imageName,' ','_'), '.');
            inNameFile = [strcat('Test', num2str(i), 'Control', inNameFile,'_Radius' , num2str(numMask))];
            outputFileName = strcat('E:\Pablo\Neuroblastoma\Datos\Data\NuevosCasos160\Casos\Networks\IterationAlgorithm\minimumDistanceClassesBetweenPairs', inNameFile, 'It1.mat')
            if exist(outputFileName{:}, 'file') ~= 2
                %minimumDistance algorithm that outputs an adjacencyMatrix which is connected (i.e. only one connected component).
                GetConnectedGraphWithMinimumDistancesBetweenPairsByIteration(distanceMatrixControl , sparse(size(distanceMatrixControl, 1), size(distanceMatrixControl, 1)), zeros(1), inNameFile);
            end
            %--------------------------------------------------------%
        end
    end

end

