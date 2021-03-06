function [ ] = analyzeGraphletsDistances(currentPath, marker, typeOfDistance)
%analyzeGraphletsDistances Summary of this function goes here
%   Detailed explanation goes here
    graphletFiles = getAllFiles(currentPath);

    allCharacteristics = [];
    
    for numFile = 1:size(graphletFiles,1)
        
        fullPathGraphlet = graphletFiles{numFile};
        graphletNameSplitted = strsplit(fullPathGraphlet, '\');
        graphletName = graphletNameSplitted(end);
        graphletName = graphletName{1};

        if isempty(strfind(graphletName, typeOfDistance)) == 0
            distanceMatrix = dlmread(fullPathGraphlet, '\t', 1, 1);
            names = importfileNames(fullPathGraphlet);
            namesSplitted = cellfun(@(x) strsplit(x, '/'), names, 'UniformOutput', false);
            namesFinal = cellfun(@(x) x(end), namesSplitted);
            namesFinalMarkerIndices = find(cellfun(@(x) isempty(strfind(lower(x), lower(marker))) == 0, namesFinal));
            
            namesFinal = namesFinal(namesFinalMarkerIndices);
            distanceMatrix = distanceMatrix(namesFinalMarkerIndices, namesFinalMarkerIndices);
            
            originalImagesFilter = cellfun(@(x) isempty(strfind(lower(x), 'contigous')) == 0, namesFinal);
            originalImagesIndices = find(originalImagesFilter);
            
            sortingValue = 0;
            iterationValue = 0;
            mstValue = 0;
            for numOriginalImg = 1:size(originalImagesIndices, 1)
                actualIndex = originalImagesIndices(numOriginalImg);
                actualOriginalImg = namesFinal{actualIndex};
                
                if lower(actualOriginalImg(1)) == 'm' % mst or iteration
                    controlIndices = cellfun(@(x) isempty(strfind(lower(x), 'contigous')) & x(1) == 'm', namesFinal);
                    if strcmpi(actualOriginalImg(1:3), 'mst') % Minimum Spanning Tree
                        mstValue = mean(distanceMatrix(actualIndex, controlIndices));
                    else % Iteration
                        iterationValue = mean(distanceMatrix(actualIndex, controlIndices));
                    end
                else %sorting
                    controlIndices = cellfun(@(x) isempty(strfind(lower(x), 'contigous')) & x(1) == 's', namesFinal);
                    sortingValue = mean(distanceMatrix(actualIndex, controlIndices));
                end
            end
            namePatient = graphletNameSplitted(end-1);
            if isempty(allCharacteristics)
                allCharacteristics = table(namePatient, sortingValue, iterationValue, mstValue);
            else
                allCharacteristics = [allCharacteristics; table(namePatient, sortingValue, iterationValue, mstValue)];
            end
        end
    end

    outputFile = strjoin(graphletNameSplitted(1:end-3), '\');
    writetable(allCharacteristics, strcat(outputFile, '\characteristics_', marker, '_', upper(typeOfDistance),'_', date ,'.xls'));
end

