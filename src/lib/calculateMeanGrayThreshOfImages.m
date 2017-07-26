function [ meanGraythresh ] = calculateMeanGrayThreshOfImages( fileNames )
%CALCULATEMEANGRAYTHRESHOFIMAGES Calculate two values of how we can
%binaryize an image
%   We could use any number to binarize an image, but we want the broken
%   parts of a biopsy. So we measure in the first element, how it
%   automatically will binarize the image. And in the second element we
%   store how it will binarize the left-top-corner of the image (that
%   supposely will be the background of the image. Then we output the
%   average of the two.
%
%   Developed by Pablo Vicente-Munuera

    allGraythresh = zeros(size(fileNames, 1), 3);
    parfor numFile = 1:size(fileNames, 1)
        actualImg = rgb2gray(imread(fileNames{numFile}));
        allGraythresh(numFile, :) = [graythresh(actualImg), double(min(min(actualImg(1:100, 1:100)))), double(mean(mean(actualImg(1:100, 1:100))))];
    end
    meanGraythresh = mean(allGraythresh);
end

