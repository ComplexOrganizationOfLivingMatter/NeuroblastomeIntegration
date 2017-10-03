function [ filterOfMarkers, meanOfGraythreshPerMarker ] = relationMarker_Images( possibleMarkers, onlyImagesFilesNoMasks, uniqueCasesIndices )
%RELATIONMARKER_IMAGES Summary of this function goes here
%   Detailed explanation goes here

    filterOfMarkers = zeros(size(uniqueCases, 2), size(possibleMarkers, 2));
    meanOfGraythreshPerMarker = zeros(size(possibleMarkers, 2), 3);
    for numMarker = 1:size(possibleMarkers, 2)
        foundMarkers = cellfun(@(x) isempty(strfind(lower(x), lower(possibleMarkers{numMarker}))) == 0, onlyImagesFilesNoMasks);
        casesInMarker = uniqueCasesIndices(foundMarkers);
        %meanOfGraythreshPerMarker(numMarker, :) = calculateMeanGrayThreshOfImages(onlyImagesFilesNoMasks(foundMarkers));
        filterOfMarkers(casesInMarker, numMarker) = find(foundMarkers)';
    end
end

