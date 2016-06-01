%Developed by Pablo Vicente-Munuera

function [ ] = createNetwork()
    [stat,struc] = fileattrib;
    PathCurrent = struc.Name;
    lee_imagenes = dir(PathCurrent);
    lee_imagenes = lee_imagenes(3:size(lee_imagenes,1)-1)
    for imK = 1:size(lee_imagenes,1)
        lee_imagenes(imK).name
        Img=imread(lee_imagenes(imK).name);
        mask = importdata('..\..\..\..\..\Mascaras\HexagonalMask20Diamet.mat');

        v1 = [];
        v2 = [];
        classesArea = containers.Map('KeyType','int32','ValueType','int32');

        for i = 2:size(Img,1)
            for j = 2:size(Img,2)
                %If trasspass the the boundary we put an edge
                if (mask(i,j) ~= 0 && Img(i,j) ~= 0)
                    if classesArea.isKey(mask(i,j))
                        classesArea(mask(i,j)) = classesArea(mask(i,j)) + 1;
                    else
                        classesArea(mask(i,j)) = 1;
                    end
                elseif (mask(i,j) ==  0 && Img(i,j) ~= 0)
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
        adjacencyMatrix = zeros(size(classes,1), size(classes,1));

        for i = 1:size(classes,1)
            v2Index = find(classes == v2(i));
            v1Area = 0;
            v2Area = 0;
            if classesArea.isKey(v1(i))
                v1Area = classesArea(v1(i));
            end
            if classesArea.isKey(v2(v2Index))
               v2Area = classesArea(v2(v2Index)); 
            end
            adjacencyMatrix(i, v2Index) = (v1Area + v2Area)/2;
            adjacencyMatrix(v2Index, i) = (v1Area + v2Area)/2;
        end

        bg = biograph(adjacencyMatrix,[],'ShowArrows','off','ShowWeights','on');
        
        inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.')
        outputFileName = strcat('Adjacency\adjacencyMatrix', inNameFile(1), 'hexagonalMask20Diamet.mat')
        save(outputFileName{:}, 'adjacencyMatrix', 'bg', '-v7.3');
        break;
    end
end
