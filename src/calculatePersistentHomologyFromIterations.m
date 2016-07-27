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
for imK = 1:size(filesAdjacency,1)
    if (filesAdjacency(imK).isdir == 0 && size(strfind(filesAdjacency(imK).name, 'minimumDistanceClasses'),1) == 1 && size(strfind(lower(filesAdjacency(imK).name), '.mat'),1) == 1 && (size(strfind(filesAdjacency(imK).name, 'COL'),1) == 0 && size(strfind(filesAdjacency(imK).name, 'CD31'),1) == 0 && size(strfind(filesAdjacency(imK).name, 'RET'),1) == 0 && size(strfind(filesAdjacency(imK).name, 'GAG'),1) == 0))

        inNameFile = strsplit(strrep(filesAdjacency(imK).name,' ','_'), '.');
        max_dimension = 2;
        
        load([PathCurrent, '\', filesAdjacency(imK).name]);
        
        adjacencyMatrix = triu(adjacencyMatrix);
        
        nameFileIteration = strsplit(inNameFile{1}, 'It');
        
        if strcmp(nameFileIteration{1}, nameFileAnt) == 0 && strcmp(nameFileAnt, 'p') == 0
            explicitStream.finalizeStream();
            % get persistence algorithm over Z/2Z
            persistence = api.Plex4.getModularSimplicialAlgorithm(max_dimension, 2);
            
            % compute and print the intervals
            intervals1 = persistence.computeIntervals(explicitStream);
            
            % compute and print the intervals annotated with a representative cycle
            intervals2 = persistence.computeAnnotatedIntervals(explicitStream);
            options.max_dimension = max_dimension - 1;
            plot_barcodes(intervals1, options);
        end
        filesAdjacency(imK).name
        
        numIteration = str2num(nameFileIteration{2});
        if numIteration == 1
            for vertex = 1:size(adjacencyMatrix, 1)
                explicitStream.addVertex(vertex - 1);
            end
        end
        for i = 1:size(adjacencyMatrix, 1)
            for j = 2:size(adjacencyMatrix, 2)
                if adjacencyMatrix(i,j) > 0 && i ~= j
                    explicitStream.addElement([i, j], numIteration);
                    for k = 3:size(adjacencyMatrix, 3)
                        if adjacencyMatrix(i,k) > 0 && i ~= k && adjacencyMatrix(j,k) > 0 && j ~= k
                            explicitStream.addElement([i, j, k], numIteration);
                        end
                    end
                end
            end
        end
        
        
        
        
        nameFileAnt = inNameFile{1};
    end
end
explicitStream.finalizeStream();
% get persistence algorithm over Z/2Z
persistence = api.Plex4.getModularSimplicialAlgorithm(max_dimension, 2);

% compute and print the intervals
intervals1 = persistence.computeIntervals(explicitStream);

% compute and print the intervals annotated with a representative cycle
intervals2 = persistence.computeAnnotatedIntervals(explicitStream);
options.max_dimension = max_dimension - 1;
plot_barcodes(intervals1, options);

end
