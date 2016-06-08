%Developed by Pablo Vicente-Munuera

function [ ] = createNetworkContigousHexagonalGridMeanArea()
    [stat,struc] = fileattrib;
    PathCurrent = struc.Name;
    lee_imagenes = dir(PathCurrent);
    lee_imagenes = lee_imagenes(3:size(lee_imagenes,1))
    for imK = 1:size(lee_imagenes,1)
        if (lee_imagenes(imK).isdir == 0 && (size(strfind(lee_imagenes(imK).name, 'COL'),1) == 1 || size(strfind(lee_imagenes(imK).name, 'CD31'),1) == 1 || size(strfind(lee_imagenes(imK).name, 'RET'),1) == 1 || size(strfind(lee_imagenes(imK).name, 'GAG'),1) == 1))
            lee_imagenes(imK).name
            Img=imread(lee_imagenes(imK).name);
            Img = im2bw(Img, 0.2);
            for numMask = 20:25 %4 min
                inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
                outputFileName = strcat('Adjacency\adjacencyMatrix', inNameFile(1), 'ContigousHexagonalMeanAreaMask', num2str(numMask),'Diamet.mat')
				outputFileNameSif = strcat('visualize\adjacencyMatrix', inNameFile(1), 'ContigousHexagonalMeanAreaMask', num2str(numMask),'Diamet.cvs');
				outputFileNameSifComplete = strcat('visualize\adjacencyMatrixComplete', inNameFile(1), 'ContigousHexagonalMeanAreaMask', num2str(numMask),'Diamet.cvs');
                if exist(outputFileName{:}, 'file') ~= 2
                    maskName = strcat('..\..\..\..\..\Mascaras\HexagonalMask', num2str(numMask), 'Diamet.mat');
                    mask = importdata(maskName);
                    mask = mask(1:size(Img, 1), 1:size(Img,2));
                    
                    maxHexagons = size(unique(mask(mask>0)),1);
                    
                    ImgMasked = Img .* mask;
                    
                    classes = unique(ImgMasked(ImgMasked > 0));
                    numClasses = size(classes,1);
                    adjacencyMatrixHexagons = sparse(numClasses, numClasses);
                    for i=1:numClasses %Going through the classes
                        [x,y] = find(mask==classes(i));
                        contigousHexagons = lookForContigousHexagons(x, y, mask);
                        contigousHexagons = unique(contigousHexagons(contigousHexagons(contigousHexagons ~= classes(i))>0));
                        contigousHexagons = classes(ismember(classes, contigousHexagons));
                        
                        for class = 1:size(contigousHexagons, 1)
                           adjacencyMatrixHexagons(find(classes == classes(i)), find(classes==contigousHexagons(class))) = size(ImgMasked(ImgMasked == classes(i)), 1) + size(ImgMasked(ImgMasked == contigousHexagons(class)), 1) / 2;
                        end
                    end


                    %clear v1 v2 classesArea mask
                    %classesStr = num2str(classes);
                    %file:///C:/Program%20Files/MATLAB/R2014b/help/bioinfo/ref/biograph.html
                    %bg = biograph(adjacencyMatrix, num2str(classes),'ShowArrows','off','ShowWeights','off');
                    [S, C] = graphconncomp(adjacencyMatrix, 'Directed', false);

                    [vCentroidsRows, vCentroidsCols] = GetCentroidOfCluster(mask, C, S);

                    distanceBetweenClusters = pdist([vCentroidsRows', vCentroidsCols'], 'euclidean');

                    adjacencyMatrixComplete = GetConnectedGraphWithMinimumDistances(distanceBetweenClusters ,adjacencyMatrix, C);

                    save(outputFileName{:}, 'adjacencyMatrix', 'adjacencyMatrixComplete', '-v7.3');
					generateSIFFromAdjacencyMatrix(adjacencyMatrixComplete, outputFileNameSifComplete{:});
					generateSIFFromAdjacencyMatrix(adjacencyMatrix, outputFileNameSif{:});
                    
                    fileID = fopen('percentageOfHexagonsOccupied.txt','a');
                    fprintf(fileID,'Percentage of Hexagons occupied:%d of %d on file %s\n', 'size(classes, 1)', 'maxHexagons', 'outputFileName{:}');
                    fclose(fileID);
                    
				elseif exist(outputFileNameSif{:}, 'file') ~= 2
					load(outputFileName{:},'-mat')
					generateSIFFromAdjacencyMatrix(adjacencyMatrixComplete, outputFileNameSifComplete{:});
					generateSIFFromAdjacencyMatrix(adjacencyMatrix, outputFileNameSif{:});
                end
            end
        end
    end
end
