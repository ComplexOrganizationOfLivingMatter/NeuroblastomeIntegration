function [ ] = analysis3D( imagesPath, possibleMarkers )
%ANALYSIS3D Summary of this function goes here
%   Detailed explanation goes here
%   How to run it:
%   analysis3D('D:\Pablo\Neuroblastoma\Datos\Data\NuevosCasos160\Casos', {'COLAGENO', 'VasosSanguineos', 'RET', 'GAGs', 'LymphaticVessels', 'Vitronectine'});

    
    radiusOfTheAreaTaken = 750;

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
        optionSelected = 0;
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
            similarHolesProperties.maxDistanceOfCorrelations = 1500;
            similarHolesProperties.maxDistanceBetweenPixels = 500;
            similarHolesProperties.minCorrelation = 0.5;
            
            
            holesOrder = cell(size(filterOfMarkers, 2), 1);
            
            figure;
            for numImageByCase = 1:size(imagesByCase, 2)
                if isempty(imagesByCase(numImageByCase)) == 0
                    imgAxes(numImageByCase) = subplot(2, 3, numImageByCase);
                    imshow(imagesByCase{numImageByCase});
                end
            end
            title(strcat('Case: ', num2str(uniqueCases(numCase))));
            disp('Menu:')
            disp('1- Continue with match holes')
            disp('2- Couple all the 5 regions with a window')
            disp('99- Next marker')
            optionSelected = input('Option: ');
            
            if optionSelected == 1
                close all
                couplingHoles = cell(size(filterOfMarkers, 2));
                for actualMarker = 1:size(filterOfMarkers, 2)
                    for numMarkerToCheck = actualMarker+1:size(filterOfMarkers, 2)
                        %If we've coupled the first marker with the rest just
                        %put that holes with each other
                        if isempty(holesOrder{numMarkerToCheck}) == 0 && isempty(holesOrder{actualMarker}) == 0 
                            couplingHolesActual = zeros(size(maskOfImagesByCase{actualMarker, 2}, 1), size(maskOfImagesByCase{numMarkerToCheck, 2}, 1));

                            couplingHolesActual(holesOrder{actualMarker}, holesOrder{numMarkerToCheck}) = 1;

                            couplingHoles{actualMarker, numMarkerToCheck} = couplingHolesActual;

                        elseif isempty(maskOfImagesByCase{actualMarker, 2}) == 0 && isempty(maskOfImagesByCase{numMarkerToCheck, 2}) == 0 %Match the holes
                            couplingHoles{actualMarker, numMarkerToCheck} = matchHoles(maskOfImagesByCase(actualMarker, :), maskOfImagesByCase(numMarkerToCheck, :), similarHolesProperties, strcat(outputDirectory, '\', possibleMarkers{actualMarker}, '_', possibleMarkers{numMarkerToCheck}));
                        else
                            couplingHoles{actualMarker, numMarkerToCheck} = [];
                        end
                    end

                    if actualMarker == 1
                        %% If we've found for the first marker all its correspondent hole, we don't need to continue.
                        % Just put that holes in its correspondent place and
                        % move on
                        emptyMarkers = cellfun(@isempty, maskOfImagesByCase);
                        emptyMarkers(1, :) = 1;
                        [holesOfMarkerActualMarker, holesOfRestMarkers] = cellfun(@find, couplingHoles(actualMarker, emptyMarkers(:, 1) == 0), 'UniformOutput', false);
                        holesOfMarkerActualMarker = cellfun(@unique, holesOfMarkerActualMarker, 'UniformOutput', false);
                        holesOfMarkerActualMarkerMat = vertcat(holesOfMarkerActualMarker{:});
                        %holesOfRestMarkers = vertcat(holesOfRestMarkers{:});
                        [counts, holeNumber] = hist(holesOfMarkerActualMarkerMat, length(unique(holesOfMarkerActualMarkerMat)));
                        [maxNumber, holeIndex] = max(counts);
                        if maxNumber >= sum(emptyMarkers(:, 1) == 0)
                            restOfMarkersNumbers = holesOfRestMarkers(cellfun(@(x) ismember(holeNumber(holeIndex), x), holesOfMarkerActualMarker));
                            holesOrder{actualMarker} = holeNumber(holeIndex);
                            holesOrder(emptyMarkers(:, 1) == 0) = restOfMarkersNumbers;
                        end
                    end
                end

                save(strcat(outputFatherDir, num2str(uniqueCases(numCase)), '\couplingHoles_', date), 'couplingHoles');
            elseif optionSelected == 2
                HEPA_OR_MACR = cell(size(filterOfMarkersMasks, 2), 1);
                masksOfHoles = filterOfMarkersMasks(numCase, :);
                maskFiles = onlyImagesFilesMasks(masksOfHoles(masksOfHoles ~= 0));
                imgOfRegions = cell(size(masksOfHoles(masksOfHoles ~= 0), 2), 1);
                for numImageByCase = 1:size(imagesByCase, 2)
                    if isempty(imagesByCase{numImageByCase}) == 0
                        set(gcf, 'currentaxes', imgAxes(numImageByCase));
                        [x, y] = getpts(gca);
                        centroidOfRegions(numImageByCase, :) = [y, x];
                        actualMask = imread(maskFiles{numImageByCase});
                        
                        imgOfRegions{numImageByCase} = regionOfImage(actualMask(:, :, 1), radiusOfTheAreaTaken, x, y );
                        % Region of image of the possible region
                        noMaskRegion = regionOfImage(maskOfImagesByCase{numImageByCase, 1}, radiusOfTheAreaTaken, x, y );
                        
                        fibreArea(numImageByCase) = sum(imgOfRegions{numImageByCase}(:));
                        possibleArea(numImageByCase) = sum(noMaskRegion(:));
                        percentageCoveredByFibre(numImageByCase) = fibreArea/possibleArea;
                    end
                end
                vtnMacrFile = imread(maskFiles{end});
                imgOfRegions{numImageByCase+1} = regionOfImage( vtnMacrFile(:, :, 1), radiusOfTheAreaTaken, x, y );
                fibreArea(numImageByCase+1) = sum(imgOfRegions{numImageByCase+1}(:));
                possibleArea(numImageByCase+1) = sum(noMaskRegion(:));
                percentageCoveredByFibre(numImageByCase+1) = fibreArea/possibleArea;
                HEPA_OR_MACR(numImageByCase) = {'HEPA'};
                HEPA_OR_MACR(numImageByCase+1) = {'MACR'};
                
                sameRegionInDifferentMarkers = table(imgOfRegions, fibreArea', possibleArea', percentageCoveredByFibre', HEPA_OR_MACR);
                
                save(strcat(outputFatherDir, num2str(uniqueCases(numCase)), '\couplingHoles_', date), 'sameRegionInDifferentMarkers');
                close all
            else
                couplingHoles = cell(size(filterOfMarkers, 2));
                save(strcat(outputFatherDir, num2str(uniqueCases(numCase)), '\couplingHoles_', date), 'couplingHoles');
                close all
            end
        else
            load(strcat(filePath, '\', filesInDir{couplingHolesFiles}));
        end
        
        if isequal(optionSelected, 99)
            continue
        end
        
        %% Get regions of biopsies
        finalGoodRegionsFiles = cellfun(@(x) isempty(strfind(x, 'finalGoodRegions_')) == 0, filesInDir);
        if any(finalGoodRegionsFiles) == 0
            if exist('sameRegionInDifferentMarkers', 'var') == 0
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

                                    pairedRegions{end+1, 1} = {possibleMarkers{marker1}, hole1(numPairOfHoles), actualHole1};
                                    pairedRegions{end, 2} = {possibleMarkers{marker2}, hole2(numPairOfHoles), actualHole2};

                                end
                            end
                        end
                    end
                end

                save(strcat(outputFatherDir, num2str(uniqueCases(numCase)), '\finalGoodRegions_', date), 'pairedRegions', '-v7.3');
            end
        else
            load(strcat(filePath, '\', filesInDir{finalGoodRegionsFiles}));
        end

        
        %% Region analysis
        finalsameHoleInDifferentMarkersFiles = cellfun(@(x) isempty(strfind(x, 'sameHoleInDifferentMarkers_')) == 0, filesInDir);
        if any(finalsameHoleInDifferentMarkersFiles) == 0
            if exist('sameRegionInDifferentMarkers', 'var') == 0 && isempty(pairedRegions) == 0
                allHolesCoupled = cellfun(@(x) x(3), pairedRegions);
                sameHoleInDifferentMarkers = pairedRegions(1, 1);
                numHole = 1;

                meanOfPercentageOfFibrePerRegion = [];
                stdOfPercentageOfFibrePerRegion = [];

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
                        [sameHoleInDifferentMarkers{numHole}] = getCoupledRegions(sameHoleInDifferentMarkers{numHole}, onlyImagesFilesMasks(filterOfMarkersMasks(numCase, :)), radiusOfTheAreaTaken, horzcat(maskOfImagesByCase, possibleMarkers'));

                        actualInfoOfMarkers = sameHoleInDifferentMarkers{numHole};
                        meanOfPercentageOfFibrePerRegion(numHole) = mean(actualInfoOfMarkers.fibreArea / mean(actualInfoOfMarkers.possibleArea)) * 100;
                        stdOfPercentageOfFibrePerRegion(numHole) = std(actualInfoOfMarkers.fibreArea / mean(actualInfoOfMarkers.possibleArea)) * 100;

                        %New hole
                        numHole = numHole + 1;
                        sameHoleInDifferentMarkers(numHole) = pairedRegions(1,1);
                    end
                end
                % The last hole
                masksOfHoles = filterOfMarkersMasks(numCase, :);
                [sameHoleInDifferentMarkers{numHole}] = getCoupledRegions(sameHoleInDifferentMarkers{numHole}, onlyImagesFilesMasks(masksOfHoles(masksOfHoles~= 0)), radiusOfTheAreaTaken, horzcat(maskOfImagesByCase, possibleMarkers'));
                actualInfoOfMarkers = sameHoleInDifferentMarkers{numHole};
                meanOfPercentageOfFibrePerRegion(numHole) = mean(actualInfoOfMarkers.fibreArea / mean(actualInfoOfMarkers.possibleArea)) * 100;
                stdOfPercentageOfFibrePerRegion(numHole) = std(actualInfoOfMarkers.fibreArea / mean(actualInfoOfMarkers.possibleArea)) * 100;

    %             save(strcat(filePath, '\sameHoleInDifferentMarkers_', date), 'sameHoleInDifferentMarkers', 'meanOfPercentageOfFibrePerRegion', 'stdOfPercentageOfFibrePerRegion', '-v7.3');
                save(strcat(filePath, '\sameHoleInDifferentMarkers_', date), 'sameHoleInDifferentMarkers', '-v7.3');
            elseif exist('sameRegionInDifferentMarkers', 'var')
                save(strcat(filePath, '\sameHoleInDifferentMarkers_', date), 'sameRegionInDifferentMarkers', '-v7.3');
            else
                num2str(uniqueCases(numCase))
                disp('No coupling at all!');
            end
        else
            load(strcat(filePath, '\', filesInDir{finalsameHoleInDifferentMarkersFiles}));
        end
        
        
        
        
        % We remove it because we check if it is created in previous steps.
        % In order to do coupling or if i've selected only a few centroids
        clearvars sameRegionInDifferentMarkers
        
%         possibleSituations = (1:3).^2; % {'Low', 'Mid', 'High'};
%         allCombinationsPonderations = permn(possibleSituations, size(possibleMarkers, 2));
%         %Order by importance (
%         [values, indices] = sort(sum(allCombinationsPonderations, 2));
%         
%         realSituations = {'Low', 'Mid', 'High'};
%         allCombinations = permn(realSituations, size(possibleMarkers, 2));
%         allCombinations(indices, :);
        
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

