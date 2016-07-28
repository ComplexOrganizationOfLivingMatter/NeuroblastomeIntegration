function [ ] = calculatePersistentHomologyFromIterations(PathCurrent)
%calculatePersistentHomology
%
%
%   Developed by Pablo Vicente-Munuera
%   Helped by Maria Jose Jimenez
load_javaplex
filesAdjacency = dir(PathCurrent);
filesAdjacency = filesAdjacency(3:size(filesAdjacency,1)-2)

explicitStream = api.Plex4.createExplicitSimplexStream();
nameFileAnt = 'p';
max_dimension = 2;
for imK = 1:size(filesAdjacency,1)
    if (filesAdjacency(imK).isdir == 0 && size(strfind(filesAdjacency(imK).name, 'minimumDistanceClasses'),1) == 1 && size(strfind(lower(filesAdjacency(imK).name), 'posi'),1) == 1 && (size(strfind(filesAdjacency(imK).name, 'COL'),1) == 0 && size(strfind(filesAdjacency(imK).name, 'CD31'),1) == 0 && size(strfind(filesAdjacency(imK).name, 'RET'),1) == 0 && size(strfind(filesAdjacency(imK).name, 'GAG'),1) == 0))

        inNameFile = strsplit(strrep(filesAdjacency(imK).name,' ','_'), '.');
        
        load([PathCurrent, '\', filesAdjacency(imK).name]);
        
        adjacencyMatrix = triu(adjacencyMatrix);
        
        nameFileIteration = strsplit(inNameFile{1}, 'It');
        
        if strcmp(nameFileIteration{1}, nameFileAnt) == 0 && strcmp(nameFileAnt, 'p') == 0
            explicitStream = finishStreamAndSavePlot(explicitStream, max_dimension, nameFileAnt);
        end
        filesAdjacency(imK).name
        
        numIteration = str2num(nameFileIteration{2});
        if numIteration == 1
            explicitStream = api.Plex4.createExplicitSimplexStream();
            for vertex = 1:size(adjacencyMatrix, 1)
                explicitStream.addVertex(vertex - 1);
            end
        end
        for i = 1:size(adjacencyMatrix, 1)
            for j = 2:size(adjacencyMatrix, 2)
                if adjacencyMatrix(i,j) > 0 && i ~= j
                    explicitStream.addElement([i-1, j-1], numIteration);
                    for k = 3:size(adjacencyMatrix, 3)
                        if adjacencyMatrix(i,k) > 0 && i ~= k && adjacencyMatrix(j,k) > 0 && j ~= k
                            explicitStream.addElement([i-1, j-1, k-1], numIteration + 0.5);
                        end
                    end
                end
            end
        end

        nameFileAnt = nameFileIteration{1};
    end
end

finishStreamAndSavePlot(explicitStream, max_dimension, nameFileAnt);

end

function [explicitStream] = finishStreamAndSavePlot(explicitStream, max_dimension, nameFile)

load_javaplex

explicitStream.finalizeStream();
% get persistence algorithm over Z/2Z
persistence = api.Plex4.getModularSimplicialAlgorithm(max_dimension, 2);

% compute and print the intervals
intervals1 = persistence.computeIntervals(explicitStream);

% compute and print the intervals annotated with a representative cycle
intervals2 = persistence.computeAnnotatedIntervals(explicitStream);
options.max_dimension = max_dimension - 1;
options.filename = nameFile;
plot_barcodes(intervals1, options);
close all

end
