
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
            
        else
            warning(strcat('No positive marker for RET ', caseName));
        end
    end
end
