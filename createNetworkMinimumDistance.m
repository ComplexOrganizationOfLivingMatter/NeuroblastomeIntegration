function [ ] = createNetworkMinimumDistance( )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    [stat,struc] = fileattrib;
    PathCurrent = struc.Name;
    lee_imagenes = dir(PathCurrent);
    lee_imagenes = lee_imagenes(3:size(lee_imagenes,1))
    for imK = 1:size(lee_imagenes,1)
        if (lee_imagenes(imK).isdir == 0)
            lee_imagenes(imK).name
            Img=imread(lee_imagenes(imK).name);
            adjacencyMatrix = minimumDistanceBetweenNeighbourGraph(Img);

            %Saving file
            inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
            outputFileName = strcat('Adjacency\minimumDistanceClasses', inNameFile(1), '.mat')
            save(outputFileName{:}, 'adjacencyMatrix', '-v7.3');
            generateSIFFromAdjacencyMatrix(adjacencyMatrix, strcat('visualize\minimumDistanceClasses', inNameFile(1), '.sif'));
        end
    end
end

