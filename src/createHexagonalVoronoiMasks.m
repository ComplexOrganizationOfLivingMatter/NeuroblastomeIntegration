%Created by Pablo Vicente-Munuera helped by Pedro G�mez-G�lvez

% Script to create all the hexagonal grids that we'll be using 
% in all the functions creating the adjacencyMatrixHexagonalGrid... file
% We vary the radius (apothem) of the hexagon from 4 to 100, getting
% 94 different masks.

H = 7000;
W = 0;
for j = 4:100;
    %%Elegimos el diametro de los hex�gonos
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
    D = bwdist(mascara);        %% Calcula las distancias m�s pr�ximas de las casillas a la semilla
    DL = watershed(D);         %% Separa regiones (celulas) por proximidad
    bgm = DL == 0;             %% Le da valor 1 a los l�mites y cero al interior de las c�lulas
    Voronoi=bgm;
    L_original=bwlabel(1-Voronoi,8);  %% De esta manera da una etiqueta a todas las celulas y da valor 1 a todas las celulas del borde
    outputFileName = strcat('hexagonalMask', num2str(j), 'Diamet.mat');
    save(outputFileName,'L_original')
end