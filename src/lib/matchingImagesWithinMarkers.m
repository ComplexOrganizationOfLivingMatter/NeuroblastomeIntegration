function [ output_args ] = matchingImagesWithinMarkers(imagesByCase)
%MATCHINGIMAGESWITHINMARKERS Summary of this function goes here
%   Detailed explanation goes here

    thresholdOfFeatures = 2;
    %% VTN
    imgVTN = imread(imagesByCase{1});
    [ imgSegmented, imgOnlyWhite, imgNoMarkersNoWhite ] = processVTNRawImage(imgVTN);
    img1Gray = rgb2gray(imgVTN);
    
    img1Gray(~imgNoMarkersNoWhite & ~imgSegmented{4}) = 0;
    points1 = detectMSERFeatures(img1Gray, 'RegionAreaRange', [(size(imgVTN, 1) * size(imgVTN, 2)*0.001) uint16(size(imgVTN, 1) * size(imgVTN, 2))], 'ThresholdDelta', thresholdOfFeatures);
    figure
    imshow(img1Gray); hold on;
    plot(points1);
    
    %% COL
    imgCOL = imread(imagesByCase{2});
    img2Gray = rgb2gray(imgCOL);
    img2Gray = 255 - img2Gray;
    numChannel = 1;
    points2 = detectMSERFeatures(img2Gray, 'RegionAreaRange', [(size(imgCOL, 1) * size(imgCOL, 2)*0.001) uint16(size(imgCOL, 1) * size(imgCOL, 2))], 'ThresholdDelta', thresholdOfFeatures);
    figure
    imshow(img2Gray); hold on;
    plot(points2);
    
    %% Matching
    [features1,valid_points1] = extractFeatures(img1Gray, points1);
    [features2,valid_points2] = extractFeatures(img2Gray, points2);
    
    indexPairs = matchFeatures(features1,features2, 'Method', 'Approximate');
    
    matchedPoints1 = valid_points1(indexPairs(:,1),:);
    matchedPoints2 = valid_points2(indexPairs(:,2),:);
    
    figure; showMatchedFeatures(img1Gray, img2Gray, matchedPoints1, matchedPoints2);
end

