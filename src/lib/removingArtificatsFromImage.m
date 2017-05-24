function [ newMask ] = removingArtificatsFromImage( mask, originalImage )
%REMOVINGARTIFICATSFROMIMAGE Summary of this function goes here
%   Detailed explanation goes here
    originalImgGray = rgb2gray(originalImage);
    imgBin = originalImgGray < 255;
    segmented = regionprops(1 - imgBin);
end

