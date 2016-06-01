function [ vCentroids ] = GetCentroidOfCluster( mask, C, S)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    vCentroids = zeros(S);
    for i = 1:S
       indexesOfClusters = find(C==i);
       rows = [];
       cols = [];
       for index = indexesOfClusters
           [row,col] = find(mask == index)
           rows = [rows; row];
           cols = [cols; col];
       end
       vCentroids = [vCentroids; [mean(rows), mean(col)]];
    end
end

