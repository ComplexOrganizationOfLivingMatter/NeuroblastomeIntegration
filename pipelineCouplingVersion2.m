
cd163Files = dir('D:\Pablo\Neuroblastoma\Datos\Data\NuevosCasos160\Casos\CD163\Images\**\*.tif');
retFiles = dir('D:\Pablo\Neuroblastoma\Datos\Data\NuevosCasos160\Casos\RET\Images\**\*.tif');


for numCD163File = 1:length(cd163Files)
    cd163ActualFile = cd163Files(numCD163File);
    if contains(cd163ActualFile.name, 'POSITIVAS') % Only positive images
        fileName = strsplit(cd163ActualFile.name, '_');
        caseName = fileName{1};
        actualRETFile = cellfun(@(x) contains(x, caseName) & contains(x, 'CELS') == 0, {retFiles.name});
        
        if sum(actualRETFile) > 0
            actualRETFileName = retFiles(actualRETFile);
            
            retImg = imread(strcat(actualRETFileName.folder, '\', actualRETFileName.name));
            cd163Img = imread(strcat(cd163ActualFile.folder, '\', cd163ActualFile.name));
            
            retImg = retImg(:, :, 1);
            cd163Img = cd163Img(:, :, 1);
            
            cd163Centroids = regionprops(cd163Img > 0, 'Centroid');
            cd163Centroids = vertcat(cd163Centroids.Centroid);
            
            disp('');
            
        else
            warning(strcat('No positive marker for RET ', caseName));
        end
    end
end
