%% Mice analysis
addpath(genpath('src'));

sortDirectoriesByMarker('..\Datos\Data\Mice\ToSort\', 'AA', 'GAGs', '..\Datos\Data\Mice\round0\GAGs\Images\')
sortDirectoriesByMarker('..\Datos\Data\Mice\ToSort\', 'GOMORI', 'ret', '..\Datos\Data\Mice\round0\RET\Images\')
sortDirectoriesByMarker('..\Datos\Data\Mice\ToSort\', 'MASSON', 'COL', '..\Datos\Data\Mice\round0\COLAGENO\Images\')
sortDirectoriesByMarker('..\Datos\Data\Mice\ToSort\', 'VN', 'VTN', '..\Datos\Data\Mice\round0\Vitronectine\Images\')
sortDirectoriesByMarker('..\Datos\Data\Mice\ToSort\', 'LYVE1', 'LYVE1', '..\Datos\Data\Mice\round0\LymphaticVessels\Images\')
sortDirectoriesByMarker('..\Datos\Data\Mice\ToSort\', 'CD34', 'CD34', '..\Datos\Data\Mice\round0\VasosSanguineos\Images\')

params = {{'VTN', 'ret', 'CD34', 'COL', 'GAGs', 'LYVE1'}, {'Vitronectine', 'RET', 'VasosSanguineos', 'COLAGENO', 'GAGs', 'LymphaticVessels'}};

for i = 1:size(params{1}, 2)
    pipelineAnalyzeNetworksWithGraphlets(params{1}{i}, params{2}{i}, '..\Datos\Data\Mice\round0\');
end