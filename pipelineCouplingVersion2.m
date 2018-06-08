
cd163Files = dir('D:\Pablo\Neuroblastoma\Datos\Data\NuevosCasos160\Casos\CD163\Images\**\*.tif');
retFiles = dir('D:\Pablo\Neuroblastoma\Datos\Data\NuevosCasos160\Casos\RET\Images\**\*.tif');

results = [];
caseNames = {};

for numCD163File = 1:length(cd163Files)
    cd163ActualFile = cd163Files(numCD163File);
    if contains(cd163ActualFile.name, 'POSITIVAS') % Only positive images
        fileName = strsplit(cd163ActualFile.name, '_');
        caseName = fileName{1};
        actualRETFile = cellfun(@(x) contains(x, caseName) & contains(x, 'CELS', 'IgnoreCase',true) == 0, {retFiles.name});
        
        if sum(actualRETFile) > 0
            caseNames(end+1) = {caseName};
            actualRETFileName = retFiles(actualRETFile);
            
            actualRETFileName.folder
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
            retBranchesPoints = horzcat(y, x);
            
            distancesCD163_Ret = pdist2(cd163Centroids, retBranchesPoints);
            
            [minDistancesCD163_Ret, minDistancesCD163_RetPositions] = min(distancesCD163_Ret, [], 2);
            
%             %Paint closest distances
%             figure;
%             composedImg = double(cd163Img)*40;
%             imshow(composedImg, colormap('hot'))
%             hold on;
%             for numCentroidCD163 = 1:size(cd163Centroids, 1)
%                 plot(retBranchesPoints(retMinPos, 1), retBranchesPoints(retMinPos, 2), 'r*');
%                 retMinPos = minDistancesCD163_RetPositions(numCentroidCD163);
%                 plot([cd163Centroids(numCentroidCD163, 1) , retBranchesPoints(retMinPos, 1)], [cd163Centroids(numCentroidCD163, 2), retBranchesPoints(retMinPos, 2)]);
%             end
            
            results(end+1, 1:2) = horzcat(mean(minDistancesCD163_Ret),std(minDistancesCD163_Ret));
            
            disp('');
            
        else
            warning(strcat('No positive marker for RET: ', caseName));
        end
    end
end

resultsTable = table(caseNames', results(:, 1), results(:, 2));
resultsTable.Properties.VariableNames{1} = 'Case';
resultsTable.Properties.VariableNames{2} = 'MeanBranches';
resultsTable.Properties.VariableNames{3} = 'StdBranches';
