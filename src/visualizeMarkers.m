function [] = visualizeMarkers(distanceMatrix, nameFiles, markersNames, markersWeWantToShow, algorithm, algorithmWeWantToShow, typeOfGCD)

    [newNames, newMatrix, splittedNames] = removeNaNs(distanceMatrix, nameFiles);
    
    fName = 'E:\Pablo\Neuroblastoma\Results\NetworksInformation.csv';
    fid = fopen(fName,'w');            %# Open the file
    fprintf(fid, 'Case,Core,Positive,Algorithm,Marker,NumIterations, \r\n');
    
    %Plot differences
    for actualCase = 1 %:11
        caseFilter = splittedNames(cell2mat(splittedNames(:,2)) == num2str(actualCase), :);
        if isempty(caseFilter) == 0
            for actualCore = ['A', 'B']
                coreFilter = caseFilter(cell2mat(caseFilter(:,6)) == actualCore, :);
                if isempty(coreFilter) == 0
                    for actualPositive = 0:1
                        positiveFilter = coreFilter(cell2mat(coreFilter(:,5)) == actualPositive, :);
                        if isempty(positiveFilter) == 0
                            for actualAlgorithm = 1:size(algorithmWeWantToShow, 2)
                                algorithmFilter = positiveFilter(ismember(positiveFilter(:, 4), algorithmWeWantToShow(actualAlgorithm)), :);
                                if isempty(algorithmFilter) == 0
                                    for actualMarker = 1:size(markersWeWantToShow, 2)
                                        markerFilter = algorithmFilter(ismember(markersNames(cell2mat(algorithmFilter(:,1))), markersWeWantToShow(actualMarker)), :);
                                        differences = [];
                                        differencesNumIters = [];
                                        vstrThreeMaxNumGraphlets = {};
                                        iters = sort(cell2mat(markerFilter(:,3)));
                                        
                                        for actualIter = 1:size(iters,1)
                                            if actualIter > 1
                                                rowFilteredAnt = markerFilter(cell2mat(markerFilter(:,3)) == iters(actualIter-1), :);
                                                rowFiltered = markerFilter(cell2mat(markerFilter(:,3)) == iters(actualIter), :);
                                                
                                                fileAntSplitted = strsplit(cell2mat(newNames(cell2mat(rowFilteredAnt(7)))), '/');
                                                fileAnt = strcat('E:\Pablo\Neuroblastoma\Results\graphletsCount\Casos\', num2str(actualCase), '\' , fileAntSplitted(4), '.ndump2.sumGraphlets');
                                                fileActualSplitted = strsplit(cell2mat(newNames(cell2mat(rowFiltered(7)))), '/');
                                                fileActual = strcat('E:\Pablo\Neuroblastoma\Results\graphletsCount\Casos\', num2str(actualCase), '\' ,fileActualSplitted(4), '.ndump2.sumGraphlets');
                                                
                                                fAnt = fopen(fileAnt{:}, 'r');
                                                if fAnt ~= -1
                                                    tLineAnt = fgets(fAnt);
                                                    fclose(fAnt);

                                                    fActual = fopen(fileActual{:}, 'r');
                                                    tLineActual = fgets(fActual);
                                                    fclose(fActual);

                                                    tLineAnt = strsplit(tLineAnt);
                                                    tLineActual = strsplit(tLineActual);
                                                    if strcmp(typeOfGCD, 'GCD11')
                                                        numsLineAnt = str2double(tLineAnt(1:11));
                                                        numsLineActual = str2double(tLineActual(1:11));
                                                    else
                                                        numsLineAnt = str2double(tLineAnt(1:73));
                                                        numsLineActual = str2double(tLineActual(1:73));
                                                    end

                                                    differenceGraphlets = abs(numsLineAnt - numsLineActual);
                                                    sortedDifferenceGraphlets = sort(differenceGraphlets, 'descend');
                                                    firstGraphlet = find(differenceGraphlets == sortedDifferenceGraphlets(1), 1);
                                                    differenceGraphlets(firstGraphlet) = 0;
                                                    secondGraphlet = find(differenceGraphlets == sortedDifferenceGraphlets(2), 1);
                                                    differenceGraphlets(secondGraphlet) = 0;
                                                    thirdGraphlet = find(differenceGraphlets == sortedDifferenceGraphlets(3), 1);
                                                    strThreeMaxNumGraphlets = ['NumGraphlets', num2str(cell2mat(rowFilteredAnt(3))),'-', num2str(cell2mat(rowFiltered(3))) ,': ', num2str(firstGraphlet-1), '-', num2str(secondGraphlet-1), '-' , num2str(thirdGraphlet-1)];

                                                    vstrThreeMaxNumGraphlets{end+1} =  strThreeMaxNumGraphlets;
                                                    differences = [differences; newMatrix(cell2mat(rowFilteredAnt(7)), cell2mat(rowFiltered(7)))];
                                                    differencesNumIters = [differencesNumIters; {strcat(num2str(cell2mat(rowFilteredAnt(3))),'-', num2str(cell2mat(rowFiltered(3))))}];
                                                end
                                            end
                                        end
                                        
                                        if size(differences, 1) > 0
                                            nameOutputFile = strcat('Graphlets Case', num2str(actualCase), '-Core', actualCore, '-Positive', num2str(actualPositive), '-Algorithm', algorithmWeWantToShow(actualAlgorithm), '-Marker', markersWeWantToShow(actualMarker));
                                            %csvwrite(strcat(nameOutputFile{:}, '.csv'), vertcat(cell2mat(differencesNumIters)', differences'));
                                            h1 = figure('units','normalized','outerposition',[0 0 1 1], 'Visible', 'off');
                                            b = bar(differences);
                                            annotation(h1, 'textbox', [0.4 0.8 0.1 0.1], 'String', vstrThreeMaxNumGraphlets, 'FitBoxToText', 'on');
                                            set(gca,'xtick', b.XData, 'xticklabel', differencesNumIters);
                                            title(nameOutputFile);
                                            xlabel('Difference between iterations');
                                            ylabel('Distance');
                                            %saveas(h1, strcat(nameOutputFile{:}, '.png'));
                                            close all
                                            if actualAlgorithm == 2
                                                fprintf(fid,'%d,%s,%d,%s,%s,%d,%d,%s,%s\r\n', actualCase, actualCore, actualPositive, cell2mat(algorithmWeWantToShow(actualAlgorithm)), cell2mat(markersWeWantToShow(actualMarker)), size(iters,1), 0, num2str(differences(:)'), vstrThreeMaxNumGraphlets{:});       %# Print the string
                                            else
                                                fprintf(fid,'%d,%s,%d,%s,%s,%d,%d\r\n', actualCase, actualCore, actualPositive, cell2mat(algorithmWeWantToShow(actualAlgorithm)), cell2mat(markersWeWantToShow(actualMarker)), size(iters,1), 0);       %# Print the string
                                            end
                                        else
                                            fprintf(fid,'%d,%s,%d,%s,%s,%d,%d\r\n', actualCase, actualCore, actualPositive, cell2mat(algorithmWeWantToShow(actualAlgorithm)), cell2mat(markersWeWantToShow(actualMarker)), size(iters,1), 0);       %# Print the string
                                        end
                                        
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    fclose(fid);
    
    nameFiles = newNames;    
    points = cmdscale(newMatrix);

    numClasses = size(markersWeWantToShow, 2)+size(algorithmWeWantToShow,2 + 1);
    colors = hsv(size(markersWeWantToShow, 2));
    shapes = {'<','x','h','*','>','p','.','+','s','d','v','^'};
    h = zeros(numClasses, numClasses);
    hfigure = figure('units','normalized','outerposition',[0 0 1 1]);
    hold on;
    for i=1:size(points, 1)
        [markerFile, pacientFile, iterationFile, algorithmFile, boolPositiveFile, core] = splitNameFile(nameFiles{i});
        shapePoint = -1;
        for j = 1:size(algorithmWeWantToShow, 2)
            if strcmp (algorithmFile, algorithmWeWantToShow{j}) == 1
                shapePoint = shapes{j};
                break
            end
            if j == size(algorithmWeWantToShow, 2)
                algorithmFile;
            end
        end
        if shapePoint ~= -1
            for actualMarker = 1:size(markersWeWantToShow, 2)
                if strcmp (markersNames{markerFile}, markersWeWantToShow{actualMarker}) == 1
                    nameFiles{i}
                    h(actualMarker, :) = plot(points(i, 1), points(i, 2), shapePoint, 'color', colors(actualMarker,:));
                    t1 = text(points(i,1), points(i,2), strcat('Pos', num2str(boolPositiveFile) ,'Core', core , num2str(iterationFile)));
                    t1.FontSize = 7;
                    t1.HorizontalAlignment = 'center';
                    t1.VerticalAlignment = 'bottom';
                    break
                end
            end
        end
    end
    %h = round(h);
    for actualMarker = 1:size(markersWeWantToShow, 2)
       h(actualMarker, :) = plot(0,0, 'o', 'color', colors(actualMarker, :), 'MarkerFaceColor', colors(actualMarker, :));
    end
    for numAlgorithm = 1:size(algorithmWeWantToShow,2)
        h(actualMarker + numAlgorithm, :) = plot(0,0, shapes{numAlgorithm}, 'color', 'black');
    end
    hold off;
    hlegend1 = legend(h(:,1), horzcat(markersWeWantToShow, algorithmWeWantToShow));
    saveas(hfigure, strcat('distance', strjoin(markersWeWantToShow, '_') , '-', strjoin(algorithmWeWantToShow, '_'), '.fig'));
    %legend(shapes, algorithm, 'Location','West'); 
end