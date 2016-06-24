function [ pointCloud ] = generatePointCloudFromImage( Img )
%generatePointCloudFromImage Summary of this function goes here
%   Detailed explanation goes here
    pointCloud = []
    for i = 1:size(Img,1)
        for j = 1:size(Img,2)
            if Img(i,j) > 0
                pointCloud = [pointCloud; i j];
            end
        end
    end
end
