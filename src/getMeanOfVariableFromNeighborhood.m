function [ meanOfVariableWithinNeighborhood ] = getMeanOfVariableFromNeighborhood( variable, distanceMatrix, classes, threshold)
%GETMEANOFVARIABLEFROMNEIGHBORHOOD Summary of this function goes here
%   Detailed explanation goes here
    classes = classes(classes > 0);
    meanOfVariableWithinNeighborhood = zeros(length(classes), 1);
    for i = 1:length(classes)
       neighbours = distanceMatrix(classes(i), :) <= threshold;
       %sum(neighbours)
       meanOfVariableWithinNeighborhood(i) = mean(variable(neighbours));
    end
end

