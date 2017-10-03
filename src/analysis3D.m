function [ ] = analysis3D( imagesPath, possibleMarkers )
%ANALYSIS3D Summary of this function goes here
%   Detailed explanation goes here
%   How to run it:
%   analysis3D('D:\Pablo\Neuroblastoma\Datos\Data\NuevosCasos160\Casos', {'COLAGENO', 'VasosSanguineos', 'RET', 'GAGs', 'LymphaticVessels', 'Vitronectine'});


    outputFatherDir = '..\Results\3Danalysis\';
    allFiles = getAllFiles(imagesPath);
    onlyImagesFiles = cellfun(@(x) isempty(strfind(lower(x), lower('\Images\'))) == 0 & isempty(strfind(lower(x), lower('.txt'))), allFiles);
    onlyImagesFiles = allFiles(onlyImagesFiles);
    
    onlyImagesFilesNoMasks = cellfun(@(x) isempty(strfind(lower(x), 'mask')) & isempty(strfind(lower(x), 'neg')) & isempty(strfind(lower(x), 'original')) & isempty(strfind(lower(x), 'cel')), onlyImagesFiles);
    onlyImagesFilesNoMasks = onlyImagesFiles(onlyImagesFilesNoMasks);
    
    onlyImagesFilesMasks = cellfun(@(x) isempty(strfind(lower(x), 'mask')) == 0 & isempty(strfind(lower(x), 'neg')) & isempty(strfind(lower(x), 'original')) & isempty(strfind(lower(x), 'cel')), onlyImagesFiles);
    onlyImagesFilesMasks = onlyImagesFiles(onlyImagesFilesMasks);
    
    
    %Filtering by markers
    [ filterOfMarkers, ~, uniqueCases ] = relationMarker_Images( possibleMarkers, onlyImagesFilesNoMasks, {});
    [ filterOfMarkersMasks, ~ ] = relationMarker_Images( possibleMarkers, onlyImagesFilesMasks, {'hepa', 'macr'});
    
%     subWindowX = size(filterOfMarkers, 2);
%     subWindowY = 1;
    for numCase = 1:size(filterOfMarkers, 1)
        outputDirectory = strcat(outputFatherDir, num2str(uniqueCases(numCase)));
        mkdir(outputDirectory)
        for numImage = 1:size(filterOfMarkers, 2)
            if filterOfMarkers(numCase, numImage) ~= 0
                imagesByCase(numImage) = onlyImagesFilesNoMasks(filterOfMarkers(numCase, numImage));
            else
                imagesByCase(numImage) = {''};
            end
        end
        
        filePath = strcat(outputFatherDir, num2str(uniqueCases(numCase)));
        filesInDir = dir(filePath);
        filesInDir = {filesInDir.name};
        maskOfImagesByCaseFiles = cellfun(@(x) isempty(strfind(x, 'maskOfImagesByCase_')) == 0, filesInDir);
        if any(maskOfImagesByCaseFiles) == 0
            maskOfImagesByCase = cell(size(filterOfMarkers, 2), 2);
            for numMarker = 1:size(filterOfMarkers, 2)
                if filterOfMarkers(numCase, numMarker) ~= 0
                    originalImg = imread(imagesByCase{numMarker});
                    [ imgWithHoles, ~] = removingArtificatsFromImage(originalImg, possibleMarkers{numMarker});

                    [ maskImage2 ] = createEllipsoidalMaskFromImage(imgWithHoles, 1 - bwareaopen(logical(1 - imgWithHoles), 1000000));

                    perimImage = bwperim(maskImage2, 8);

                    holesInImage = regionprops(logical(1-(imgWithHoles | perimImage)), 'all');

                    if size(holesInImage, 1) > 1
                        holesInImage = struct2table(holesInImage);
                        holesInImage = holesInImage(2:end, :);
                        holesInImage(holesInImage.Area < 2000, :) = [];

                        outputDirectoryMarker = strcat(outputDirectory, '\', possibleMarkers{numMarker});
                        mkdir(outputDirectoryMarker)
                        for numHole = 1:size(holesInImage, 1)
                            h = figure('Visible', 'off');
                            imshow(insertShape(double(imgWithHoles | perimImage), 'FilledRectangle', holesInImage.BoundingBox(numHole, :), 'Color', 'green'));
                            print(h, strcat(outputDirectoryMarker, '\hole_Number_', num2str(numHole), '.jpg'), '-djpeg', '-r300');
                            close(h);
                        end
                        maskOfImagesByCase(numMarker, :) = [{imgWithHoles | perimImage}; {holesInImage}];
                    else
                        maskOfImagesByCase(numMarker, 1) = {imgWithHoles | perimImage};
                    end

                    
                end
            end

            save(strcat(outputFatherDir, num2str(uniqueCases(numCase)), '\maskOfImagesByCase_', date), 'maskOfImagesByCase');
        else
            load(strcat(filePath, '\', filesInDir{maskOfImagesByCaseFiles}));
        end
        
        couplingHolesFiles = cellfun(@(x) isempty(strfind(x, 'couplingHoles_')) == 0, filesInDir);
        if any(couplingHolesFiles) == 0
            %% Matching of marker images regarding their holes
            similarHolesProperties.maxDistanceOfCorrelations = 700;
            similarHolesProperties.maxDistanceBetweenPixels = 100;
            similarHolesProperties.minCorrelation = 0.5;
            %radiusOfTheAreaTaken = 350;
            couplingHoles = cell(size(filterOfMarkers, 2));
            for actualMarker = 1:size(filterOfMarkers, 2)
                for numMarkerToCheck = actualMarker+1:size(filterOfMarkers, 2)
                    %Match the holes
                    if isempty(maskOfImagesByCase{actualMarker, 2}) == 0 && isempty(maskOfImagesByCase{numMarkerToCheck, 2}) == 0
                        couplingHoles{actualMarker, numMarkerToCheck} = matchHoles(maskOfImagesByCase{actualMarker, 2}, maskOfImagesByCase{numMarkerToCheck, 2}, similarHolesProperties, strcat(outputDirectory, '\', possibleMarkers{actualMarker}, '_', possibleMarkers{numMarkerToCheck}));
                    else
                        couplingHoles{actualMarker, numMarkerToCheck} = [];
                    end

                    % Once we have the coupling of holes. We have to get the matching
                    % areas, which will be a circular region of radius
                    % 'radiusOfTheAreaTaken'

                end
            end

            save(strcat(outputFatherDir, num2str(uniqueCases(numCase)), '\couplingHoles_', date), 'couplingHoles');
        else
            load(strcat(filePath, '\', filesInDir{couplingHolesFiles}));
        end
        
        %% Get regions of biopsies
        finalGoodRegionsFiles = cellfun(@(x) isempty(strfind(x, 'finalGoodRegions_')) == 0, filesInDir);
        if any(finalGoodRegionsFiles) == 0
            pairedRegions = {};
            %Refine coupling holes
            for marker1 = 1:size(couplingHoles, 1)
                for marker2 = 1:size(couplingHoles, 2)
                    if isempty(couplingHoles{marker1, marker2}) == 0
                        couplingHolesActual = couplingHoles{marker1, marker2};
                        [hole1, hole2] = find(couplingHolesActual);

                        marker1Holes = maskOfImagesByCase{marker1, 2};
                        marker2Holes = maskOfImagesByCase{marker2, 2};
                        if isempty(hole1) == 0
                            for numPairOfHoles = 1:size(hole1, 1)
                                actualHole1 = marker1Holes(hole1(numPairOfHoles), :);
                                actualHole2 = marker2Holes(hole2(numPairOfHoles), :);
                                h = figure('Visible', 'on', 'units','normalized','outerposition',[0 0 1 1]);
                                ax1 = subplot(1,2,1);
                                imgToShow = double(maskOfImagesByCase{marker1, 1}) * 255;
                                boundingBox = round(actualHole1.BoundingBox);
                                imgToShow(boundingBox(2):boundingBox(2)+boundingBox(4) - 1, boundingBox(1):boundingBox(1)+boundingBox(3) - 1) = (imgToShow(boundingBox(2):boundingBox(2)+boundingBox(4) - 1, boundingBox(1):boundingBox(1)+boundingBox(3) - 1) == 0 & actualHole1.Image{1}) * 155;
                                imgToShow(maskOfImagesByCase{marker1, 1} == 1) = 255;
                                hImg = imshow(imgToShow, hot);
                                hImg.CDataMapping = 'scale';
                                title(strcat(possibleMarkers{marker1}, ': hole', num2str(hole1(numPairOfHoles))))

                                ax2 = subplot(1,2,2);
                                imgToShow = double(maskOfImagesByCase{marker2, 1}) * 255;
                                boundingBox = round(actualHole2.BoundingBox);
                                imgToShow(boundingBox(2):boundingBox(2)+boundingBox(4) - 1, boundingBox(1):boundingBox(1)+boundingBox(3) - 1) = (imgToShow(boundingBox(2):boundingBox(2)+boundingBox(4) - 1, boundingBox(1):boundingBox(1)+boundingBox(3) - 1) == 0 & actualHole2.Image{1}) * 155;
                                imgToShow(maskOfImagesByCase{marker2, 1} == 1) = 255;
                                hImg = imshow(imgToShow, hot);
                                hImg.CDataMapping = 'scale';
                                title(strcat(possibleMarkers{marker2}, ': hole', num2str(hole2(numPairOfHoles))))
                                correct = [];
                                while isempty(correct)
                                    correct = input('Is it correct (0/1)? ');

                                    if isempty(correct) == 0
                                        if isequal(correct, 1)
                                            pairedRegions{end+1, 1} = {possibleMarkers{marker1}, hole1(numPairOfHoles), actualHole1};
                                            pairedRegions{end, 2} = {possibleMarkers{marker2}, hole2(numPairOfHoles), actualHole2};
                                        end
                                    end
                                end
                                close all
                            end
                        end
                    end
                end
            end

            save(strcat(outputFatherDir, num2str(uniqueCases(numCase)), '\finalGoodRegions_', date), 'pairedRegions', '-v7.3');
        else
            load(strcat(filePath, '\', filesInDir{finalGoodRegionsFiles}));
        end

        %Region analysis
        allHolesCoupled = cellfun(@(x) x(3), pairedRegions);
        sameHoleInDifferentMarkers = pairedRegions(1, 1);
        
        numHole = 1;
        
        while isempty(pairedRegions) == 0
            infoActualHoles = vertcat(sameHoleInDifferentMarkers{numHole}{:, 3});
            %If two holes have the same area and centroids they are the
            %same
            coupledHoledActual = cellfun(@(x) ismember(x.Area, infoActualHoles.Area) & ismember(x.Centroid, infoActualHoles.Centroid, 'rows'), allHolesCoupled);
            if any(any(coupledHoledActual, 2))
                actualHoles = vertcat(pairedRegions{any(coupledHoledActual, 2), :});
                %Removing found holes
                pairedRegions(any(coupledHoledActual, 2), :) = [];
                allHolesCoupled(any(coupledHoledActual, 2), :) = [];

                sameHoleInDifferentMarkers{numHole} = vertcat(sameHoleInDifferentMarkers{numHole}, actualHoles);
            else %New sequence of holes
                %Unique holes of each marker
                [sameHoleInDifferentMarkers{numHole}] = getCoupledRegions(sameHoleInDifferentMarkers{numHole});
                
                %New hole
                numHole = numHole + 1;
                sameHoleInDifferentMarkers(numHole) = pairedRegions(1,1);
            end
        end
        % The last hole
        [sameHoleInDifferentMarkers{numHole}] = getCoupledRegions(sameHoleInDifferentMarkers{numHole}, onlyImagesFilesMasks(filterOfMarkersMasks(numCase, :)));
        
        possibleSituations = (1:3).^2; % {'Low', 'Mid', 'High'};
        allCombinationsPonderations = permn(possibleSituations, size(possibleMarkers, 2));
        %Order by importance (
        [values, indices] = sort(sum(allCombinationsPonderations, 2));
        
        realSituations = {'Low', 'Mid', 'High'};
        allCombinations = permn(realSituations, size(possibleMarkers, 2));
        allCombinations(indices, :);
        
        %matchingImagesWithinMarkers(imagesByCase);
%         
% %         figure;
% %         
% %         for numMarker = 1:size(filterOfMarkers, 2)
% %             if filterOfMarkers(numCase, numMarker) ~= 0
% %                 subplot(subWindowX, subWindowY, numMarker)
% %                 imgToSubPlot = imread(onlyImagesFilesNoMasks{filterOfMarkers(numCase, numMarker)});
% %                 imshow(imgToSubPlot);
% %             end
% %         end
% %         
% %         for numMarker = 1:size(filterOfMarkers, 2)
% %             if filterOfMarkers(numCase, numMarker) ~= 0
% %                 figure
% %                 imgVTN = imread(onlyImagesFilesNoMasks{filterOfMarkers(1, numMarker)});
% %                 imshow(imgVTN)
% %                 %[x, y, BW, xi, yi] = roipoly(imgVTN);
% %             end
% %         end
    end
end

