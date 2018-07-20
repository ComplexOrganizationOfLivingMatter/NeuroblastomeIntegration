function [ maskImage2, boundingBox ] = createEllipsoidalMaskFromImage(originalBinImage, maskOfBiopsy)
%CREATEELLIPSOIDALMASKFROMIMAGE Summary of this function goes here
%   Detailed explanation goes here
    boundingBox = regionprops(maskOfBiopsy, 'BoundingBox');
    
    boundingBox = boundingBox.BoundingBox;
    hFig = figure('Visible', 'on');
    imagesc(originalBinImage);
    h = imellipse(gca, boundingBox);
    api = iptgetapi(h);

    fcn = getPositionConstraintFcn(h);

    api.setPositionConstraintFcn(fcn);

    maskImage2 = createMask(h);
    close(hFig)

end

