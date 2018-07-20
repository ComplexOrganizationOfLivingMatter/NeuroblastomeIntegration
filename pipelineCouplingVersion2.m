
cd163Files = dir('D:\Pablo\Neuroblastoma\Datos\Data\NuevosCasos160\Casos\CD163\Images\**\*.tif');
cd163_WithFormsFiles = dir('D:\Pablo\Neuroblastoma\Datos\Data\NuevosCasos160\Casos\CD163\Images_NoSegmented\**\*.tif');
retFiles = dir('D:\Pablo\Neuroblastoma\Datos\Data\NuevosCasos160\Casos\RET\Images\**\*.tif');

casesInfo = {'00B18084'	'High'	'HighRisk'
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

casesInfo2 = {1.0	1.0	1.0	1.0	1	1.0	0.0	0.0
1.0	1.0	1.0	2.0	1	1.0	999.0	1.0
1.0	0.0	1.0	1.0	1	1.0	1.0	0.0
1.0	1.0	1.0	2.0	1	1.0	1.0	0.0
1.0	1.0	1.0	1.0	1	1.0	1.0	1.0
1.0	0.0	1.0	0.0	999	0.0	0.0	0.0
0.0	1.0	1.0	1.0	1	0.0	0.0	1.0
1.0	0.0	0.0	999.0	999	999.0	999.0	0.0
0.0	0.0	1.0	1.0	999	0.0	0.0	0.0
0.0	0.0	1.0	1.0	1	0.0	0.0	0.0
0.0	0.0	1.0	1.0	0	0.0	0.0	0.0
0.0	0.0	1.0	1.0	0	0.0	0.0	0.0
0.0	0.0	1.0	0.0	1	0.0	0.0	0.0
0.0	0.0	1.0	1.0	0	0.0	999.0	0.0
1.0	1.0	1.0	1.0	1	0.0	1.0	1.0
0.0	0.0	1.0	1.0	0	0.0	0.0	0.0
0.0	0.0	1.0	1.0	1	0.0	0.0	0.0
1.0	0.0	1.0	2.0	1	0.0	1.0	0.0
0.0	0.0	1.0	1.0	0	0.0	999.0	0.0
0.0	0.0	1.0	1.0	0	0.0	999.0	0.0
0.0	0.0	1.0	1.0	1	0.0	0.0	0.0
0.0	0.0	1.0	1.0	0	0.0	1.0	0.0
0.0	0.0	1.0	1.0	1	0.0	999.0	0.0
1.0	999.0	1.0	1.0	1	0.0	999.0	0.0
0.0	0.0	1.0	1.0	0	0.0	999.0	0.0
0.0	0.0	1.0	1.0	1	0.0	0.0	0.0
0.0	0.0	0.0	999.0	999	0.0	999.0	999.0
0.0	0.0	1.0	0.0	1	0.0	999.0	0.0
0.0	0.0	1.0	1.0	0	0.0	999.0	0.0
0.0	0.0	1.0	1.0	1	0.0	0.0	0.0
1.0	1.0	1.0	2.0	1	0.0	0.0	1.0
0.0	0.0	1.0	1.0	999	0.0	0.0	999.0
1.0	1.0	1.0	1.0	1	0.0	0.0	1.0
0.0	0.0	1.0	1.0	1	0.0	1.0	1.0
1.0	0.0	1.0	0.0	1	0.0	999.0	999.0
0.0	1.0	1.0	1.0	1	1.0	1.0	0.0
0.0	0.0	1.0	0.0	1	0.0	0.0	0.0
0.0	0.0	1.0	0.0	0	0.0	999.0	0.0
1.0	0.0	0.0	999.0	0	0.0	0.0	0.0
1.0	1.0	1.0	1.0	1	0.0	1.0	1.0
0.0	0.0	1.0	1.0	1	1.0	1.0	0.0
0.0	0.0	1.0	1.0	1	0.0	0.0	0.0
1.0	1.0	1.0	1.0	1	0.0	0.0	1.0
0.0	0.0	1.0	1.0	0	0.0	0.0	0.0
1.0	0.0	1.0	2.0	1	1.0	0.0	0.0
1.0	0.0	1.0	0.0	0	0.0	0.0	0.0
0.0	0.0	1.0	999.0	1	1.0	0.0	1.0
1.0	0.0	1.0	2.0	1	1.0	0.0	1.0
1.0	0.0	1.0	0.0	1	0.0	999.0	0.0
0.0	0.0	1.0	1.0	0	0.0	999.0	0.0
0.0	0.0	1.0	1.0	0	0.0	999.0	0.0
1.0	1.0	1.0	999.0	1	0.0	999.0	1.0
0.0	1.0	1.0	1.0	1	1.0	999.0	0.0
1.0	0.0	1.0	1.0	0	0.0	0.0	0.0
1.0	1.0	1.0	1.0	1	1.0	999.0	0.0
0.0	0.0	1.0	1.0	1	0.0	999.0	0.0
0.0	0.0	1.0	1.0	0	0.0	999.0	0.0
0.0	0.0	1.0	1.0	1	0.0	999.0	0.0
0.0	0.0	1.0	1.0	0	0.0	999.0	0.0
1.0	0.0	1.0	0.0	0	0.0	0.0	0.0
0.0	1.0	1.0	1.0	1	1.0	0.0	1.0
1.0	999.0	0.0	999.0	999	0.0	999.0	999.0
1.0	0.0	0.0	999.0	999	0.0	0.0	999.0
1.0	999.0	1.0	1.0	0	0.0	999.0	0.0
1.0	0.0	1.0	2.0	1	1.0	0.0	0.0
1.0	0.0	0.0	999.0	1	0.0	999.0	0.0
0.0	0.0	1.0	1.0	1	1.0	0.0	0.0
1.0	0.0	1.0	1.0	1	0.0	999.0	0.0
0.0	0.0	1.0	1.0	0	0.0	0.0	0.0
0.0	0.0	1.0	1.0	0	0.0	0.0	0.0
0.0	0.0	1.0	1.0	1	0.0	999.0	0.0
1.0	0.0	0.0	999.0	999	0.0	0.0	999.0
0.0	1.0	1.0	1.0	1	0.0	0.0	1.0
1.0	1.0	1.0	1.0	1	0.0	0.0	1.0
0.0	0.0	1.0	1.0	1	0.0	0.0	1.0
0.0	0.0	1.0	1.0	0	0.0	999.0	0.0
1.0	0.0	1.0	0.0	0	0.0	0.0	0.0
0.0	0.0	1.0	1.0	1	0.0	1.0	0.0
0.0	0.0	1.0	1.0	0	0.0	999.0	0.0
0.0	0.0	1.0	2.0	1	0.0	999.0	0.0
0.0	1.0	0.0	999.0	1	0.0	0.0	999.0
0.0	0.0	1.0	1.0	1	0.0	0.0	0.0
1.0	1.0	1.0	1.0	1	0.0	0.0	0.0
1.0	0.0	1.0	1.0	1	1.0	0.0	0.0
1.0	1.0	1.0	2.0	1	1.0	0.0	0.0
1.0	1.0	1.0	2.0	1	0.0	0.0	0.0
0.0	1.0	1.0	1.0	1	0.0	0.0	1.0
1.0	0.0	1.0	2.0	1	0.0	0.0	1.0
1.0	1.0	0.0	999.0	1	1.0	0.0	1.0
0.0	0.0	1.0	2.0	0	0.0	0.0	0.0
1.0	0.0	1.0	2.0	1	1.0	999.0	0.0   
};

caseInfoExitus = {0.0	0.0
1.0	1.0
0.0	0.0
1.0	0.0
0.0	1.0
0.0	0.0
1.0	1.0
0.0	0.0
0.0	0.0
0.0	0.0
0.0	0.0
0.0	0.0
0.0	0.0
0.0	0.0
1.0	1.0
0.0	0.0
0.0	0.0
1.0	1.0
0.0	0.0
0.0	0.0
0.0	0.0
999	999
0.0	0.0
999	999
1.0	0.0
0.0	0.0
0.0	0.0
0.0	0.0
0.0	0.0
0.0	0.0
999	999
0.0	0.0
1.0	1.0
0.0	0.0
0.0	0.0
999	999
0.0	0.0
0.0	0.0
0.0	0.0
1.0	1.0
0.0	0.0
0.0	0.0
1.0	1.0
0.0	0.0
0.0	1.0
0.0	0.0
1.0	1.0
1.0	1.0
0.0	0.0
0.0	0.0
0.0	0.0
1.0	1.0
1.0	1.0
0.0	0.0
1.0	1.0
0.0	0.0
999	999
0.0	0.0
0.0	0.0
0.0	0.0
1.0	1.0
0.0	0.0
0.0	0.0
999	999
0.0	1.0
999	999
0.0	0.0
0.0	0.0
0.0	0.0
0.0	0.0
0.0	0.0
0.0	0.0
0.0	0.0
0.0	0.0
0.0	0.0
0.0	0.0
0.0	1.0
0.0	0.0
999	999
999	999
0.0	0.0
999	999
1.0	1.0
1.0	1.0
1.0	1.0
0.0	1.0
0.0	1.0
999	999
999	999
1.0	0.0
1.0	1.0};

casesInfo = horzcat(casesInfo, casesInfo2, caseInfoExitus);

thresholdOfDistance = 30;%0.005;

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
            cd163AllInfo = regionprops(cd163Img, 'Centroid');
            cd163Centroids = vertcat(cd163AllInfo.Centroid);
            
            % Getting topological info from RET img
            retSkeletonImg = bwskel(retImg);
            %retSkeletonImg = bwmorph(retImg, 'skel', Inf);
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

            
            results(end+1, 1:6) = horzcat(mean(minDistancesCD163_Ret),std(minDistancesCD163_Ret), mean(sum(distancesCD163_Ret < thresholdOfDistance, 2)), std(sum(distancesCD163_Ret < thresholdOfDistance, 2)), ...
                mean(distancesCD163_Ret(distancesCD163_Ret < thresholdOfDistance)), std(distancesCD163_Ret(distancesCD163_Ret < thresholdOfDistance)));
            
            actualFormOfCD163File = cellfun(@(x) contains(x, caseName) & contains(x, 'POSITIVAS', 'IgnoreCase',true), {cd163_WithFormsFiles.name});
            
            if sum(actualFormOfCD163File) > 0
                
                actualFormOfCD163File = cd163_WithFormsFiles(actualFormOfCD163File);
            
                cd163ImgWithShapes = imread(strcat(actualFormOfCD163File.folder, '\', actualFormOfCD163File.name));
                
                cd163holes1Properties = regionprops(bwconncomp(cd163ImgWithShapes(:, :, 1) == 0, 4), 'all');
                if size(cd163ImgWithShapes, 3) > 3
                    cd163holes2Properties = regionprops(bwconncomp(sum(cd163ImgWithShapes(:, :, 4:end), 3) == 0, 4), 'all');
                    cd163holesProperties = vertcat(cd163holes1Properties, cd163holes2Properties(2:end));
                else
                    cd163holesProperties = cd163holes1Properties;
                end
                
                cd163holesCentroids = vertcat(cd163holesProperties.Centroid);
                closestHole = pdist2(cd163Centroids, cd163holesCentroids);
                [~, positionsClosestHole] = min(closestHole, [], 2);
                
                if length(unique(positionsClosestHole)) ~= size(cd163Centroids, 1)
                    warning('Possible two cells as one')
                    fid = fopen('logFile','a+');
                    % write the error to file
                    % first line: message
                    fprintf(fid,'-------%s----------\r\n', datestr(datetime('now')));
                    fprintf(fid,'Possible cells together not segmented well for CD163: %s\r\n', caseName);

                    % close file
                    fclose(fid);
                end
                
                cd163holesPropertiesTable = struct2table(cd163holesProperties(positionsClosestHole));
                cd163holesPropertiesTable.Properties.VariableNames(2) = {'OldCentroid'};
                cd163AllInfo = horzcat(struct2table(cd163AllInfo), cd163holesPropertiesTable);
                
                % < 0.85  -> star or ellongated
                % > 0.85  -> circle-like or disk
                branchPointsDistanceToStarsLike = distancesCD163_Ret(cd163AllInfo.Solidity < 0.85, :);
                branchPointsDistanceToCircleLike = distancesCD163_Ret(cd163AllInfo.Solidity >= 0.85, :);
                

                results(end, 7:10) = [mean(min(branchPointsDistanceToStarsLike, [], 2)), std(min(branchPointsDistanceToStarsLike, [], 2)), mean(min(branchPointsDistanceToCircleLike, [], 2)), std(min(branchPointsDistanceToCircleLike, [], 2))];
                results(end, 11:12) = [mean(sum(branchPointsDistanceToStarsLike < thresholdOfDistance, 2)), std(sum(branchPointsDistanceToStarsLike < thresholdOfDistance, 2))];
                results(end, 13:14) = [mean(sum(branchPointsDistanceToCircleLike < thresholdOfDistance, 2)), std(sum(branchPointsDistanceToCircleLike < thresholdOfDistance, 2))];
                
            else
                results(end, 7:14) = NaN;
            end
        else
            warning(strcat('No positive marker for RET: ', caseName));
            fid = fopen('logFile','a+');
            % write the error to file
            % first line: message
            fprintf(fid,'-------%s----------\r\n', datestr(datetime('now')));
            fprintf(fid,'%s\r\n', caseName);
            
            % close file
            fclose(fid);
        end
    end
end

resultsTable = horzcat(table(caseNames'), array2table(results));
resultsTable.Properties.VariableNames{1} = 'Case';
resultsTable.Properties.VariableNames{2} = 'MeanMinToClosestBranch';
resultsTable.Properties.VariableNames{3} = 'StdMinToClosestBranch';
resultsTable.Properties.VariableNames{4} = 'MeanNumberOfBranchesCloser';
resultsTable.Properties.VariableNames{5} = 'StdNumberOfBranchesCloser';
resultsTable.Properties.VariableNames{6} = 'MeanDistanceWithinThreshold';
resultsTable.Properties.VariableNames{7} = 'StdDistanceWithinThreshold';
resultsTable.Properties.VariableNames{8} = 'Stars_MeanMinToClosestBranch';
resultsTable.Properties.VariableNames{9} = 'Stars_StdMinToClosestBranch';
resultsTable.Properties.VariableNames{10} = 'Circle_MeanMinToClosestBranch';
resultsTable.Properties.VariableNames{11} = 'Circle_StdMinToClosestBranch';
resultsTable.Properties.VariableNames{12} = 'Stars_MeanNumberOfCloserBranches';
resultsTable.Properties.VariableNames{13} = 'Stars_StdNumberOfCloserBranches';
resultsTable.Properties.VariableNames{14} = 'Circle_MeanNumberOfCloserBranches';
resultsTable.Properties.VariableNames{15} = 'Circle_StdNumberOfCloserBranches';


correspondance = cellfun(@(x) find(contains(resultsTable{:, 1}, x)) , casesInfo(:, 1), 'UniformOutput', false);

casesInfo( cellfun(@(x) isempty(x), correspondance), :) = [];
correspondance( cellfun(@(x) isempty(x), correspondance), :) = [];
correspondance = cell2mat(correspondance);

resultsTable(:, end+1:end+12) = casesInfo(correspondance, 2:13);
% resultsTable.Properties.VariableNames{end-1} = 'Instability';
% resultsTable.Properties.VariableNames{end} = 'RiskCalculated';
% resultsTable = movevars(resultsTable, 'Instability', 'Before', 'MeanMinToClosestBranch');
% resultsTable = movevars(resultsTable, 'RiskCalculated', 'Before', 'MeanMinToClosestBranch');

variableNames = {'Instability', 'RiskCalculated', 'INRG_EDAD', 'INRG_ESTADIO', 'INRG_HistoCat', 'INRG_HistoDif', 'INRG_SCA', 'INRG_MYCN', 'INRG_PLOIDIA', 'INRG_11q', 'NEUPAT_recaida', 'NEUPAT_exitus'};

resultsTable.Properties.VariableNames(end-11:end) = variableNames;

resultsTable.Instability = grp2idx(categorical(resultsTable.Instability, {'VeryLow', 'Low', 'Medium', 'High'}, 'Ordinal', true));
resultsTable.RiskCalculated = grp2idx(categorical(resultsTable.RiskCalculated, {'NoRisk', 'HighRisk'}, 'Ordinal', true));

% NaNs instead of 999
removing999sTable = table2array(resultsTable(:, 18:end));
removing999sTable(removing999sTable == 999) = nan;
resultsTable(:, 18:end) = array2table(removing999sTable);

namesCorrCoef = resultsTable.Properties.VariableNames(2:end);
[resultsCorrCoef, pValuesCorrCoef] = corrcoef(table2array(resultsTable(:, 2:end)), 'Rows', 'pairwise');
tableCorrCoef = array2table(resultsCorrCoef, 'VariableNames', namesCorrCoef, 'RowNames', namesCorrCoef);
tableCorrCoef(1:14,:) = [];
tableCorrCoef = removevars(tableCorrCoef, {'Instability','RiskCalculated','INRG_EDAD','INRG_ESTADIO','INRG_HistoCat','INRG_HistoDif','INRG_SCA','INRG_MYCN','INRG_PLOIDIA','INRG_11q','NEUPAT_recaida','NEUPAT_exitus'});

tablePValuesCorrCoef = array2table(pValuesCorrCoef, 'VariableNames', namesCorrCoef, 'RowNames', namesCorrCoef);
tablePValuesCorrCoef(1:14,:) = [];
tablePValuesCorrCoef = removevars(tablePValuesCorrCoef, {'Instability','RiskCalculated','INRG_EDAD','INRG_ESTADIO','INRG_HistoCat','INRG_HistoDif','INRG_SCA','INRG_MYCN','INRG_PLOIDIA','INRG_11q','NEUPAT_recaida','NEUPAT_exitus'});


for actualIndex = 1:size(tablePValuesCorrCoef, 1)
    toCopyCorrCoef = tableCorrCoef(actualIndex, table2array(tablePValuesCorrCoef(actualIndex, :)) < 0.1)
    toCopyPvalues = tablePValuesCorrCoef(actualIndex, table2array(tablePValuesCorrCoef(actualIndex, :)) < 0.1)
    toCopyPvalues.Properties.VariableNames
end
