
cd163Files = dir('D:\Pablo\Neuroblastoma\Datos\Data\NuevosCasos160\Casos\CD163\Images\**\*.tif');
retFiles = dir('D:\Pablo\Neuroblastoma\Datos\Data\NuevosCasos160\Casos\RET\Images\**\*.tif');


for numCD163File = 1:length(cd163Files)
    cd163ActualFile = cd163Files(numCD163File);
    if contains(cd163ActualFile.name, 'POSITIVAS') % Only positive images
        fileName = strsplit(cd163ActualFile.name, '_');
        caseName = fileName{1};
        actualRETFile = cellfun(@(x) contains(x, caseName) & contains(x, 'CELS') == 0, {retFiles.name});
        
        if sum(actualRETFile) > 0
            actualRETFileName = retFiles(actualRETFile);
            
            retImg = imread(strcat(actualRETFileName.folder, '\', actualRETFileName.name));
            cd163Img = imread(strcat(cd163ActualFile.folder, '\', cd163ActualFile.name));
            
            retImg = retImg(:, :, 1) > 0;
            cd163Img = cd163Img(:, :, 1)  > 0;
            
            % Getting centroids of CD163 img marker
            cd163Centroids = regionprops(cd163Img, 'Centroid');
            cd163Centroids = vertcat(cd163Centroids.Centroid);
            
            % Getting topological info from RET img
            retSkeletonImg = bwskel(retImg);
            reticulineBranchPoints = bwmorph(retSkeletonImg, 'branchpoints');
            
            [x, y] = find(reticulineBranchPoints);
            retBranchesPoints = horzcat(y ,x);
            
            distancesCD163_Ret = pdist2(cd163Centroids, retBranchesPoints);
            
            [minDistancesCD163_Ret, minDistancesCD163_RetPositions] = min(distancesCD163_Ret, [], 2);
            
            %Paint closest distances
            figure;
            imshow(cd163Img)
            hold on;
            imshow(reticulineBranchPoints, colormap('parula'));
            for numCentroidCD163 = 1:size(cd163Centroids, 1)
                retMinPos = minDistancesCD163_RetPositions(numCentroidCD163);
                plot([cd163Centroids(numCentroidCD163, 1) ; reticulineBranchPoints(retMinPos, 1)], [cd163Centroids(numCentroidCD163, 2); reticulineBranchPoints(retMinPos, 2)]);
            end
            
            
            disp('');
            
        else
            warning(strcat('No positive marker for RET ', caseName));
        end
    end
end
