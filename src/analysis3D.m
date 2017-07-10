function [ ] = analysis3D( imagesPath, possibleMarkers )
%ANALYSIS3D Summary of this function goes here
%   Detailed explanation goes here
    allFiles = getAllFiles(imagesPath);
    onlyImagesFiles = cellfun(@(x) isempty(strfind(lower(x), lower('\Images\'))) == 0 & isempty(strfind(lower(x), lower('.txt'))), allFiles);
    onlyImagesFiles = allFiles(onlyImagesFiles);
    
    onlyImagesFilesNoMasks = cellfun(@(x) isempty(strfind(lower(x), 'mask')) & isempty(strfind(lower(x), 'neg')) & isempty(strfind(lower(x), 'cel')), onlyImagesFiles);
    
    onlyImagesFilesNoMasks = onlyImagesFiles(onlyImagesFilesNoMasks);
    %Filtering by markers
    filterOfMarkers = zeros(size(onlyImagesFilesNoMasks, 1), size(possibleMarkers, 1));
    for numMarker = 1:size(possibleMarkers, 1)
        filterOfMarkers(:, numMarker) = cellfun(@(x) isempty(strfind(lower(x), lower(possibleMarkers{numMarker}))) == 0, onlyImagesFilesNoMasks);
    end
    
    filterOfMarkers
end

