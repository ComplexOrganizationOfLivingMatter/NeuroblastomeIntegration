function [ ] = paintNetworkIntoARealImage( imageName, adjacencyMatrix, centroids )
%PAINTNETWORKINTOAREALIMAGE Summary of this function goes here
%   Detailed explanation goes here
    h = figure;
    centroids = {centroids.Centroid};
    centroids = padcat(centroids{:});
    img = imread(imageName);
    image(img);
    hold on;
    for i = 1:size(adjacencyMatrix, 1)
        for j = 1:size(adjacencyMatrix, 2)
            if adjacencyMatrix(i, j) > 0
                plot([centroids(i, 1), centroids(j, 1)], [centroids(i, 2), centroids(j, 2)], 'r-');
            end
        end
    end
end

