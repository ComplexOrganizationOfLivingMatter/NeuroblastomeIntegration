%Developed by Pablo Vicente-Munuera

function [ ] = createNetworkHexagonalGridSharedSide()
    [stat,struc] = fileattrib;
    PathCurrent = struc.Name;
    lee_imagenes = dir(PathCurrent);
    lee_imagenes = lee_imagenes(3:size(lee_imagenes,1))
    for imK = 1:size(lee_imagenes,1)
        if (lee_imagenes(imK).isdir == 0 && size(strfind(lee_imagenes(imK).name, 'negativ'),1) == 0)
            lee_imagenes(imK).name
            Img=imread(lee_imagenes(imK).name);
            Img = im2bw(Img, 0.2);
            for numMask = 2:50
                maskName = strcat('..\..\..\..\..\Mascaras\HexagonalMask', num2str(numMask), 'Diamet.mat');
                mask = importdata(maskName);

                v1 = [];
                v2 = [];
                classesArea = containers.Map('KeyType','single','ValueType','single');
                hexagonArea = containers.Map('KeyType','single','ValueType','single');

                for i = 2:size(Img,1)
                    for j = 2:size(Img,2)
						if (mask(i,j) ==  0 && Img(i,j) ~= 0) %If trasspass the boundary we put an edge
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
				maxSharedSide = max(adjacencyMatrix(:));
                for i = 1:size(classes,1)
                    v2Index = find(classes == v2(i));
                    adjacencyMatrix(i, v2Index) = adjacencyMatrix(i, v2Index)/maxSharedSide;
                    adjacencyMatrix(v2Index, i) = adjacencyMatrix(i, v2Index)/maxSharedSide;
                end


                %clear v1 v2 classesArea mask
                %classesStr = num2str(classes);
                %file:///C:/Program%20Files/MATLAB/R2014b/help/bioinfo/ref/biograph.html
                %bg = biograph(adjacencyMatrix, num2str(classes),'ShowArrows','off','ShowWeights','off');
                [S, C] = graphconncomp(adjacencyMatrix, 'Directed', false);

                [vCentroidsRows, vCentroidsCols] = GetCentroidOfCluster(mask, C, S);

                distanceBetweenClusters = pdist([vCentroidsRows', vCentroidsCols'], 'euclidean');

                adjacencyMatrixComplete = GetCompleteGraphWithMinimumDistances(distanceBetweenClusters ,adjacencyMatrix, C);


                inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
                outputFileName = strcat('Adjacency\adjacencyMatrix', inNameFile(1), 'hexagonalMask', num2str(numMask),'Diamet.mat')
                save(outputFileName{:}, 'adjacencyMatrix', 'adjacencyMatrixComplete', '-v7.3');
                outputFileNameSif = strcat('visualize\adjacencyMatrix', inNameFile(1), 'hexagonalMask', num2str(numMask),'Diamet.cvs');
                generateSIFFromAdjacencyMatrix(adjacencyMatrixComplete, outputFileNameSif{:});
            end
            break
        end
    end
end