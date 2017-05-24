function [ newMask, boundingBox] = removingArtificatsFromImage(originalImage)
%REMOVINGARTIFICATSFROMIMAGE Summary of this function goes here
%   Detailed explanation goes here
    originalImgGray = rgb2gray(originalImage);
    imgBin = originalImgGray < 255;
    maskOfBiopsy = 1 - bwareaopen(logical(1 - imgBin), 1000000);
    boundingBox = regionprops(maskOfBiopsy, 'BoundingBox');
    
    boundingBox = boundingBox.BoundingBox;
    figure;
    imshow(imgBin);
    h = imellipse(gca, boundingBox);
    api = iptgetapi(h);

    fcn = getPositionConstraintFcn(h);

    api.setPositionConstraintFcn(fcn);

    maskImage2 = createMask(h);
    close all
    
    imgBin(maskImage2 == 0) = 1;
    
    imgBinDilated = imdilate(imgBin, strel('disk', 20));
    %The holes we want to eliminate but dilated
    [pixelsXOfGoodAreas, pixelsYOfGoodAreas] = find(1 - imgBinDilated);
    %All the holes
    segmentedAreasReal = regionprops(logical(1 - imgBin), 'PixelList');
    allHolePixels = {segmentedAreasReal.PixelList};
    
    finalRemovableAreas = cellfun(@(x) sum(ismember([pixelsYOfGoodAreas, pixelsXOfGoodAreas], x, 'rows')) > 0, allHolePixels);
    
    pixelsToRemoveFromMask = vertcat(segmentedAreasReal(finalRemovableAreas).PixelList);
    pixelsToRemoveFromMask = fliplr(pixelsToRemoveFromMask);
    newMask = maskImage2;
    %Remove the pixels of the big holes
    for numRow = 1:size(pixelsToRemoveFromMask, 1)
        newMask(pixelsToRemoveFromMask(numRow, 1), pixelsToRemoveFromMask(numRow, 2)) = 0;
    end
end

