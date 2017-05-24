function [ ] = paintNetworkIntoARealImage( imageName, adjacencyMatrix, centroids, pacientName, algorithmUsed )
%PAINTNETWORKINTOAREALIMAGE Summary of this function goes here
%   Detailed explanation goes here
    h = figure('visible', 'off');
    %centroids = {centroids.Centroid};
    %centroids = padcat(centroids{:});
    img = imread(imageName);
    %Only network
    %img(img>0) = 0;
    imshow(img);
    colormap hot;
    hold on;
    for i = 1:size(adjacencyMatrix, 1)
        for j = 1:size(adjacencyMatrix, 2)
            if adjacencyMatrix(i, j) > 0
                plot([centroids(i, 1), centroids(j, 1)], [centroids(i, 2), centroids(j, 2)], 'r-');
                %plot([centroids(i, 1), centroids(j, 1)], [centroids(i, 2), centroids(j, 2)], 'r.');
            end
        end
    end
    title ([pacientName, ' ', algorithmUsed]);
    export_fig(h, strcat(pacientName, '_', algorithmUsed, '.pdf'), '-r300', '-painters')
end

