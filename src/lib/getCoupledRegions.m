function [ finalHoles ] = getCoupledRegions( holes )
%GETCOUPLEDREGIONS Summary of this function goes here
%   Detailed explanation goes here

    allHoles = vertcat(holes{:, 3});
    [~, uniqueHolesIndices] = unique(allHoles.Centroid, 'rows');
    finalHoles = holes(uniqueHolesIndices, :);
    
    %First, we need to check if exist overlapping holes, i.e two holes in
    %one marker that form a bigger one in another marker.
    %At the end, we only should have one region per marker
    if size(unique(finalHoles(:, 1)), 1) < size(finalHoles, 1)
        disp('not yet');
    end
    
    %Second, two holes may have differents size. Calculate the real
    %centroid taking into account that these two holes could represent
    %different areas or more extensive ones.
    correlationBetweenHoles = normxcorr2(imgOfMarker1, imgOfMarker2);
    [ypeak, xpeak] = find(correlationBetweenHoles==maxCorrelation);
    if size(ypeak, 1) > 1
        xpeak = xpeak(1);
        ypeak = ypeak(1);
    end
    yoffSet = ypeak-size(imgOfMarker1,1);
    xoffSet = xpeak-size(imgOfMarker1,2);
    
    %Third, we are going to get the region within the real
    %image corresponding to the holes.
    finalHoles
    
end

