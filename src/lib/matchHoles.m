function [ ] = matchHoles( holesOfMarker1, holesOfMarker2, similarHolesProperties)
%MATCHHOLES Get which holes are the same in two images
%   We want to check if two holes are the same in terms of:
%	 - Distance: They have to be relatively close
%	 - Shape: Min axis, major axis

    distanceBetweenHoles = pdist2(holesOfMarker1.Centroid, holesOfMarker2.Centroid);
    closerHoles = distanceBetweenHoles < similarHolesProperties.maxDistanceOfCentroids;
    similarHolesInArea = pdist2(holesOfMarker1.Area, holesOfMarker2.Area)

end

