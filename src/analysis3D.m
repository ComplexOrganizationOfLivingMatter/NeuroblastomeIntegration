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
        maskOfImagesByCase = cell(size(filterOfMarkers, 2));
        for numMarker = 1:size(filterOfMarkers, 2)
            originalImg = imread(imagesByCase{numMarker});
            [ maskOfImagesByCase{numMarker}, ~] = removingArtificatsFromImage(originalImg);
        end
        
        matchingImagesWithinMarkers(imagesByCase);
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

