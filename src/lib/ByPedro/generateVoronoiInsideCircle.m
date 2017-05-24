function [ ] = generateVoronoiInsideCircle( numIterations, numPoints, radiusOfCircle, circleLimits, fileName)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%
%   Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez

    initCentroids = Chose_seeds_positions(1, radiusOfCircle(1)*2, radiusOfCircle(2)*2, numPoints, 5);
    size(initCentroids, 1)
    j = 1;
    while j <= numIterations
        image = zeros(radiusOfCircle(1)*2, radiusOfCircle(2)*2); % Se define imagen que contiene puntos
        j
        for k = 1:size(initCentroids,1)
            image(initCentroids(k,1), initCentroids(k,2)) = 1;
        end

        D = bwdist(image);        %% Calcula las distancias más próximas de las casillas a la semilla
        DL = watershed(D);         %% Separa regiones (celulas) por proximidad
        bgm = DL == 0;             %% Le da valor 1 a los límites y cero al interior de las células
        %Add ones to the difference between the circle and the square
        perim = bwperim(circleLimits);
        Voronoi = bgm & circleLimits;

        L_original = bwlabel(1 - Voronoi, 8);  %% De esta manera da una etiqueta a todas las celulas y da valor 1 a todas las celulas del borde
        L_original = L_original & (1 - perim);
        L_original = L_original & (circleLimits);
        %%Obtenemos nuevos centroides
        centro = regionprops(L_original);
        centros_nuevos = cat(1, centro.Centroid);
        centros_nuevos=round(centros_nuevos);
        centros_nuevos=fliplr(centros_nuevos); %[filas,columnas]
        initCentroids=centros_nuevos;
        size(initCentroids, 1)
        if size(initCentroids, 1) > numPoints
           areas = vertcat(centro.Area);
           if sum(areas < 10) > 0
               initCentroids(areas < 10, :) = [];
           end
        end
        
        if size(initCentroids, 1) ~= numPoints
            j = 0;
            initCentroids = Chose_seeds_positions(1, radiusOfCircle(1)*2, radiusOfCircle(2)*2, numPoints, 5);
            'init centroid again'
        end
        j = j + 1;
    end
    
    save(strcat(fileName{:}, '.mat'),'initCentroids')
    imwrite(L_original, (strcat(fileName{:},'.png')))
end