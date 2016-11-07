function [  ] = easyHeatmap( distanceMatrix, names, outputFile, filter, realMax )
%EASYHEATMAP Summary of this function goes here
%   Detailed explanation goes here
%
%   Developed by Pablo Vicente-Munuera
    
    names = cellfun(@(x) strsplit(x, '/'), names, 'UniformOutput', false);
    names = cellfun(@(x) x{end}, names, 'UniformOutput', false);
    names = cellfun(@(x) x(44:end), names, 'UniformOutput', false);
    names = cellfun(@(x) strrep(x, '_', '-'), names, 'UniformOutput', false);
    %sortedNumbers = [1, 12, 14, 15, 16, 17, 18, 19, 20, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13];
    %names = names';
    %[newNamesSorted, indices] = sort(names);
    
    if isequal(filter, '') == 0
        filteredRows = cellfun(@(x) size(strfind(x, filter), 1) > 0, names);
        names = {names(filteredRows)};
        names = names{1};
        heatmap = (distanceMatrix(filteredRows, filteredRows)/realMax)*64;
    else
        heatmap = (distanceMatrix(:, :)/realMax)*64;
    end
    
    
    
    h1 = figure('units','normalized','outerposition',[0 0 1 1]);
    image(heatmap);
    %colormap('gray');
    %colormap('pink');
    axis image
    colorbar
    
    title(outputFile);
    %names = cellfun(@(x) x(16:end-5), names, 'UniformOutput', false);
    set(gca,'YTick', [1:size(names,1)], 'YTickLabel', names);
    if size(distanceMatrix, 1) == size(distanceMatrix, 2)
        set(gca,'XTick', [1:size(names,1)], 'XTickLabel', names, 'XTickLabelRotation', 90.0);
    end

    namefile = strcat('heatmapGraphlets_', outputFile);
    %saveas(h1, namefile{:});
    export_fig(h1, namefile, '-png', '-a4', '-m1.5');
end

