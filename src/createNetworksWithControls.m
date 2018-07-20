function [ ] = createNetworksWithControls(fullPathImage, Img, distanceMatrix, basePath, numMask, inNameFile, markerName)
%CREATENETWORKSWITHCONTROLS Summary of this function goes here
%   Detailed explanation goes here
    
    %Create the control mask
    if numMask > 0
        maskName = strcat(inNameFile(1), num2str(numMask), 'Diamet');
    else
        maskName = inNameFile(1);
    end
    outputControlFile = strcat(basePath, '\Networks\ControlNetwork\', maskName , 'Control', num2str(10), '.mat');
    if exist(outputControlFile{:}, 'file') ~= 2
        fullPathSplitted = strsplit(fullPathImage, '\');
        filesOriginal = struct2cell(dir(strjoin(fullPathSplitted(1:end-1), '\')))';
        filesOriginal = filesOriginal(vertcat(filesOriginal{:, 4}) == 0, :);
        
        caseName = strsplit(lower(fullPathSplitted{end}), lower(markerName));
        
        originalImage = cellfun(@(x) isempty(strfind(lower(x), lower(caseName{1}))) == 0 & isempty(strfind(lower(x), 'mask')) & isempty(strfind(lower(x), 'txt')) & isempty(strfind(lower(x), 'cels')), filesOriginal(:, 1));
        if sum(originalImage) > 0
            nameOriginalImage = {filesOriginal{originalImage}};
            if sum(originalImage) > 1
                nameOriginalVTN = cellfun(@(x) isempty(strfind(lower(x), 'def')) == 0 | isempty(strfind(lower(x), 'snap')) == 0, nameOriginalImage);
                if sum(nameOriginalVTN) > 1
                    error('Error: more than 1 original image found');
                else
                    nameOriginalImage = nameOriginalImage(nameOriginalVTN);
                end
            end 
            [maskImage, radiusOfEllipse] = removingArtificatsFromImage(imread(strcat(strjoin(fullPathSplitted(1:end-1), '\'), '\', nameOriginalImage{1})), fullPathSplitted{6});
        else
            radiusOfEllipse = [0 0 size(Img)/2];
            maskImage = generateCircularRoiFromImage(fullPathImage, size(Img)/2);
        end
        for numControl = 1:10
            outputControlFile = strcat(basePath, '\Networks\ControlNetwork\', maskName , 'Control', num2str(numControl), '.mat');
            if exist(outputControlFile{:}, 'file') ~= 2
                outputControl = strcat(basePath, '\Networks\ControlNetwork\', maskName, 'Control', num2str(numControl));
                generateVoronoiInsideCircle(10, size(distanceMatrix, 1), radiusOfEllipse, maskImage, outputControl);
            end
            clear Img

            outputControlFileDistance = strcat(basePath, '\Networks\ControlNetwork\', maskName ,'Control', num2str(numControl), 'DistanceMatrix.mat');
            if exist(outputControlFileDistance{:}, 'file') ~= 2
                load(outputControlFile{:});
                distanceMatrixControl = pdist(initCentroids, 'euclidean');
                distanceMatrixControl = squareform(distanceMatrixControl);
                save(outputControlFileDistance{:}, 'distanceMatrixControl');
                [~, msgid] = lastwarn;
                if isequal(msgid, 'MATLAB:save:sizeTooBigForMATFile')
                    dlmwrite(strrep(outputControlFileDistance{:}, '.mat', '.csv'), distanceMatrixControl, ' ');
                    lastwarn('')
                end
            end

            if exist(strrep(outputControlFileDistance{:}, '.mat', '.csv'), 'file') ~= 2
                load(outputControlFileDistance{:});
            else
                distanceMatrixControl = dlmread(strrep(outputControlFileDistance{:}, '.mat', '.csv'), ' ');
            end
            % if size(distanceMatrixControl, 1) > 0
            %     %--------------------- adjacencyMatrix_minimumDistanceBetweenPairsIt ------------------%
            %     %Get output file names
            %     minDistNameFile = strsplit(strrep(imageName,' ','_'), '.');
            %     if numMask > 0
            %         minDistNameFile = [strcat('Control', num2str(numControl), '_', minDistNameFile(1),'_Radius' , num2str(numMask))];
            %     else
            %         minDistNameFile = [strcat('Control', num2str(numControl), '_', minDistNameFile(1))];
            %     end
            %     outputFileName = strcat(basePath, '\Networks\IterationAlgorithm\minimumDistanceClassesBetweenPairs', minDistNameFile(1), 'It1.mat');
            %     if exist(outputFileName{:}, 'file') ~= 2
            %         %minimumDistance algorithm that outputs an adjacencyMatrix which is connected (i.e. only one connected component).
            %         GetConnectedGraphWithMinimumDistancesBetweenPairsByIteration(distanceMatrixControl , sparse(size(distanceMatrixControl, 1), size(distanceMatrixControl, 1)), zeros(1), outputFileName);
            %     end
            %     %--------------------------------------------------------%
            % end

            % if size(distanceMatrix, 1) > 0 && numControl == 1
            %     %--------------------- adjacencyMatrix_minimumDistanceBetweenPairsIt ------------------%
            %     %Get output file names
            %     minDistNameFile = strsplit(strrep(imageName,' ','_'), '.');
            %     if numMask > 0
            %         minDistNameFile = [strcat(minDistNameFile(1),'_Radius' , num2str(numMask))];
            %     end
            %     outputFileName = strcat(basePath, '\Networks\IterationAlgorithm\minimumDistanceClassesBetweenPairs', minDistNameFile(1), 'It1.mat');
            %     if exist(outputFileName{:}, 'file') ~= 2
            %         %minimumDistance algorithm that outputs an adjacencyMatrix which is connected (i.e. only one connected component).
            %         GetConnectedGraphWithMinimumDistancesBetweenPairsByIteration(distanceMatrix , sparse(size(distanceMatrix,1), size(distanceMatrix,1)), zeros(1), outputFileName);
            %     end
            %     %--------------------------------------------------------%
            % end
        end
    end
end

