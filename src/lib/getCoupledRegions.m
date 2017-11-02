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
    if size(unique(finalHoles(:, 1)), 1) + 1 < size(finalHoles, 1)
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
    finalHoles(1, 5) = {finalHoles{1, 3}.Centroid};
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

            %New Image general for all markers
            finalHoles(numHole, 4) = {imcrop(actualImg, correspondenceOfTheOldImage)};

            newCentroid = regionprops(finalHoles{numHole, 4});
            if size(newCentroid, 1) > 1
                newCentroid = [];
                newCentroid.Centroid = [ypeak / 2, ypeak / 2];
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
    %         close
    %         figure; imshow(imgOfRegion);
    %         close

            finalHoles(numHole, 8) = {double(finalHoles{numHole, 6}) .* imgDistance};

            finalHoles(numHole, 9) = {sum(sum(finalHoles{numHole, 7}))};
            finalHoles(numHole, 10) = {sum(sum(finalHoles{numHole, 8}))};
            finalHoles(numHole, 11) = {finalHoles{numHole, 9} / finalHoles{numHole, 10}};
        catch ex
            disp('Error');
            disp(ex.message)
        end
    end
    
    finalHoles = cell2table(finalHoles);
    finalHoles.Properties.VariableNames = {'Marker', 'NumHole', 'HoleProperties', 'CorrectedImage', 'CorrectedCentroid', 'imgWhereFibreCanFall', 'imgOfRegion', 'imgWhereFibreCanFall_Region', 'fibreArea', 'possibleArea', 'percentageCoveredByFibre', 'HEPA_OR_MACR'};
end

