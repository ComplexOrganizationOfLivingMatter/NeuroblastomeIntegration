function [ correspondanceBetweenHoles ] = matchHoles( holesOfMarker1, holesOfMarker2, similarHolesProperties, outputDirectory)
%MATCHHOLES Get which holes are the same in two images
%   We want to check if two holes are the same in terms of:
%	 - Distance: They have to be relatively close
%	 - Shape : We do a correlation between them, if any of them can be a
%	 subset of the other.

%     distanceBetweenHoles = pdist2(holesOfMarker1.Centroid, holesOfMarker2.Centroid);
%     closerHoles = distanceBetweenHoles < similarHolesProperties.maxDistanceOfCentroids;
    
    correspondanceBetweenHoles = zeros(size(holesOfMarker1, 1), size(holesOfMarker2, 1));
    
    for numHoleOfMarker1 = 1:size(holesOfMarker1, 1)
        for numHoleOfMarker2 = 1:size(holesOfMarker2, 1)
            holesAreCloseEnough = 0;

            %We interesect if any pixel is at the same location
            pixelsAtTheSameLocation = intersect(holesOfMarker1.PixelList{numHoleOfMarker1}, holesOfMarker2.PixelList{numHoleOfMarker2}, 'rows');

            %if there's any pixels at the same location we do the matching
            if isempty(pixelsAtTheSameLocation)
                %If not we check if the holes are closerEnough
%                 if closerHoles(numHoleOfMarker1, numHoleOfMarker2)
                    distancesOfPixels = pdist2(holesOfMarker1.PixelList{numHoleOfMarker1}, holesOfMarker2.PixelList{numHoleOfMarker2});
                    holesAreCloseEnough = min(min(distancesOfPixels)) < similarHolesProperties.maxDistanceBetweenPixels;
%                 end
            else
                holesAreCloseEnough = 1;
            end

            %if they are close enough we'll try to match them
            if holesAreCloseEnough
                imgOfMarker1 = holesOfMarker1.Image{numHoleOfMarker1};
                imgOfMarker2 = holesOfMarker2.Image{numHoleOfMarker2};
                
                if size(imgOfMarker1, 2) > size(imgOfMarker2, 2) && size(imgOfMarker1, 1) < size(imgOfMarker2, 1)
                    imgOfMarker2(:, size(imgOfMarker2, 2) + 1: size(imgOfMarker1, 2)) = 0;
                end
                
                if size(imgOfMarker1, 2) < size(imgOfMarker2, 2) && size(imgOfMarker1, 1) > size(imgOfMarker2, 1)
                    imgOfMarker2(size(imgOfMarker2, 1) + 1: size(imgOfMarker1, 1), :) = 0;
                end
                
                error = 0;
                try
                    correlationBetweenHoles = normxcorr2(imgOfMarker1, imgOfMarker2);
                catch mexception
                    error = 1;
                    imgOfMarkerAux = imgOfMarker1;
                    imgOfMarker1 = imgOfMarker2;
                    imgOfMarker2 = imgOfMarkerAux;
                    correlationBetweenHoles = normxcorr2(imgOfMarker1, imgOfMarker2);
                end

                %figure, surf(correlationBetweenHoles), shading flat

                maxCorrelation = max(correlationBetweenHoles(:));
                if maxCorrelation > similarHolesProperties.minCorrelation
                    [ypeak, xpeak] = find(correlationBetweenHoles==maxCorrelation);
                    yoffSet = ypeak-size(imgOfMarker1,1);
                    xoffSet = xpeak-size(imgOfMarker1,2);

                    correspondenceOfTheOldImage = [xoffSet+1, yoffSet+1, size(imgOfMarker1,2), size(imgOfMarker1,1)];
                    %imgOfMarker2Cropped = imcrop(imgOfMarker2, correspondenceOfTheOldImage);
                    
                    h = figure;
                    subplot(1,2,1);
                    imshow(insertShape(double(imgOfMarker2),'FilledRectangle', correspondenceOfTheOldImage,'Color','green'));
                    title('Subplot 1: correspondance of the template')
                    
                    subplot(1,2,2);
                    imshow(imgOfMarker1);
                    title('Subplot 2: Template')
                    print(h, strcat('TempResults\', outputDirectory, '\matching_holes_', num2str(numHoleOfMarker1), '_', num2str(numHoleOfMarker2), '.jpg'));
                    
                    if error
                        correspondanceBetweenHoles(numHoleOfMarker2, numHoleOfMarker1) = 1;
                    else
                        correspondanceBetweenHoles(numHoleOfMarker1, numHoleOfMarker2) = 1;
                    end
                end
            end
        end
    end
end

