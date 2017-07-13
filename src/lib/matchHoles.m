function [ output_args ] = matchHoles( holesOfMarker1, holesOfMarker2 )
%MATCHHOLES Get which holes are the same in two images
%   Detailed explanation goes here

	centroidsMarker1 = vertcat(holesOfMarker1.Centroid);
	centroidsMarker2 = vertcat(holesOfMarker2.Centroid);
    distanceBetweenHoles = pdist2(centroidsMarker1, centroidsMarker2);

end

