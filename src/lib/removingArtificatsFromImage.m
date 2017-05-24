function [ newMask ] = removingArtificatsFromImage( mask, originalImage )
%REMOVINGARTIFICATSFROMIMAGE Summary of this function goes here
%   Detailed explanation goes here
    originalImgGray = rgb2gray(originalImage);
    imgBin = originalImgGray < 255;
    maskOfBiopsy = 1 - bwareaopen(1-imgBin, 1000000);
    boundingBox = regionprops(maskOfBiopsy, 'BoundingBox');
    
    figure;
    %roiImage = imread(fullPathImage);
    imshow(imgBin);
    h = imellipse(gca, boundingBox.BoundingBox);
    api = iptgetapi(h);

    fcn = getPositionConstraintFcn(h);

    api.setPositionConstraintFcn(fcn);

    maskImage2 = createMask(h);
    close all
    
    imgBin(maskImage2 == 0) = 1;
    
    imgBinDilated = imdilate(imgBin, strel('disk', 20));
    %The holes we want to eliminate but dilated
    pixelsOfGoodAreas = regionprops(imgBinDilated, 'PixelList');
    %All the holes
    segmentedAreasReal = regionprops(imgBin, 'PixelList');
    allHolePixels = {segmentedAreasReal.PixelList};
    
    pixelsToRemoveFromMask = segmentedAreasReal(finalRemovableAreas).PixelList;
    pixelsToRemoveFromMask = fliplr(pixelsToRemoveFromMask);
    imshow(mask);
    newMask = mask;
    %Remove the pixels of the big holes
    for numRow = 1:size(pixelsToRemoveFromMask, 1)
        newMask(pixelsToRemoveFromMask(numRow, 1), pixelsToRemoveFromMask(numRow, 2)) = 0;
    end
    figure;
    imshow(newMask);
end

