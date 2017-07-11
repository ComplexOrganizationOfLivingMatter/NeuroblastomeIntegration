function [ imgSegmented, imgOnlyWhite, imgNoMarkersNoWhite ] = processVTNRawImage( initialImage )
%PROCESSVTNRAWIMAGE Summary of this function goes here
%   Detailed explanation goes here
    vtnModerate = [128 0 0];
    vtnIntense = [255 0 0];
    
    %Have to check if this is real. Looks like if they were the cells. But
    %they are bigger than usual.
    vtnLow = [0 128 0];
    
    %Seems to be fibre. We want to capture all the blue region within the
    %VTN images.
    blueZoneRange = [30 70 230; 180 200 255];
    
    coloursOfSegmentations = {vtnModerate; vtnIntense; vtnLow};
    
    imgSegmented = cell(size(coloursOfSegmentations, 1), 1);
    for numSegmentation = 1:size(coloursOfSegmentations, 1)
        typeOfSegmentation = coloursOfSegmentations{numSegmentation};
        imgSegmented(numSegmentation) = {initialImage(:, :, 1) == typeOfSegmentation(1) & initialImage(:, :, 2) == typeOfSegmentation(2) & initialImage(:, :, 3) == typeOfSegmentation(3)};
    end
    
    imgBlueZoneInit = initialImage(:, :, 1) > blueZoneRange(1, 1) & initialImage(:, :, 2) > blueZoneRange(1, 2) & initialImage(:, :, 3) > blueZoneRange(1, 3);
    imgBlueZoneEnd = initialImage(:, :, 1) < blueZoneRange(2, 1) & initialImage(:, :, 2) < blueZoneRange(2, 2) & initialImage(:, :, 3) < blueZoneRange(2, 3);
    imgSegmented(end+1) = {imgBlueZoneInit & imgBlueZoneEnd};
    
    imgOnlyWhite = initialImage(:, :, 1) == 255 & initialImage(:, :, 2) == 255 & initialImage(:, :, 3) == 255;
    imgNoMarkersNoWhite = ~imgOnlyWhite & ~imgSegmented{1} & ~imgSegmented{2} & ~imgSegmented{3} & ~imgSegmented{4};
end

