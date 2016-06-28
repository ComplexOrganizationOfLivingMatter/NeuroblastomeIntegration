%	File to reduce the size of the mask files.
%
%   Developed by Pablo Vicente-Munuera

cd 'E:\Pablo\Neuroblastoma\Mascaras'
for j = 3:100
    outputFileName = strcat('hexagonalMask', num2str(j), 'Diamet.mat');
    load(outputFileName);
    L_original = L_original(1:6000, 1:6500);
    save(outputFileName,'L_original')
    L_original = L_original(1:6000, 1:6500);
end