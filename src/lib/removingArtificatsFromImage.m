function [ newMask, boundingBox] = removingArtificatsFromImage(originalImage, marker)
%REMOVINGARTIFICATSFROMIMAGE Summary of this function goes here
%   Detailed explanation goes here
    originalImgGray = rgb2gray(originalImage);
    load('supplementaryData\meanOfGraythreshPerMarker_VTN_COL_VasosSanguineos_RET_GAGs_LymphaticVessels.mat')
%     switch marker
%         case 'Vitronectine'
%             imgBin = originalImgGray >= 255;
%         case 'COLAGENO'
%             %If you use only the graythresh of all the image, it will add
%             %too many holes.
%             %imgBin = im2bw(originalImgGray, 0.7*meanOfGraythreshPerMarker(2, 1) + 0.3*meanOfGraythreshPerMarker(2, 2));
%             imgBin = im2bw(originalImgGray, 0.7*meanOfGraythreshPerMarker(2, 1) + 0.3*meanOfGraythreshPerMarker(2, 2));
%         case 'VasosSanguineos'
%             %imgBin = im2bw(originalImgGray, 0.3*meanOfGraythreshPerMarker(3, 1) + 0.7*meanOfGraythreshPerMarker(3, 2));
%         case 'RET'
%             %imgBin = im2bw(originalImgGray, 0.1*meanOfGraythreshPerMarker(4, 1) + 0.9*meanOfGraythreshPerMarker(4, 2));
%         case 'GAGs'
%             %imgBin = im2bw(originalImgGray, 0.3*meanOfGraythreshPerMarker(5, 1) + 0.7*meanOfGraythreshPerMarker(5, 2));
%         case 'LymphaticVessels'
%             %imgBin = im2bw(originalImgGray, min(min(originalImgGray(1:100, 1:100))));
%             imgBin = originalImgGray >= mean(meanOfGraythreshPerMarker(6, 2:3));
%         otherwise
%             ME = MException('MyComponent:noMarkerFound', ...
%                 'Marker %s not found', marker);
%             throw(ME)
%     end
    imgBin = originalImgGray >= mean(meanOfGraythreshPerMarker(6, 2:3));
    imgBin = logical(1-imgBin);
   
    maskOfBiopsy = 1 - bwareaopen(logical(1 - imgBin), 1000000);
    [ maskImage2, boundingBox ] = createEllipsoidalMaskFromImage(imgBin, maskOfBiopsy);
    
    imgBin(maskImage2 == 0) = 1;
    %imshow(imgBin)
    
    imgBinDilated = imdilate(imgBin, strel('disk', 20));
    %figure;
    %imshow(imgBinDilated);
    %The holes we want to eliminate but dilated
    [pixelsXOfGoodAreas, pixelsYOfGoodAreas] = find(1 - imgBinDilated);
    %
    goodHoles = regionprops(logical(1 - imgBinDilated), 'PixelList');
    %All the holes
    segmentedAreasReal = regionprops(logical(1 - imgBin), 'PixelList');
    allHolePixels = {segmentedAreasReal.PixelList};
    
    finalRemovableAreas = [];
    
    %The next code replace this one:
    %finalRemovableAreas = cellfun(@(x) sum(ismember([pixelsYOfGoodAreas, pixelsXOfGoodAreas], x, 'rows')) > 0, allHolePixels);
    % It improves the efficiency a lot.
    for numGoodHoles = 1:size(goodHoles, 1)
        pixelsGoodHoles = goodHoles(numGoodHoles).PixelList;
        for numAllHoles = 1:size(allHolePixels, 2)
            %We only need one pixel to check if the holes is the same,
            %because it will only have the same area but shrinken
            if ismember(pixelsGoodHoles(1, :), allHolePixels{numAllHoles}, 'rows')
                finalRemovableAreas(end+1) = numAllHoles;
                break
            end
        end
    end
    
    pixelsToRemoveFromMask = vertcat(segmentedAreasReal(unique(finalRemovableAreas)).PixelList);
    pixelsToRemoveFromMask = fliplr(pixelsToRemoveFromMask);
    newMask = maskImage2;
    %Remove the pixels of the big holes
    for numRow = 1:size(pixelsToRemoveFromMask, 1)
        newMask(pixelsToRemoveFromMask(numRow, 1), pixelsToRemoveFromMask(numRow, 2)) = 0;
    end
    newMask;
end

