%Developed by Pablo Vicente-Munuera

function [ ] = createNetworkHexagonalGridMeanArea()
    [stat,struc] = fileattrib;
    PathCurrent = struc.Name;
    lee_imagenes = dir(PathCurrent);
    lee_imagenes = lee_imagenes(3:size(lee_imagenes,1))
    for imK = 1:size(lee_imagenes,1)
        if (lee_imagenes(imK).isdir == 0 && (size(strfind(lee_imagenes(imK).name, 'COL'),1) == 1 || size(strfind(lee_imagenes(imK).name, 'CD31'),1) == 1 || size(strfind(lee_imagenes(imK).name, 'RET'),1) == 1 || size(strfind(lee_imagenes(imK).name, 'GAG'),1) == 1))
            lee_imagenes(imK).name
            Img=imread(lee_imagenes(imK).name);
            Img = im2bw(Img, 0.2);
            for numMask = 4:50
                inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
                outputFileName = strcat('Adjacency\adjacencyMatrix', inNameFile(1), 'hexagonalMeanAreaMask', num2str(numMask),'Diamet.mat')
				outputFileNameSif = strcat('visualize\adjacencyMatrix', inNameFile(1), 'hexagonalMeanAreaMask', num2str(numMask),'Diamet.cvs');
				outputFileNameSifComplete = strcat('visualize\adjacencyMatrixComplete', inNameFile(1), 'hexagonalMeanAreaMask', num2str(numMask),'Diamet.cvs');
                if exist(outputFileName{:}, 'file') ~= 2
                    maskName = strcat('..\..\..\..\..\Mascaras\HexagonalMask', num2str(numMask), 'Diamet.mat');
                    mask = importdata(maskName);
                    mask = mask(1:size(Img, 1), 1:size(Img,2));
                    
                    maxHexagons = size(unique(mask(mask>0)),1);

                    v1 = [];
                    v2 = [];
                    classesArea = containers.Map('KeyType','single','ValueType','single');
                    hexagonArea = containers.Map('KeyType','single','ValueType','single');

                    for i = 2:size(Img,1)
                        for j = 2:size(Img,2)

                            if (mask(i,j) ~= 0) %Area of the hexagon itself
                                if hexagonArea.isKey(mask(i,j))
                                    hexagonArea(mask(i,j)) = hexagonArea(mask(i,j)) + 1;
                                else
                                    hexagonArea(mask(i,j)) = 1;
                                end
                                if (Img(i,j) ~= 0) %Area of cells/fibers in the hexagon
                                    if classesArea.isKey(mask(i,j))
                                        classesArea(mask(i,j)) = classesArea(mask(i,j)) + 1;
                                    else
                                        classesArea(mask(i,j)) = 1;
                                    end
                                end
                            elseif (mask(i,j) ==  0 && Img(i,j) ~= 0) %If trasspass the boundary we put an edge
                                %Add to verteces list
                                [vSides] = connectedHexagons(mask, i, j);
                                %%Add it to the vertex list
                                v1 = [v1;vSides(1)];
                                v2 = [v2;vSides(2)];
                                if(size(vSides) == 3)
                                    v1 = [v1;vSides(1)];
                                    v2 = [v2;vSides(3)];
                                    v1 = [v1;vSides(2)];
                                    v2 = [v2;vSides(3)];
                                end
                            end
                        end
                    end

                    classes = unique([v1,v2]);
                    %Creating the Incidence matrix
                    %adjacencyMatrix = zeros(size(classes,1), size(classes,1));
                    adjacencyMatrix = sparse(size(classes,1), size(classes,1));

                    for i = 1:size(v1,1)
                        v1Index = find(classes == v1(i));
                        v2Index = find(classes == v2(i));
                        v1Area = 0;
                        v2Area = 0;
                        if classesArea.isKey(v1(v1Index))
                            v1Area = classesArea(v1(v1Index))/hexagonArea(v1(v1Index));
                        end
                        if classesArea.isKey(v2(v2Index))
                            v2Area = classesArea(v2(v2Index))/hexagonArea(v2(v2Index));
                        end
                        adjacencyMatrix(v1Index, v2Index) = (v1Area + v2Area)/2;
                        adjacencyMatrix(v2Index, v1Index) = (v1Area + v2Area)/2;
                    end
                    
                    adjacencyMatrix = adjacencyMatrix / max(adjacencyMatrix(:));


                    %clear v1 v2 classesArea mask
                    %classesStr = num2str(classes);
                    %file:///C:/Program%20Files/MATLAB/R2014b/help/bioinfo/ref/biograph.html
                    %bg = biograph(adjacencyMatrix, num2str(classes),'ShowArrows','off','ShowWeights','off');
                    [S, C] = graphconncomp(adjacencyMatrix, 'Directed', false);

                    [vCentroidsRows, vCentroidsCols] = GetCentroidOfCluster(mask, C, S);

                    distanceBetweenClusters = pdist([vCentroidsRows', vCentroidsCols'], 'euclidean');

                    adjacencyMatrixComplete = GetConnectedGraphWithMinimumDistances(distanceBetweenClusters ,adjacencyMatrix, C);

                    save(outputFileName{:}, 'adjacencyMatrix', 'adjacencyMatrixComplete', '-v7.3');
                    generateSIFFromAdjacencyMatrix(adjacencyMatrix, outputFileNameSif{:});
					generateSIFFromAdjacencyMatrix(adjacencyMatrixComplete, outputFileNameSifComplete{:});
                    
                    fileID = fopen('percentageOfHexagonsOccupied.txt','a');
                    string = strcat('Percentage of Hexagons occupied:', num2str(size(classes, 1)) ,' of', num2str(maxHexagons) ,' on file ', outputFileName{:});
                    fprintf(fileID,'%s\r\n', string{:});
                    fclose(fileID);
				elseif exist(outputFileNameSif{:}, 'file') ~= 2
					load(outputFileName{:},'-mat')
					generateSIFFromAdjacencyMatrix(adjacencyMatrix, outputFileNameSif{:});
					generateSIFFromAdjacencyMatrix(adjacencyMatrixComplete, outputFileNameSifComplete{:});
                end
            end
        end
    end
end
