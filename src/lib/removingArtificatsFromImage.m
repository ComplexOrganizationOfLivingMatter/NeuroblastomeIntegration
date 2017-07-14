function [ newMask, boundingBox, imgBinOriginal] = removingArtificatsFromImage(originalImage, marker)
%REMOVINGARTIFICATSFROMIMAGE Summary of this function goes here
%   Detailed explanation goes here
    originalImgGray = rgb2gray(originalImage);
    switch marker
        case 'Vitronectine'
            imgBin = originalImgGray >= 255;
        otherwise
            imgBin = im2bw(originalImgGray, 0.5*graythresh(originalImgGray) + 0.5*graythresh(originalImgGray(1:100,1:100)));
    end

    imgBinOriginal = logical(1-imgBin);
    
    maskOfBiopsy = 1 - bwareaopen(logical(1 - imgBinOriginal), 1000000);
    [ maskImage2, boundingBox ] = createEllipsoidalMaskFromImage(imgBinOriginal, maskOfBiopsy);
    
    imgBin = imgBinOriginal;
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

