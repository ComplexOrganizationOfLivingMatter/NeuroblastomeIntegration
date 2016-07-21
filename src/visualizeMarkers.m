function [] = visualizeMarkers(distanceMatrix, nameFiles, markersNames, markersWeWantToShow, algorithm, algorithmWeWantToShow)

    rowsWithNaN = find(isnan(distanceMatrix(1,:)));
    splittedNames = {};
    sizeMatrix = size(distanceMatrix,1);
    newMatrix = zeros(sizeMatrix - size(rowsWithNaN, 2), sizeMatrix - size(rowsWithNaN, 2));
    newRow = 1;
    newNames = cell(sizeMatrix - size(rowsWithNaN, 2), 1);
    for row = 1:sizeMatrix
        newCol = 1;
        for col = 1:sizeMatrix
            if size(rowsWithNaN(row == rowsWithNaN),2) == 0 && size(rowsWithNaN(col == rowsWithNaN), 2) == 0
                newMatrix(newRow, newCol) = distanceMatrix(row, col);
                newCol = newCol + 1;
            end
        end
        if row ~= rowsWithNaN
            [markerFile, pacientFile, iterationFile, algorithmFile, boolPositiveFile, core] = splitNameFile(nameFiles{row});
            splittedNames = [splittedNames; {markerFile, pacientFile, iterationFile, algorithmFile, boolPositiveFile, core, newRow}];
            newNames{newRow} = nameFiles{row};
            newRow = newRow + 1;
        end
    end
    
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
                                        iter = 2;
                                        markerFilter = algorithmFilter(ismember(markersNames(cell2mat(algorithmFilter(:,1))), markersWeWantToShow(actualMarker)), :);
                                        differences = [];
                                        differencesNumIters = [];
                                        iters = sort(cell2mat(markerFilter(:,3)));
                                        for actualIter = 2:size(iters,1)
                                            rowFilteredAnt = markerFilter(cell2mat(markerFilter(:,3)) == iters(actualIter-1), :)
                                            rowFiltered = markerFilter(cell2mat(markerFilter(:,3)) == iters(actualIter), :)

                                            differences = [differences; newMatrix(cell2mat(rowFilteredAnt(7)), cell2mat(rowFiltered(7)))];
                                            differencesNumIters = [differencesNumIters; {strcat(num2str(cell2mat(rowFilteredAnt(3))),'-', num2str(cell2mat(rowFiltered(3))))}];
                                        end
                                        if size(differences, 1) > 0
                                            nameOutputFile = strcat('Case', num2str(actualCase), '-Core', actualCore, '-Positive', num2str(actualPositive), '-Algorithm', algorithmWeWantToShow(actualAlgorithm), '-Marker', markersWeWantToShow(actualMarker))
                                            
                                            h1 = figure('units','normalized','outerposition',[0 0 1 1]);
                                            b = bar(differences);
                                            set(gca,'xtick', b.XData, 'xticklabel', differencesNumIters);
                                            title(nameOutputFile);
                                            saveas(h1, strcat(nameOutputFile{:}, '.png'));
                                            close all
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
                if size(strfind (markersNames{markerFile}, markersWeWantToShow{actualMarker}), 1) == 1
                    nameFiles{i}
                    h(actualMarker, :) = plot(points(i, 1), points(i, 2), shapePoint, 'color', colors(actualMarker,:));
                    t1 = text(points(i,1), points(i,2), strcat('Core', core , num2str(iterationFile)));
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
    h(actualMarker + 1, :) = plot(0,0, 'o', 'color', 'white', 'MarkerFaceColor', 'white');
    for numAlgorithm = 1:size(algorithmWeWantToShow,2)
        h(actualMarker + numAlgorithm + 1, :) = plot(0,0, shapes{numAlgorithm}, 'color', 'white');
    end
    hold off;
    divide = {'-------'};
    hlegend1 = legend(h(:,1), horzcat(markersWeWantToShow, divide, algorithmWeWantToShow));
    hlegend1.TextColor = 'white';
    hlegend1.Color = 'black';
    saveas(hfigure, strcat('distance', strjoin(markersWeWantToShow, '_') , '-', strjoin(algorithmWeWantToShow, '_'), '.fig'));
    %legend(shapes, algorithm, 'Location','West'); 
end