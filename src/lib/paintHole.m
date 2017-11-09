function [ ] = paintHole( maskOfImagesByCase, holeOfMarker, axActual )
%PAINTHOLE Summary of this function goes here
%   Detailed explanation goes here
    if isempty(holeOfMarker) == 0
        imgToShow = double(maskOfImagesByCase{1, 1}) * 255;
        boundingBox = round(holeOfMarker.BoundingBox);
        imgToShow(boundingBox(2):boundingBox(2)+boundingBox(4) - 1, boundingBox(1):boundingBox(1)+boundingBox(3) - 1) = (imgToShow(boundingBox(2):boundingBox(2)+boundingBox(4) - 1, boundingBox(1):boundingBox(1)+boundingBox(3) - 1) == 0 & holeOfMarker.Image{1}) * 155;
        imgToShow(maskOfImagesByCase{1, 1} == 1) = 255;
        set(gcf, 'CurrentAxes', axActual)
        hImg = imshow(imgToShow, hot);
        hImg.CDataMapping = 'scale';
    end
end

