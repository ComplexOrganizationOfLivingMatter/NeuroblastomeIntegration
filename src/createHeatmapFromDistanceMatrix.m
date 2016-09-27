function [] = createHeatmapFromDistanceMatrix( distanceMatrix, nameFiles, markersNames, markersWeWantToShow, algorithm, algorithmWeWantToShow )
%CREATEHEATMAPFROMDISTANCEMATRIX Summary of this function goes here
%   Detailed explanation goes here
    %sortedNameFiles = sort(nameFiles);
    [newNames, newMatrix, splittedNames] = removeNaNs(distanceMatrix, nameFiles);
 
    splittedNamesDataset = cell2dataset([{'Marker', 'Case', 'Iteration', 'Algorithm', 'Positive', 'Core', 'MatrixPosition'}; splittedNames]);
    
        newOrder = zeros(size(distanceMatrix, 1), 1);
        actualRow = 1;
        for actualAlgorithm = 1:size(algorithmWeWantToShow, 2)
            algorithmFilter = splittedNamesDataset(ismember(splittedNamesDataset.Algorithm, algorithmWeWantToShow(actualAlgorithm)), :);
            if isempty(algorithmFilter) == 0
                cases = unique(algorithmFilter.Case);
                for actualCase = 1:size(cases, 1)
                    caseFilter = algorithmFilter(ismember(algorithmFilter.Case, cases(actualCase)), :);
                    if isempty(caseFilter) == 0
                        for actualMarker = 1:size(markersWeWantToShow, 2)
                            %markerFilter = caseFilter(ismember(markersNames(caseFilter.Marker), markersWeWantToShow(actualMarker)), :);
                            markerFilter = caseFilter;
                            if isempty(markerFilter) == 0
                                for actualPositive = [1, 0]
                                    positiveFilter = markerFilter(markerFilter.Positive == actualPositive, :);
                                    if isempty(positiveFilter) == 0
                                        for actualCore = ['A', 'B']
                                            coreFilter = positiveFilter(ismember(positiveFilter.Core, actualCore), :);
                                            if isempty(coreFilter) == 0
                                                iters = sort(coreFilter.Iteration);
                                                for actualIter = 1:size(iters,1)
                                                    if actualAlgorithm == 1
                                                            newOrder(actualRow) = coreFilter(coreFilter.Iteration == iters(actualIter), :).MatrixPosition;
                                                            actualRow = actualRow + 1;
                                                    else
                                                        newOrder(actualRow) = coreFilter(coreFilter.Iteration == iters(actualIter), :).MatrixPosition;
                                                        actualRow = actualRow + 1;
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
            end
        end
    
    %HeatMap(distanceMatrixFiltered);
    
    h1 = figure('units','normalized','outerposition',[0 0 1 1]);
    newOrder = newOrder(newOrder ~= 0);
    newNamesSorted = {};
    distanceMatrixFiltered = zeros(size(newOrder,1), size(newOrder,1));
    XInit = 0.282949790794979;
    YInit = 0.11+0.8150;
    XWidthPerSquare = 0.85/2/size(newOrder,1);
    YWidthPerSquare = 0.8150/size(newOrder,1);
    nameFinalAnt = splittedNamesDataset(splittedNamesDataset.MatrixPosition == newOrder(1), :);
    YAnt = YInit;
    XAnt = XInit;
    numberOfImages = 0;
    for row = 1:size(newOrder,1)
       for col = 1:size(newOrder,1)
           distanceMatrixFiltered(row, col) = newMatrix(newOrder(row), newOrder(col));
       end
       nameFinal = splittedNamesDataset(splittedNamesDataset.MatrixPosition == newOrder(row), :);
       
       if nameFinal.Positive == 1
           newNamesSorted{end+1} = cell2mat(strcat(nameFinal.Case, nameFinal.Marker, nameFinal.Core, '+', num2str(nameFinal.Iteration)));
       else
           newNamesSorted{end+1} = cell2mat(strcat(nameFinal.Case, nameFinal.Marker, nameFinal.Core, '-', num2str(nameFinal.Iteration)));
       end
       if ismember(nameFinal.Case, nameFinalAnt.Case) == 0
           annotation(h1,'rectangle', [XInit YAnt-(YWidthPerSquare*numberOfImages) XWidthPerSquare*size(newOrder,1) YWidthPerSquare*numberOfImages], 'Color','white'); %Horizontally
           
           annotation(h1,'rectangle', [XAnt 0.11 XWidthPerSquare*numberOfImages YWidthPerSquare*size(newOrder,1)], 'Color','white'); %Vertically
           YAnt = YAnt-(YWidthPerSquare*numberOfImages);
           XAnt = XAnt+(XWidthPerSquare*numberOfImages);
           numberOfImages = 1;
       else
           numberOfImages = numberOfImages + 1;
       end
       
       nameFinalAnt = nameFinal;
    end
    %annotation(h1,'rectangle', [XInit
    %YAnt-(YWidthPerSquare*numberOfImages) XWidthPerSquare*size(newOrder,1)
    %YWidthPerSquare*numberOfImages], 'Color','red'); %Gray
    
    heatmap = (distanceMatrixFiltered/max(newMatrix(:)))*64;
    image(heatmap);
    %colormap('gray');
    %colormap('pink');
    axis image
    colorbar

    title(strcat('Distance between graphlets of algorithm',': ' ,algorithmWeWantToShow));
    set(gca,'YTick', [1:size(newNamesSorted,2)], 'YTickLabel', newNamesSorted, 'FontSize', 6);
    set(gca,'XTick', [1:size(newNamesSorted,2)], 'XTickLabel', newNamesSorted, 'XTickLabelRotation', 90.0);
    
    namefile = strcat('heatmapGraphlets_', strjoin(algorithmWeWantToShow, '-'), '_', strjoin(markersWeWantToShow, '-'));
    %saveas(h1, namefile{:});
    export_fig(h1, namefile, '-png', '-a4', '-m1.5');
end

