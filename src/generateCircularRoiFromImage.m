function [ maskImage ] = generateCircularRoiFromImage(fullPathImage, radiusOfEllipse)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    figure
    roiImage = imread(fullPathImage);
    imshow(roiImage);
    h = imellipse(gca, [0 0 radiusOfEllipse(2)*2 radiusOfEllipse(1)*2]);
    api = iptgetapi(h);

    fcn = getPositionConstraintFcn(h);

    api.setPositionConstraintFcn(fcn);

    maskImage = createMask(h);
    close all
end

