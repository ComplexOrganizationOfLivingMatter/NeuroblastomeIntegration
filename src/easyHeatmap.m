function [ output_args ] = easyHeatmap( distanceMatrix, names, outputFile, filter )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    names = cellfun(@(x) strsplit(x, '/'), names, 'UniformOutput', false);
    names = cellfun(@(x) x{end}, names, 'UniformOutput', false);
    names = names';
    [newNamesSorted, indices] = sort(names);
    
    filteredRows = cellfun(@(x) size(strfind(x, filter), 1) > 0, newNamesSorted);
    newNamesSorted = {newNamesSorted{filteredRows}};
    indices = indices(filteredRows);
    
    heatmap = (distanceMatrix(indices, indices)/max(distanceMatrix(:)))*64;
    
    h1 = figure('units','normalized','outerposition',[0 0 1 1]);
    image(heatmap);
    %colormap('gray');
    %colormap('pink');
    axis image
    colorbar
    
    title(outputFile);
    
    set(gca,'YTick', [1:size(newNamesSorted,2)], 'YTickLabel', newNamesSorted, 'FontSize', 6);
    set(gca,'XTick', [1:size(newNamesSorted,2)], 'XTickLabel', newNamesSorted, 'XTickLabelRotation', 90.0);
    
    namefile = strcat('heatmapGraphlets_', outputFile);
    %saveas(h1, namefile{:});
    export_fig(h1, namefile, '-png', '-a4', '-m1.5');
end

