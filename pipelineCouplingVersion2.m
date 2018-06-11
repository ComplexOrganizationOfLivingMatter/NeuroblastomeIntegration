
cd163Files = dir('D:\Pablo\Neuroblastoma\Datos\Data\NuevosCasos160\Casos\CD163\Images\**\*.tif');
retFiles = dir('D:\Pablo\Neuroblastoma\Datos\Data\NuevosCasos160\Casos\RET\Images\**\*.tif');

casesRisk = {'00B18084'	'High'	'HighRisk'
'00B18416'	'High'	'HighRisk'
'01B21578'	'High'	'HighRisk'
'02B08103'	'High'	'HighRisk'
'02B20617'	'High'	'HighRisk'
'04B00051'	''	'NoRisk'
'04B00356'	'Medium'	'NoRisk'
'04B01940'	''	'NoRisk'
'04B03320'	''	'NoRisk'
'04B03964'	'Low'	'NoRisk'
'04B04150'	'VeryLow'	'NoRisk'
'04B05490'	'VeryLow'	'NoRisk'
'04B07005'	'Low'	'NoRisk'
'04B07651'	'VeryLow'	'NoRisk'
'04B08057'	'High'	'HighRisk'
'04B09873'	'VeryLow'	'NoRisk'
'04B10379'	'Low'	'NoRisk'
'04B11947'	'High'	'NoRisk'
'04B00383'	'VeryLow'	'NoRisk'
'05B00556'	'VeryLow'	'NoRisk'
'05B00825'	'Low'	'NoRisk'
'05B00835'	'VeryLow'	'NoRisk'
'05B03756'	'Low'	'NoRisk'
'05B03946'	''	'NoRisk'
'05B05867'	'VeryLow'	'NoRisk'
'05B06560'	'Low'	'NoRisk'
'05B08443'	''	'NoRisk'
'05B09222'	'Low'	'NoRisk'
'05B12938'	'VeryLow'	'NoRisk'
'05B14881'	'Low'	'NoRisk'
'05B16927'	'Medium'	'HighRisk'
'05B17767'	''	'NoRisk'
'05B24845'	'Medium'	'HighRisk'
'06B00069'	'Medium'	'NoRisk'
'06B00134'	'Low'	'NoRisk'
'06B01443'	'Medium'	'HighRisk'
'06B01779'	'Low'	'NoRisk'
'06B05331'	'VeryLow'	'NoRisk'
'06B05411'	'VeryLow'	'NoRisk'
'06B05418'	'Medium'	'HighRisk'
'06B06380'	'Medium'	'HighRisk'
'06B06382'	'Low'	'NoRisk'
'06B06383'	'Medium'	'HighRisk'
'06B06639'	'VeryLow'	'NoRisk'
'06B07014'	'Medium'	'HighRisk'
'06B10032'	'VeryLow'	'NoRisk'
'06B12728'	'High'	'HighRisk'
'06B12729'	'High'	'HighRisk'
'06B19686'	'Low'	'NoRisk'
'06B20558'	'VeryLow'	'NoRisk'
'07B00135'	'VeryLow'	'NoRisk'
'07B00317'	'Medium'	'HighRisk'
'07B01279'	'Medium'	'HighRisk'
'07B02578'	'VeryLow'	'NoRisk'
'07B02644'	'High'	'HighRisk'
'07B03435'	'Low'	'NoRisk'
'07B04839'	'VeryLow'	'NoRisk'
'07B05377'	'Low'	'NoRisk'
'07B05473'	'VeryLow'	'NoRisk'
'07B06459'	'VeryLow'	'NoRisk'
'07B07027'	'High'	'HighRisk'
'07B07615'	''	'NoRisk'
'07B08344'	''	'NoRisk'
'07B10124'	'VeryLow'	'NoRisk'
'07B10505'	'High'	'HighRisk'
'07B11108'	'Low'	'NoRisk'
'07B12190'	'Medium'	'NoRisk'
'07B12410'	'Low'	'NoRisk'
'07B12522'	'VeryLow'	'NoRisk'
'07B13306'	'VeryLow'	'NoRisk'
'07B14162'	'Low'	'NoRisk'
'07B14193'	''	'NoRisk'
'07B14628'	'Medium'	'NoRisk'
'07B17220'	'High'	'HighRisk'
'07B17225'	'Medium'	'NoRisk'
'07B17284'	'VeryLow'	'NoRisk'
'07B17311'	'VeryLow'	'NoRisk'
'07B17329'	'Low'	'NoRisk'
'07B19261'	'VeryLow'	'NoRisk'
'07B19275'	'Low'	'NoRisk'
'07B19436'	'Low'	'NoRisk'
'10B30220'	'High'	'NoRisk'
'11B07120'	'High'	'HighRisk'
'11B14142'	'High'	'HighRisk'
'11B17262'	'High'	'HighRisk'
'12B13476'	'High'	'HighRisk'
'13B29977'	'High'	'NoRisk'
'15B09301'	'High'	'NoRisk'
'15B23112'	'High'	'HighRisk'
'306707'	'VeryLow'	'NoRisk'
'332948'	'High'	'HighRisk'
};

results = [];
caseNames = {};

for numCD163File = 1:length(cd163Files)
    cd163ActualFile = cd163Files(numCD163File);
    if contains(cd163ActualFile.name, 'POSITIVAS') % Only positive images
        fileName = strsplit(cd163ActualFile.name, '_');
        caseName = fileName{1};
        
        if endsWith(caseName, 'B') || endsWith(caseName, 'A') %REGEX
            caseName = caseName(:, 1:end-1);
        end
        
        actualRETFile = cellfun(@(x) contains(x, caseName) & contains(x, 'CELS', 'IgnoreCase',true) == 0, {retFiles.name});
        
        if sum(actualRETFile) > 0
            caseNames(end+1) = {caseName};
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
            
            
        else
            warning(strcat('No positive marker for RET: ', caseName));
            fid = fopen('logFile','a+');
            % write the error to file
            % first line: message
            fprintf(fid,'%s\r\n', caseName);
            
            % close file
            fclose(fid);
        end
    end
end

resultsTable = table(caseNames', results(:, 1), results(:, 2));
resultsTable.Properties.VariableNames{1} = 'Case';
resultsTable.Properties.VariableNames{2} = 'MeanBranches';
resultsTable.Properties.VariableNames{3} = 'StdBranches';

correspondance = cellfun(@(x) find(contains(resultsTable{:, 1}, x)) , casesRisk(:, 1), 'UniformOutput', false);

casesRisk( cellfun(@(x) isempty(x), correspondance), :) = [];
correspondance( cellfun(@(x) isempty(x), correspondance), :) = [];
correspondance = cell2mat(correspondance);

resultsTable(:, end+1:end+2) = casesRisk(correspondance, 2:3);
resultsTable.Properties.VariableNames{4} = 'Instability';
resultsTable.Properties.VariableNames{5} = 'RiskCalculated';
resultsTable = movevars(resultsTable, 'Instability', 'Before', 'MeanBranches');
resultsTable = movevars(resultsTable, 'RiskCalculated', 'Before', 'MeanBranches');