function [ finalHoles ] = getCoupledRegions( holes )
%GETCOUPLEDREGIONS Summary of this function goes here
%   Detailed explanation goes here

    allHoles = vertcat(holes{:, 3});
    [~, uniqueHolesIndices] = unique(allHoles.Centroid, 'rows');
    finalHoles = holes(uniqueHolesIndices, :);

end

