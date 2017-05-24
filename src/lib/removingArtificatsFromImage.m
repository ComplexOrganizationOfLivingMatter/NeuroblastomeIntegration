function [ newMask ] = removingArtificatsFromImage( mask, originalImage )
%REMOVINGARTIFICATSFROMIMAGE Summary of this function goes here
%   Detailed explanation goes here
    originalImgGray = rgb2gray(originalImage);
    imgBin = originalImgGray < 255;
    segmentedAreas = regionprops(imgBin, 'Area', 'PixelList');
    areasOfHoles = vertcat(segmentedAreas.Area);
    pixelsToRemoveFromMask = segmentedAreas(areasOfHoles > 100).PixelList;
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

