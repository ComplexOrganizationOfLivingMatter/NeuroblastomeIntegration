function [ erodedImg ] = reduceDatasetViaClosure( rawImg, sizeOfStrel )
%REDUCEDATASETVIACLOSURE Summary of this function goes here
%   Detailed explanation goes here
%
%   Developed by Pablo Vicente-Munuera
    structuralElement = strel('disk', sizeOfStrel);
    dilatatedImg = imdilate(rawImg, structuralElement);
    erodedImg = imerode(dilatatedImg, structuralElement);
end

