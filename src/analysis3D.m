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
    
    thresholdOfFeatures = 2;
    
    for numCase = 1:size(filterOfMarkers, 1)
        img1 = imread(onlyImagesFilesNoMasks{filterOfMarkers(1, 1)});
        img1Gray = rgb2gray(img1);
        numChannel = 1;
        points1 = detectMSERFeatures(img1Gray, 'RegionAreaRange', [(size(img1, 1) * size(img1, 2)*0.001) uint16(size(img1, 1) * size(img1, 2))], 'ThresholdDelta', thresholdOfFeatures);
        figure
        imshow(img1Gray); hold on;
        plot(points1);

        img2 = imread(onlyImagesFilesNoMasks{filterOfMarkers(1, 2)});
        img2Gray = rgb2gray(img2);
        numChannel = 1;
        points2 = detectMSERFeatures(img2Gray, 'RegionAreaRange', [(size(img2, 1) * size(img2, 2)*0.001) uint16(size(img2, 1) * size(img2, 2))], 'ThresholdDelta', thresholdOfFeatures);
        figure
        imshow(img2Gray); hold on;
        plot(points2);
        
        [features1,valid_points1] = extractFeatures(img1Gray, points1);
        [features2,valid_points2] = extractFeatures(img2Gray, points2);
        
        indexPairs = matchFeatures(features1,features2, 'Method', 'Approximate');
        
        matchedPoints1 = valid_points1(indexPairs(:,1),:);
        matchedPoints2 = valid_points2(indexPairs(:,2),:);
        
        figure; showMatchedFeatures(img1Gray, img2Gray, matchedPoints1,matchedPoints2);
    end
end

