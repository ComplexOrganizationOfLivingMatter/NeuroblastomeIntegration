function [ imgOfRegion, imgDistance ] = regionOfImage( img, radiusOfTheAreaTaken, xCentroid, yCentroid )
%REGIONOFIMAGE Summary of this function goes here
%   Detailed explanation goes here

imgWithCentroid = zeros(size(img));
imgWithCentroid(round(yCentroid), round(xCentroid)) = 1;
imgDistance = bwdist(imgWithCentroid);
imgDistance = imgDistance <= radiusOfTheAreaTaken;
% figure; imshow(img); hold on; plot(round(xCentroid), round(yCentroid), 'r*')
imgOfRegion = ((double(img)/255) .* imgDistance) > 0;

end

