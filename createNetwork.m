%Developed by Pablo Vicente-Munuera

Img=imread('Datos\Data\Casos\CASO 1. Y01_01B16459B\CoreA\2. Y01_01B16459A 015 COL.tif');
mask = importdata('Mascaras\HexagonalMask20Diamet.mat');

v1 = [];
v2 = [];

for i = 2:size(Img,1)
    for j = 2:size(Img,2)
        if (mask(i,j) ==  0 && Img(i,j) == 255)
            %Add to verteces list
            [vSides] = connectedHexagons(mask, i, j);
            %%Add it to the vertex list
                v1 = [v1;vSides(1)];
                v2 = [v2;vSides(2)];
            if(size(vSides) == 3)
                v1 = [v1;vSides(1)];
                v2 = [v2;vSides(3)];
                v1 = [v1;vSides(2)];
                v2 = [v2;vSides(3)];
            end
        end
    end
end

classes = unique(v1+v2);
%Creating the Incidence matrix
incidenceMatrix = zeros(size(classes,1), size(classes,1));

for i = 1:size(v1,1)
    v2Index = classes(classes == v2(i));
    incidenceMatrix(i, v2Index) = 1;
end