function [newNames, newMatrix, splittedNames] = removeNaNs(distanceMatrix, nameFiles)
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
end

