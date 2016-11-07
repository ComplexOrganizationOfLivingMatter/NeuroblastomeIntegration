function [ maskImage ] = generateCircularRoiFromImage( Img, fullPathImage )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    radiusOfCircle = min(size(Img))/2;
    figure
    roiImage = imread(fullPathImage);
    imshow(roiImage);
    h = imellipse(gca, [0 0 radiusOfCircle*2 radiusOfCircle*2]);
    api = iptgetapi(h);

    fcn = getPositionConstraintFcn(h);

    api.setPositionConstraintFcn(fcn);

    maskImage = createMask(h);
    close all
end

