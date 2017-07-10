function [ ] = analysis3D( imagesPath, possibleMarkers )
%ANALYSIS3D Summary of this function goes here
%   Detailed explanation goes here
    allFiles = getAllFiles(imagesPath);
    onlyImagesFiles = cellfun(@(x) isempty(strfind(lower(x), lower('\Images\'))) == 0, allFiles);
    onlyImagesFiles = allFiles(onlyImagesFiles);
    
    onlyImageFilesNoMasks = cellfun(@(x) isempty(strfind(lower(x), 'mask')) | isempty(strfind(lower(x), 'neg')), onlyImageFiles);
    
    
    %Filtering by markers
    filterOfMarkers = zeros(size(onlyImagesFiles, 1), size(possibleMarkers, 1));
    for numMarker = 1:size(possibleMarkers, 1)
        filterOfMarkers(:, numMarker) = cellfun(@(x) isempty(strfind(lower(x), lower(possibleMarkers{numMarker}))) == 0, onlyImagesFiles);
    end
end

