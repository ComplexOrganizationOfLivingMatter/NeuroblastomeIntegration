function [centroidSeeds] = Chose_seeds_positions(xMin, xMax, yMax, numPoints, minDistanceBetweenPoints)

    % Resolve K random values between imin and imax
    if ((xMax-(xMin-1))*(yMax-(xMin-1)) < numPoints)
        fprintf(' Error: Excede el rango\n');
        centroidSeeds = NaN;
        return
    end
    
    centroidSeeds = [];
    t=0:.001:2*pi;
    xInsideCircle = cos(t)*xMax/2 + xMax/2;
    yInsideCircle = sin(t)*yMax/2 + yMax/2;

    %we want to add 'numPoints' number of points
    while size(centroidSeeds, 1) < numPoints

        centroidX = randi([xMin,xMax],1);
        centroidY = randi([xMin,yMax],1);
        newCentroid = [centroidX,centroidY];

        tooCloseToOthers = 0;
        for i=1:size(centroidSeeds,1)
            distance=sqrt(((centroidSeeds(i,1)-centroidX)^2)+((centroidSeeds(i,2)-centroidY)^2));

            if distance <= minDistanceBetweenPoints
                tooCloseToOthers = 1;
            end
        end
        
        %If the centroid is inside the polygon we want it in the good
        %centroids. Also we don't want too close to the others
        if inpolygon(centroidX, centroidY, xInsideCircle, yInsideCircle) && tooCloseToOthers == 0
            centroidSeeds = [centroidSeeds; newCentroid];
        end
    end
    centroidSeeds = centroidSeeds(1:numPoints, :);
end