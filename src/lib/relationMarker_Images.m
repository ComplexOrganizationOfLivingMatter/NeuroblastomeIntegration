function [ filterOfMarkers, meanOfGraythreshPerMarker, uniqueCases ] = relationMarker_Images( possibleMarkers, onlyImagesFilesNoMasks, vtnMarker )
%RELATIONMARKER_IMAGES Summary of this function goes here
%   Detailed explanation goes here

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
    
    [uniqueCases, ~, uniqueCasesIndices] = unique(patientsOnlyNumbers);

    filterOfMarkers = zeros(size(uniqueCases, 2), size(possibleMarkers, 2));
    meanOfGraythreshPerMarker = zeros(size(possibleMarkers, 2), 3);
    for numMarker = 1:size(possibleMarkers, 2)
        if strcmpi(possibleMarkers{numMarker}, 'vitronectine') && isempty(vtnMarker) == 0
            for numVtnMarker = 1:size(vtnMarker, 2)
                foundMarkers = cellfun(@(x) isempty(strfind(lower(x), lower(possibleMarkers{numMarker}))) == 0 & isempty(strfind(lower(x), vtnMarker{numVtnMarker})) == 0, onlyImagesFilesNoMasks);
                casesInMarker = uniqueCasesIndices(foundMarkers);
                %meanOfGraythreshPerMarker(numMarker, :) = calculateMeanGrayThreshOfImages(onlyImagesFilesNoMasks(foundMarkers));
                filterOfMarkers(casesInMarker, numMarker + numVtnMarker - 1) = find(foundMarkers)';
            end
        else
            foundMarkers = cellfun(@(x) isempty(strfind(lower(x), lower(possibleMarkers{numMarker}))) == 0, onlyImagesFilesNoMasks);
            casesInMarker = uniqueCasesIndices(foundMarkers);
            %meanOfGraythreshPerMarker(numMarker, :) = calculateMeanGrayThreshOfImages(onlyImagesFilesNoMasks(foundMarkers));
            filterOfMarkers(casesInMarker, numMarker) = find(foundMarkers)';
        end
    end
end

