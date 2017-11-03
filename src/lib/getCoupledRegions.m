function [ finalHoles ] = getCoupledRegions( holes, maskFiles, radiusOfTheAreaTaken, maskOfImagesByCase )
%GETCOUPLEDREGIONS Summary of this function goes here
%   Detailed explanation goes here

    allHoles = vertcat(holes{:, 3});
    [~, uniqueHolesIndices] = unique(allHoles.Centroid, 'rows');
    clearvars allHoles
    finalHoles = holes(uniqueHolesIndices, :);
    vtnHoles = cellfun(@(x) isempty(strfind(x, 'Vitronectine')) == 0, finalHoles(:, 1));
    if any(vtnHoles)
        finalHoles(end+1, :) = finalHoles(vtnHoles, :);
        finalHoles(vtnHoles, 12) = {'MACR'};
        finalHoles(end, 12) = {'HEPA'};
    else
        finalHoles(:, 12) = {[]};
    end
    
    %First, we need to check if exist overlapping holes, i.e two holes in
    %one marker that form a bigger one in another marker.
    %At the end, we only should have one region per marker
    
    % The results of this will be a table with all the necessary info of
    % the unified holes. For example, the mean will be the total area of
    % all the holes.
    uniqueMarkers = unique(finalHoles(:, 1));
    if size(uniqueMarkers, 1) + 1 < size(finalHoles, 1)
        for numMarker = 1:size(uniqueMarkers, 1)
            duplicatedMarkers = ismember(finalHoles(:, 1), uniqueMarkers(numMarker));
            if sum(duplicatedMarkers) > 1
                duplicatedHoles = finalHoles(duplicatedMarkers, :);
                indicesOfDuplicated = find(duplicatedMarkers);
                % Unifying info
                finalHoles(indicesOfDuplicated(1), 2) = {horzcat(finalHoles{duplicatedMarkers, 2})};
                newHolesInfo = vertcat(finalHoles{duplicatedMarkers, 3});
                
                
                %Create an image with the duplicated holes
                allPixels = newHolesInfo.PixelList;
                allPixels = vertcat(allPixels{:});
                
                allPixelsIds = newHolesInfo.PixelIdxList;
                allPixelsIds = vertcat(allPixelsIds{:});
                
                [~, index] = ismember(duplicatedHoles(1, 1), maskOfImagesByCase(:, 3));
                
                newImgWithAllHoles = zeros(size(maskOfImagesByCase{index, 1}));
                newImgWithAllHoles(allPixelsIds) = 1;
                
                %Create a new centroid with all the holes
                %It is ponderated by its area
                totalAreaOfHoles = sum(newHolesInfo.Area);
                areasOfHolesPonderated = newHolesInfo.Area / totalAreaOfHoles;
                centroidsPonderated = newHolesInfo.Centroid .* repmat(areasOfHolesPonderated, 1, 2);
                newCentroids = sum(centroidsPonderated);
                
                % We only get a row and transform it into a mean of holes
                newHolesInfo = newHolesInfo(1, :);
                
                %Add new info
                % - Centroid
                newHolesInfo.Centroid(1, :) = newCentroids;
                % - Area
                newHolesInfo.Area(1) = totalAreaOfHoles;
                % - Img: with all the holes
                newHolesInfo.Image(1) = {newImgWithAllHoles};
                % - Bounding box
                newBBox = zeros(1, 4);
                newBBox([1 2]) = min(allPixels);
                newBBox([3 4]) = max(allPixels) - min(allPixels);
                newHolesInfo.BoundingBox(1, :) = newBBox;
                newHolesInfo.MajorAxisLength(1) = 0;
                newHolesInfo.MinorAxisLength(1) = 0;
                newHolesInfo.Eccentricity(1) = 0;
                newHolesInfo.Orientation(1) = -0;
                newHolesInfo.ConvexHull{1} = {};
                newHolesInfo.ConvexImage{1} = {};
                newHolesInfo.ConvexArea(1) = 0;
                newHolesInfo.FilledImage{1} = {};
                newHolesInfo.FilledArea(1) = 0;
                newHolesInfo.EulerNumber(1) = 0;
                newHolesInfo.PixelIdxList{1} = {};
                newHolesInfo.Perimeter(1) = 0;
                newHolesInfo.PerimeterOld(1) = 0;
                newHolesInfo.Extent(1) = 0;
                newHolesInfo.Solidity(1) = 0;
                newHolesInfo.EquivDiameter(1) = 0;
                newHolesInfo.Extrema{1} = {};
                % - Pixel list
                [x, y] = find(newImgWithAllHoles);
                newHolesInfo.PixelList{1} = {[x, y]};
                
                finalHoles(indicesOfDuplicated(1), 3) = {newHolesInfo};
                
                finalHoles(indicesOfDuplicated(2:end), :) = [];
            end
        end
    end
    
    %Second, two holes may have differents size. Calculate the real
    %centroid taking into account that these two holes could represent
    %different areas or more extensive ones.
    finalHolesAsTable = vertcat(finalHoles{:, 3});
    [~, indicesPerArea] = sort(finalHolesAsTable.Area);
    finalHoles = finalHoles(indicesPerArea, :);
    basicImage = finalHoles{1, 3}.Image{1};
    
    finalHoles(1, 4) = {basicImage};
    finalHoles(1, 5) = {finalHoles{1, 3}.Centroid(1)};
%     numHole = 1;
%     markerIndex = cellfun(@(x) isempty(strfind(lower(x), lower(finalHoles{numHole, 1}))) == 0, maskFiles);
%     marker = maskFiles{markerIndex};
%     img = imread(marker);
%     imshow(img)
%     hold on
%     plot(finalHoles{numHole, 5}(1), finalHoles{numHole, 5}(2), '*')
%     close
    
    %Real cropped hole
    for numHole = 1:size(finalHoles, 1)
        actualImg = finalHoles{numHole, 3}.Image{1};
        
        try
            correlationBetweenHoles = normxcorr2(basicImage, actualImg);

            [ypeak, xpeak] = find(correlationBetweenHoles == max(correlationBetweenHoles(:)));
            if size(ypeak, 1) > 1
                xpeak = xpeak(1);
                ypeak = ypeak(1);
            end
            yoffSet = ypeak-size(basicImage,1);
            xoffSet = xpeak-size(basicImage,2);
            correspondenceOfTheOldImage = [xoffSet+1, yoffSet+1, size(basicImage,2), size(basicImage,1)];
        catch ex
            disp('Error');
            disp(ex.message)
            correspondenceOfTheOldImage = [1, 1, size(actualImg,2), size(actualImg,1)];
            ypeak = size(actualImg, 1);
            xpeak = size(actualImg, 2);
            yoffSet = 1;
            xoffSet = 1;
        end
        
        %New Image general for all markers
        finalHoles(numHole, 4) = {imcrop(actualImg, correspondenceOfTheOldImage)};
        
        newCentroid = regionprops(finalHoles{numHole, 4});
        if size(newCentroid, 1) > 1
            newCentroid = [];
            newCentroid.Centroid = [ypeak / 2, xpeak / 2];
        end
        %New centroids for all markers
        finalHoles(numHole, 5) = {[newCentroid.Centroid(1) + finalHoles{numHole, 3}.BoundingBox(1) + xoffSet, newCentroid.Centroid(2) + finalHoles{numHole, 3}.BoundingBox(2) + yoffSet]};
        
        markerIndex = cellfun(@(x) isempty(strfind(lower(x), lower(finalHoles{numHole, 1}))) == 0, maskFiles);
        if sum(markerIndex) > 1
            markerIndex = cellfun(@(x) isempty(strfind(lower(x), lower(finalHoles{numHole, 1}))) == 0 & isempty(strfind(lower(x), lower(finalHoles{numHole, 12}))) == 0 , maskFiles);
        end
        
        img = imread(maskFiles{markerIndex});
        img = img(:, :, 1);
        imgWithCentroid = zeros(size(img));
        imgWithCentroid(round(finalHoles{numHole, 5}(2)), round(finalHoles{numHole, 5}(1))) = 1;
        imgDistance = bwdist(imgWithCentroid);
        imgDistance = imgDistance <= radiusOfTheAreaTaken;
        imgOfRegion = (double(img)/255) .* imgDistance;
        
        % IMPORTANT: GET INFO OF BIOPSY TAKING INTO ACCOUNT THE HOLES.
        % Third, we are going to get the region within the real
        % image corresponding to the holes.
        % There may be areas with big holes and it really couldn't contain
        % any fibre. Therefore, we should ponderate in someway whether or
        % not we could find much fibre within the are.
        
        %Col 6: imgWhereFibreCanFall
        [in, index] = ismember(finalHoles(numHole, 1), maskOfImagesByCase(:, 3));
        if any(in)
            finalHoles(numHole, 6) = {imresize(maskOfImagesByCase{index, 1}, size(imgDistance), 'nearest')};
        end
        
        %Col 7: img of region
        finalHoles(numHole, 7) = {imgOfRegion};
        
%         figure; imshow(insertShape(img, 'circle', [finalHoles{numHole, 5}(1), finalHoles{numHole, 5}(2) radiusOfTheAreaTaken], 'LineWidth', 5));
%         %close
%         figure; imshow(imgOfRegion);
%         %close
        
        finalHoles(numHole, 8) = {double(finalHoles{numHole, 6}) .* imgDistance};
        
        finalHoles(numHole, 9) = {sum(sum(finalHoles{numHole, 7}))};
        finalHoles(numHole, 10) = {sum(sum(finalHoles{numHole, 8}))};
        finalHoles(numHole, 11) = {finalHoles{numHole, 9} / finalHoles{numHole, 10}};
        
    end
    
    finalHoles = cell2table(finalHoles);
    finalHoles.Properties.VariableNames = {'Marker', 'NumHole', 'HoleProperties', 'CorrectedImage', 'CorrectedCentroid', 'imgWhereFibreCanFall', 'imgOfRegion', 'imgWhereFibreCanFall_Region', 'fibreArea', 'possibleArea', 'percentageCoveredByFibre', 'HEPA_OR_MACR'};
end

