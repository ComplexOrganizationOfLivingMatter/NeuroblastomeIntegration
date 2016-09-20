function [ ] = getMinimumDistancesFromHexagonalGrid( )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    [stat,struc] = fileattrib;
    PathCurrent = struc.Name;
    lee_imagenes = dir(PathCurrent);
    lee_imagenes = lee_imagenes(3:size(lee_imagenes,1)-1)
    for imK = 1:size(lee_imagenes,1)
        if (lee_imagenes(imK).isdir == 0 && (size(strfind(lee_imagenes(imK).name, 'COL'),1) == 1 || size(strfind(lee_imagenes(imK).name, 'CD31'),1) == 1 || size(strfind(lee_imagenes(imK).name, 'RET'),1) == 1 || size(strfind(lee_imagenes(imK).name, 'GAG'),1) == 1))
            lee_imagenes(imK).name
            Img=imread(lee_imagenes(imK).name);
            Img = Img(:, :, 1);
            Img = im2bw(Img, 0.2);
            for numMask = [50] %5, 10, 15 remaining
                inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
                outputFileName = strcat('adjacency\adjacencyMatrix', inNameFile(1), 'ContigousHexagonalMeanAreaMask', num2str(numMask),'DiametDistanceMatrix.mat')
                distanceMatrix = '';
                if exist(outputFileName{:}, 'file') ~= 2
                    maskName = strcat('..\..\..\..\..\Mascaras\HexagonalMask', num2str(numMask), 'Diamet.mat');
                    mask = importdata(maskName);
                    mask = mask(1:size(Img, 1), 1:size(Img,2));

                    distanceMatrix = getDistanceMatrixFromHexagonalGrid(Img, mask);
                    distanceBetweenObjects = distanceMatrix;
                    
                    save(outputFileName{:}, 'distanceBetweenObjects');
                else
                    distanceMatrix = importdata(outputFileName{:});
                end
                clear Img
                if size(distanceMatrix, 1) > 0
                %--------------------- adjacencyMatrix_minimumDistanceBetweenPairsIt ------------------%
                    %Get output file names
                    inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
                    inNameFile = [strcat(inNameFile(1),'_Radius' , num2str(numMask))];
                    outputFileName = strcat('Adjacency\minimumDistanceClassesBetweenPairs', inNameFile(1), 'It1.mat')
                    if exist(outputFileName{:}, 'file') ~= 2
                        %minimumDistance algorithm that outputs an adjacencyMatrix which is connected (i.e. only one connected component).
                        GetConnectedGraphWithMinimumDistancesBetweenPairsByIteration(distanceMatrix , sparse(size(distanceMatrix,1), size(distanceMatrix,1)), zeros(1), inNameFile);
                    end
                    %--------------------------------------------------------%

                    %--------------------- adjacencyMatrix_minimumDistanceIt ------------------%
                    %Get output file names
%                     inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
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

