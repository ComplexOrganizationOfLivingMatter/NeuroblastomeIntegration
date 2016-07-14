function [] = visualizeMarkers(distanceMatrix, nameFiles, markersNames, markersWeWantToShow, algorithm, algorithmWeWantToShow)

    rowsWithNaN = find(isnan(distanceMatrix(1,:)));
    splittedNames = {};
    sizeMatrix = size(distanceMatrix,1);
    newMatrix = zeros(sizeMatrix - size(rowsWithNaN, 1), sizeMatrix - size(rowsWithNaN, 1));
    newRow = 1;
    newNames = cell(sizeMatrix - size(rowsWithNaN, 1), 1);
    for row = 1:sizeMatrix
        newCol = 1;

        for col = 1:sizeMatrix
            if row ~= rowsWithNaN && col ~= rowsWithNaN
                %case marker core iteration1 distance
                    
                newMatrix(newRow, newCol) = distanceMatrix(row, col);
                newCol = newCol + 1;
            end
        end
        if row ~= rowsWithNaN
            [markerFile, pacientFile, iterationFile, algorithmFile, boolPositiveFile, core] = splitNameFile(nameFiles{row});
            splittedNames = [splittedNames; {markerFile, pacientFile, iterationFile, algorithmFile, boolPositiveFile, core}];
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
                                        while size(find(cell2mat(markerFilter(:,3)) == iter), 1) == 1
                                            graphletAnt =  markerFilter(cell2mat(markerFilter(:,3)) == iter-1, :);
                                            posGraphletAnt = find(cell2mat(markerFilter(:,3)) == iter-1);
                                            graphlet = markerFilter(cell2mat(markerFilter(:,3)) == iter, :);
                                            posGraphlet = find(cell2mat(markerFilter(:,3)) == iter);
                                            differences = [differences; newMatrix(posGraphletAnt, posGraphlet)];
                                            iter = iter + 1;
                                        end
                                        if size(differences, 1) > 0
                                            h1 = figure;
                                            bar(differences);
                                            nameOutputFile = strcat('Case', num2str(actualCase), '-Core', actualCore, '-Positive', num2str(actualPositive), '-Algorithm', algorithmWeWantToShow(actualAlgorithm), '-Marker', markersWeWantToShow(actualMarker));
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

    numClasses = size(markersWeWantToShow, 2);
    colors = hsv(numClasses);
    shapes = {'<','x','*','o','>','p','.','+','s','d','v','^','h'};
    h = zeros(numClasses, numClasses);
    hfigure = figure;
    hold on;
    for i=1:size(points, 1)
        [markerFile, pacientFile, iterationFile, algorithmFile, boolPositiveFile, core] = splitNameFile(nameFiles{i});
        shapePoint = -1;
        for j = 1:size(algorithmWeWantToShow, 2)
            if size(strfind (algorithmFile, algorithmWeWantToShow{j}), 1) == 1
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
    hold off;
    hlegend1 = legend(h(:,1), markersWeWantToShow);
    %legend(shapes, algorithm, 'Location','West'); 
    
end