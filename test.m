%Created by Pablo Vicente-Munuera helped by Pedro Gómez-Gálvez

% filenames = dir('Datos\Data\Casos\CASO 1. Y01_01B16459B\CoreA\*');
%%Obtenemos las posiciones de manera homogénea
%Img=imread('Datos\Data\Casos\CASO 1. Y01_01B16459B\CoreA\2. Y01_01B16459A 015 COL.tif');
%[H,W]=size(Img);
H = 7000;
W = 0;
for j = 5:100;
    %%Elegimos el diametro de los hexágonos
    hexagonDiameter = j;
    %%Con meshgrid obtenemos puntos equidistantes en una matriz cuadrada
    [X Y] = meshgrid(1:hexagonDiameter:max([H,W]));
    [X Y] = meshgrid(1:hexagonDiameter:max([H,W]));

    n = size(X,1);
    %%Rad3Over2 se utiliza para adquirir la forma hexagonal
    Rad3Over2=sqrt(3)/2;
    mascara=zeros(max([H,W]));
    X = Rad3Over2 * X;
    X = round(X);
    %%Obtenemos las coordenadas Y de las semillas
    if mod(n,2) == 1
        points = repmat([0 (hexagonDiameter/2)],[n, (n+1)/2]);
        Y = Y + points(:,1:length(points)-1);
    else
        Y = Y + repmat([0 (hexagonDiameter/2)],[n, n/2]);
    end
    Y = round(Y);
    %%Asignamos las semillas a la mascara con valor pixel 1 en su posicion.
    for i=1:(size(X,1)^2)
        mascara(X(i),Y(i))=1;
    end
    %%Obtenemos el diagrama de Voronoi homogeneo a partir de las semillas.
    D = bwdist(mascara);        %% Calcula las distancias más próximas de las casillas a la semilla
    DL = watershed(D);         %% Separa regiones (celulas) por proximidad
    bgm = DL == 0;             %% Le da valor 1 a los límites y cero al interior de las células
    Voronoi=bgm;
    L_original=bwlabel(1-Voronoi,8);  %% De esta manera da una etiqueta a todas las celulas y da valor 1 a todas las celulas del borde
    outputFileName = strcat('hexagonalMask', num2str(j), 'Diamet.mat');
    save(outputFileName,'L_original')
end