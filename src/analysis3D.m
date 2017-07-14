function [ ] = analysis3D( imagesPath, possibleMarkers )
%ANALYSIS3D Summary of this function goes here
%   Detailed explanation goes here

    allFiles = getAllFiles(imagesPath);
    onlyImagesFiles = cellfun(@(x) isempty(strfind(lower(x), lower('\Images\'))) == 0 & isempty(strfind(lower(x), lower('.txt'))), allFiles);
    onlyImagesFiles = allFiles(onlyImagesFiles);
    
    onlyImagesFilesNoMasks = cellfun(@(x) isempty(strfind(lower(x), 'mask')) & isempty(strfind(lower(x), 'neg')) & isempty(strfind(lower(x), 'cel')), onlyImagesFiles);
    onlyImagesFilesNoMasks = onlyImagesFiles(onlyImagesFilesNoMasks);
    
    patientOfImagesSplitted = cellfun(@(x) strsplit(x, '\'), onlyImagesFilesNoMasks, 'UniformOutput', false);
    patientOfImages = cellfun(@(x) strsplit(x{end-1}, '_'), patientOfImagesSplitted, 'UniformOutput', false);
    
    patientOfImagesOnlyCase = cell(size(patientOfImages, 1), 1);
    for numImage = 1:size(patientOfImages, 1)
        newCase = patientOfImages{numImage};
        if size(newCase, 2) > 1
            if newCase{2}(1) == 'A' || newCase{2}(1) == 'B' || isempty(newCase{1})
                patientOfImagesOnlyCase(numImage) = {strjoin(newCase(1:2), '_')};
            else
                patientOfImagesOnlyCase(numImage) = newCase(1);
            end
        else
            patientOfImagesOnlyCase(numImage) = {newCase};
        end
    end
    
    
    patientsOnlyNumbers = regexp([patientOfImagesOnlyCase{:}], '[0-9]{4,}', 'match');
    patientsOnlyNumbers = cellfun(@(x) str2double(x), [patientsOnlyNumbers{:}]);
    
    [uniqueCases, ia, uniqueCasesIndices] = unique(patientsOnlyNumbers);
    %Filtering by markers
    filterOfMarkers = zeros(size(uniqueCases, 2), size(possibleMarkers, 2));
    for numMarker = 1:size(possibleMarkers, 2)
        foundMarkers = cellfun(@(x) isempty(strfind(lower(x), lower(possibleMarkers{numMarker}))) == 0, onlyImagesFilesNoMasks);
        casesInMarker = uniqueCasesIndices(foundMarkers);
        filterOfMarkers(casesInMarker, numMarker) = find(foundMarkers)';
    end
    
    subWindowX = size(filterOfMarkers, 2);
    subWindowY = 1;
    for numCase = 1:size(filterOfMarkers, 1)
        imagesByCase = {onlyImagesFilesNoMasks{filterOfMarkers(numCase, :)}};
        maskOfImagesByCase = cell(size(filterOfMarkers, 2), 2);
        for numMarker = 1:size(filterOfMarkers, 2)
            originalImg = imread(imagesByCase{numMarker});
            [ imgWithHoles, ~] = removingArtificatsFromImage(originalImg, possibleMarkers{numMarker});
            
            [ maskImage2 ] = createEllipsoidalMaskFromImage(imgWithHoles, 1 - bwareaopen(logical(1 - imgWithHoles), 1000000));
            
            perimImage = bwperim(maskImage2, 8);
            
            holesInImage = regionprops(logical(1-(imgWithHoles | perimImage)), 'all');
            holesInImage = struct2table(holesInImage(2:end));
            holesInImage(holesInImage.Area < 2000, :) = [];
            
            
            maskOfImagesByCase(numMarker, :) = [{imgWithHoles | perimImage}; {holesInImage}]; 
        end
        
        %% Matching of marker images regarding their holes
        %similarHolesProperties.maxDistanceOfCentroids = 2000;
        similarHolesProperties.maxDistanceBetweenPixels = 100;
        similarHolesProperties.minCorrelation = 0.5;
        radiusOfTheAreaTaken = 350;
        couplingHoles = cell(size(filterOfMarkers, 2));
        for actualMarker = 1:size(filterOfMarkers, 2)
            for numMarkerToCheck = actualMarker+1:size(filterOfMarkers, 2)
                %Match the holes
                couplingHoles{actualMarker, numMarkerToCheck} = matchHoles(maskOfImagesByCase{actualMarker, 2}, maskOfImagesByCase{numMarkerToCheck, 2}, similarHolesProperties);
                
                % Once we have the coupling of holes. We have to get the matching
                % areas, which will a circular region of radius
                % 'radiusOfTheAreaTaken'
                
            end
        end
        
        
        %matchingImagesWithinMarkers(imagesByCase);
        
%         figure;
%         
%         for numMarker = 1:size(filterOfMarkers, 2)
%             if filterOfMarkers(numCase, numMarker) ~= 0
%                 subplot(subWindowX, subWindowY, numMarker)
%                 imgToSubPlot = imread(onlyImagesFilesNoMasks{filterOfMarkers(numCase, numMarker)});
%                 imshow(imgToSubPlot);
%             end
%         end
%         
%         for numMarker = 1:size(filterOfMarkers, 2)
%             if filterOfMarkers(numCase, numMarker) ~= 0
%                 figure
%                 imgVTN = imread(onlyImagesFilesNoMasks{filterOfMarkers(1, numMarker)});
%                 imshow(imgVTN)
%                 %[x, y, BW, xi, yi] = roipoly(imgVTN);
%             end
%         end
    end
end

