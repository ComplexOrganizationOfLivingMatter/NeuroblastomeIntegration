function [ output_args ] = matchHoles( holesOfMarker1, holesOfMarker2, similarHolesProperties)
%MATCHHOLES Get which holes are the same in two images
%   We want to check if two holes are the same in terms of:
%	 - Distance: They have to be relatively close
%	 - Shape: Min axis, major axis

	centroidsMarker1 = vertcat(holesOfMarker1.Centroid);
	centroidsMarker2 = vertcat(holesOfMarker2.Centroid);
    distanceBetweenHoles = pdist2(centroidsMarker1, centroidsMarker2);
    closerHoles = distanceBetweenHoles > similarHolesProperties.maxDistanceOfCentroids;

end

