function [ correlations ] = correlatingMarkers( markersTable )
%CORRELATINGMARKERS Summary of this function goes here
%   Detailed explanation goes here
    onlyInfo = table2array(markersTable(:, 5:end));
    colNames = markersTable.Properties.VariableNames(5:end);

    [r,p] = corrcoef(onlyInfo, 'rows', 'complete');  % Compute sample correlation and p-values.
    removingOnes = triu(ones(size(p)));
    p(logical(removingOnes)) = 1;
    [row,col] = find(p<0.05);  % Find significant correlations.
    %[row,col]
    correlations = cell(size(row,1), 3);
    for numCorrelation = 1:size(row, 1)
        correlations(numCorrelation, :) = {colNames{row(numCorrelation)}, colNames{col(numCorrelation)}, r(row(numCorrelation), col(numCorrelation))};
    end
end