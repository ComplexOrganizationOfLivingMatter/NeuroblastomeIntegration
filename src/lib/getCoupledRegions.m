function [ finalHoles ] = getCoupledRegions( holes, maskFiles )
%GETCOUPLEDREGIONS Summary of this function goes here
%   Detailed explanation goes here

    allHoles = vertcat(holes{:, 3});
    [~, uniqueHolesIndices] = unique(allHoles.Centroid, 'rows');
    clearvars allHoles
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
    finalHolesAsTable = vertcat(finalHoles{:, 3});
    [~, indicesPerArea] = sort(finalHolesAsTable.Area);
    finalHoles = finalHoles(indicesPerArea, :);
    basicImage = finalHoles{1, 3}.Image{1};
    
    finalHoles(1, 4) = {basicImage};
    finalHoles(1, 5) = {[finalHoles{1, 3}.Centroid(1) + finalHoles{1, 3}.BoundingBox(1), finalHoles{1, 3}.Centroid(2) + finalHoles{1, 3}.BoundingBox(2)]};
    numHole = 1;
    markerIndex = cellfun(@(x) isempty(strfind(lower(x), lower(finalHoles{numHole, 1}))) == 0, maskFiles);
    img = imread(maskFiles{markerIndex});
    imshow(img)
    hold on
    plot(finalHoles{numHole, 5}(1), finalHoles{numHole, 5}(2), '*')
    close
    
    %Real cropped hole
    for numHole = 2:size(finalHoles, 1)
        actualImg = finalHoles{numHole, 3}.Image{1};
        correlationBetweenHoles = normxcorr2(basicImage, actualImg);
        [ypeak, xpeak] = find(correlationBetweenHoles == max(correlationBetweenHoles(:)));
        if size(ypeak, 1) > 1
            xpeak = xpeak(1);
            ypeak = ypeak(1);
        end
        yoffSet = ypeak-size(basicImage,1);
        xoffSet = xpeak-size(basicImage,2);
        correspondenceOfTheOldImage = [xoffSet+1, yoffSet+1, size(basicImage,2), size(basicImage,1)];
        
        %New Image general for all markers
        finalHoles(numHole, 4) = {imcrop(actualImg, correspondenceOfTheOldImage)};
        
        newCentroid = regionprops(finalHoles{numHole, 4}, 'Centroid');
        %New centroids for all markers
        finalHoles(numHole, 5) = {[newCentroid.Centroid(1) + finalHoles{numHole, 3}.BoundingBox(1) + xoffSet, newCentroid.Centroid(2) + finalHoles{numHole, 3}.BoundingBox(2) + yoffSet]};
        
        markerIndex = cellfun(@(x) isempty(strfind(lower(x), lower(finalHoles{numHole, 1}))) == 0, maskFiles);
        img = imread(maskFiles{markerIndex});
        imshow(img)
        hold on
        plot(finalHoles{numHole, 5}(1), finalHoles{numHole, 5}(2), '*')
        close 
    end
    
    finalHoles = cell2table(finalHoles);
    finalHoles.Properties.VariableNames = {'Marker', 'NumHole', 'HoleProperties', 'CorrectedImage', 'CorrectedCentroid'};
    
    %Third, we are going to get the region within the real
    %image corresponding to the holes.
    
    
    

end

