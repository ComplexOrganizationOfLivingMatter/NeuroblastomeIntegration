function [ ] = createNetworkHexagonalGridSharedSide()
%CREATENETWORKHEXAGONALGRIDSHAREDSIDE create a network with the algorithm hexagonal grid shared side
%   
%
%   Developed by Pablo Vicente-Munuera

    %Extract the current path
    [stat,struc] = fileattrib;
    PathCurrent = struc.Name;
    %Get the files within the current path
    lee_imagenes = dir(PathCurrent);
    %Skip the first 2: "." ".."
    lee_imagenes = lee_imagenes(3:size(lee_imagenes,1))
    for imK = 1:size(lee_imagenes,1)
        %if the file is not a dir and we only want the images of COL, CD31, RET and GAG
        if (lee_imagenes(imK).isdir == 0 && (size(strfind(lee_imagenes(imK).name, 'COL'),1) == 1 || size(strfind(lee_imagenes(imK).name, 'CD31'),1) == 1 || size(strfind(lee_imagenes(imK).name, 'RET'),1) == 1 || size(strfind(lee_imagenes(imK).name, 'GAG'),1) == 1))
            lee_imagenes(imK).name
            Img=imread(lee_imagenes(imK).name);
            %We only want one channel of the image
            Img = Img(:, :, 1);
            %Segment the file with a threshold of 0.2, we'll get an Img with only 1s and 0s
            Img = im2bw(Img, 0.2);
            %We're using these radius masks
            for numMask = [5, 10, 15, 25, 50, 100]
                %Input file
                inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');

                %Output file
                outputFileName = strcat('Adjacency\adjacencyMatrix', inNameFile(1), 'hexagonalSharedSideMask', num2str(numMask),'Diamet.mat')
                %Ouput sif
				outputFileNameSif = strcat('visualize\adjacencyMatrix', inNameFile(1), 'hexagonalSharedSideMask', num2str(numMask),'Diamet.cvs');
                %Output sif with the connected graph
                outputFileNameSifConnected = strcat('visualize\adjacencyMatrixComplete', inNameFile(1), 'hexagonalSharedSideMask', num2str(numMask),'Diamet.cvs');
                if exist(outputFileName{:}, 'file') ~= 2
                    %We read the mask with the given radius
                    maskName = strcat('..\..\..\..\..\Mascaras\HexagonalMask', num2str(numMask), 'Diamet.mat');
                    mask = importdata(maskName);
                    %Crop the mask with the size of our image
                    mask = mask(1:size(Img, 1), 1:size(Img,2));
                    %Total number of hexagons in the mask
                    maxHexagons = size(unique(mask(mask>0)),1);
					
                    %These two arrays will have vertices forming the edges
                    vertices1 = [];
                    vertices2 = [];
                    for i = 2:size(Img,1)
                        for j = 2:size(Img,2)
                            if (mask(i,j) ==  0 && Img(i,j) ~= 0) %If trasspass the boundary we put an edge
                                %look for connected hexagons
                                [connectedClasses] = connectedHexagons(mask, i, j);
                                %Add it to the vertex list
                                %if we found more than one vertex connecting the boundary
                                if size(connectedClasses, 1) > 1
                                    %Add the vertices forming one edge
                                    vertices1 = [vertices1;connectedClasses(1)];
                                    vertices2 = [vertices2;connectedClasses(2)];
                                    %At last we could find 3 hexagons, no more than that
                                    if(size(connectedClasses) == 3)
                                        %We add two edges here
                                        vertices1 = [vertices1;connectedClasses(1)];
                                        vertices2 = [vertices2;connectedClasses(3)];
                                        %These two
                                        vertices1 = [vertices1;connectedClasses(2)];
                                        vertices2 = [vertices2;connectedClasses(3)];
                                    end
                                end
                            end
                        end
                    end
					clear mask

                    %We get all the vertices of the network
                    classes = unique([vertices1,vertices2]); 
                    %And create the adjacency sparse matrix with them
                    adjacencyMatrix = sparse(size(classes,1), size(classes,1));

                    %Within this 'for', we'll fill the adjacency matrix with the values found on vertices1 and vertices2
                    for i = 1:size(vertices1,1)
                        vertices1Index = find(classes == vertices1(i));
                        vertices2Index = find(classes == vertices2(i));
                        %As weight we'll put the number of edges found
                        adjacencyMatrix(vertices1Index, vertices2Index) = adjacencyMatrix(vertices1Index, vertices2Index) + 1;
                        adjacencyMatrix(vertices2Index, vertices1Index) = adjacencyMatrix(vertices2Index, vertices1Index) + 1;
                    end
					clear vertices1Index vertices2Index vertices1 vertices2
					
                    %And normalize that vector
                    if (size(adjacencyMatrix,1)> 0)
                        adjacencyMatrix = adjacencyMatrix / max(adjacencyMatrix(:));
                    end
                    
                    %clear vertices1 vertices2 classesArea mask
                    %classesStr = num2str(classes);
                    %file:///C:/Program%20Files/MATLAB/R2014b/help/bioinfo/ref/biograph.html
                    %bg = biograph(adjacencyMatrix, num2str(classes),'ShowArrows','off','ShowWeights','off');
                    %[S, C] = graphconncomp(adjacencyMatrix, 'Directed', false);

                    %[vCentroidsRows, vCentroidsCols] = GetCentroidOfCluster(mask, C, S);

                    %distanceBetweenClusters = pdist([vCentroidsRows', vCentroidsCols'], 'euclidean');

                    
                    %adjacencyMatrixComplete = GetConnectedGraphWithMinimumDistances(distanceBetweenClusters ,adjacencyMatrix, C);


                    %Export the files
                    %save(outputFileName{:}, 'adjacencyMatrix', 'adjacencyMatrixComplete', '-v7.3');
                    save(outputFileName{:}, 'adjacencyMatrix', '-v7.3');
                    %generateSIFFromAdjacencyMatrix(adjacencyMatrixComplete, outputFileNameSif{:});
					generateSIFFromAdjacencyMatrix(adjacencyMatrix, outputFileNameSif{:});
                    
					%And finally we fill up a file with the percentage of hexagons occupied
                    fileID = fopen('percentageOfHexagonsOccupied.txt','a');
                    string = strcat('Percentage of Hexagons occupied:', num2str(size(classes, 1)) ,' of ', num2str(maxHexagons) ,' on file ', outputFileName{:});
                    fprintf(fileID,'%s\r\n', string);
                    fclose(fileID);
					clear classes maxHexagons
                %However, if the .mat exist but not the sif, we create it from the .mat
				elseif exist(outputFileNameSifConnected{:}, 'file') ~= 2
					load(outputFileName{:},'-mat')
                    if exist('adjacencyMatrixComplete', 'var') == 1
                        generateSIFFromAdjacencyMatrix(adjacencyMatrixComplete, outputFileNameSifConnected{:});
                    end
                    if exist(outputFileNameSif{:}, 'file') ~= 2
                        generateSIFFromAdjacencyMatrix(adjacencyMatrix, outputFileNameSif{:});
                    end
                end
            end
        end
    end
end
