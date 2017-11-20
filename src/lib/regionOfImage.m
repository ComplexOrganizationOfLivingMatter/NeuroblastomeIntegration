function [ imgOfRegion ] = regionOfImage( img, radiusOfTheAreaTaken, xCentroid, yCentroid )
%REGIONOFIMAGE Summary of this function goes here
%   Detailed explanation goes here

imgWithCentroid = zeros(size(img));
imgWithCentroid(round(yCentroid), round(xCentroid)) = 1;
imgDistance = bwdist(imgWithCentroid);
imgDistance = imgDistance <= radiusOfTheAreaTaken;
%         figure; imshow(img); hold on; plot(round(finalHoles{numHole, 5}(2)), round(finalHoles{numHole, 5}(1)), 'r*')
imgOfRegion = (double(img)/255) .* imgDistance;

end

