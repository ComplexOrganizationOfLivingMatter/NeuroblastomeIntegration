function [ closerHoles ] = matchHoles( holesOfMarker1, holesOfMarker2, similarHolesProperties)
%MATCHHOLES Get which holes are the same in two images
%   We want to check if two holes are the same in terms of:
%	 - Distance: They have to be relatively close
%	 - Shape: Min axis, major axis


    distanceBetweenHoles = pdist2(holesOfMarker1.Centroid, holesOfMarker2.Centroid);
    closerHoles = distanceBetweenHoles < similarHolesProperties.maxDistanceOfCentroids;
    
    numHoleOfMarker1 = 1;
    numHoleOfMarker2 = 1;
    
    holesAreCloseEnough = 0;
    
    %We interesect if any pixel is at the same location
    pixelsAtTheSameLocation = intersect(holesOfMarker1.PixelList{numHoleOfMarker1}, holesOfMarker2.PixelList{numHoleOfMarker2}, 'rows');

    %if there's any pixels at the same location we do the matching
    if isempty(pixelsAtTheSameLocation)
        %If not we check if the holes are closerEnough
        if closerHoles(numHoleOfMarker1, numHoleOfMarker2)
            distancesOfPixels = pdist2(holesOfMarker1.PixelList{numHoleOfMarker1}, holesOfMarker2.PixelList{numHoleOfMarker2});
            holesAreCloseEnough = min(min(distancesOfPixels)) < similarHolesProperties.maxDistanceBetweenPixels;
        end
    else
        holesAreCloseEnough = 1;
    end
    
    %if they are close enough we'll try to match them
    if holesAreCloseEnough
        imgOfMarker1 = holesOfMarker1.Image{numHoleOfMarker1};
        imgOfMarker2 = holesOfMarker2.Image{numHoleOfMarker2};

        try
            correlationBetweenHoles = normxcorr2(imgOfMarker1, imgOfMarker2);
        catch mexception
            imgOfMarker2 = holesOfMarker1.Image{numHoleOfMarker1};
            imgOfMarker1 = holesOfMarker2.Image{numHoleOfMarker2};
            correlationBetweenHoles = normxcorr2(imgOfMarker1, imgOfMarker2);
        end
            
        %figure, surf(correlationBetweenHoles), shading flat

        maxCorrelation = max(correlationBetweenHoles(:));
        if maxCorrelation > similarHolesProperties.minCorrelation
            [ypeak, xpeak] = find(correlationBetweenHoles==maxCorrelation);
            yoffSet = ypeak-size(imgOfMarker1,1);
            xoffSet = xpeak-size(imgOfMarker1,2);

            hFig = figure;
            hAx  = axes;
            imshow( imgOfMarker2,'Parent', hAx);
            imrect(hAx, [xoffSet+1, yoffSet+1, size(imgOfMarker1,2), size(imgOfMarker1,1)]);
        end
    end

end

