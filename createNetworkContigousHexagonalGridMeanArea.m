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
            for numMask = 2:50
                inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
                outputFileName = strcat('Adjacency\adjacencyMatrix', inNameFile(1), 'hexagonalMeanAreaMask', num2str(numMask),'Diamet.mat')
				outputFileNameSif = strcat('visualize\adjacencyMatrix', inNameFile(1), 'hexagonalMeanAreaMask', num2str(numMask),'Diamet.cvs');
                if exist(outputFileName{:}, 'file') ~= 2
                    maskName = strcat('..\..\..\..\..\Mascaras\HexagonalMask', num2str(numMask), 'Diamet.mat');
                    mask = importdata(maskName);

                    adjacencyMatrixHexagons = zeros(mask(max(size(Img)), max(size(Img))))
                    if size(adjacencyMatrixHexagons,1)==0
                        
                    end
                    
                    for i=1: mask(6999,6999) %Going through the classes
                       
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
                    generateSIFFromAdjacencyMatrix(adjacencyMatrixComplete, outputFileNameSif{:});
				elseif exist(outputFileNameSif{:}, 'file') ~= 2
					load(outputFileName{:},'-mat')
					generateSIFFromAdjacencyMatrix(adjacencyMatrixComplete, outputFileNameSif{:});
                end
            end
        end
    end
end
