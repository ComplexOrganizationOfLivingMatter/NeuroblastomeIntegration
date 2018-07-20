
%% Mice analysis

addpath(genpath('src'));
params = {{'ret', 'CD31', 'VTN', 'COL', 'GAGs', 'CD240'}, {'RET', 'VasosSanguineos', 'Vitronectine', 'COLAGENO', 'GAGs', 'LymphaticVessels'}};

pipelineAnalyzeNetworksWithGraphlets('VTN', 'Vitronectine', '..\Datos\Data\Mice\round0\');

for i = 1:size(params{1}, 2)
    pipelineAnalyzeNetworksWithGraphlets(params{1}{i}, params{2}{i}, '..\Datos\Data\Mice\');
end