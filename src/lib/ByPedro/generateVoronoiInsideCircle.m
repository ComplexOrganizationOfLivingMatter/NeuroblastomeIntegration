function [ ] = generateVoronoiInsideCircle( numIterations, numPoints, radiusOfCircle)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%
%   Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez
    
    %this is to get the ROI of the original image
%     h = imellipse(gca, [limite limite diametro diametro]);
%     api = iptgetapi(h);
%     
%     fcn = getPositionConstraintFcn(h);
%     
%     api.setPositionConstraintFcn(fcn);
%     pause
%     
%     BW = createMask(h);

    initCentroids = Chose_seeds_positions(1, radiusOfCircle*2, radiusOfCircle*2, numPoints, 2);

    for j=1:numIterations
        image = zeros(radiusOfCircle*2, radiusOfCircle*2); % Se define imagen que contiene puntos

        for k = 1:size(initCentroids,1)
            image(initCentroids(k,1), initCentroids(k,2)) = 1;
        end

        D = bwdist(image);        %% Calcula las distancias más próximas de las casillas a la semilla
        DL = watershed(D);         %% Separa regiones (celulas) por proximidad
        bgm = DL == 0;             %% Le da valor 1 a los límites y cero al interior de las células
        %Add ones to the difference between the circle and the square
        circleLimits = strel('disk', radiusOfCircle);
        circleLimits = [circleLimits.getnhood(), zeros(radiusOfCircle*2 - 1, 1)];
        circleLimits = [circleLimits; zeros(1, radiusOfCircle*2)];
        
        Voronoi = bgm & circleLimits;

        L_original=bwlabel(1-Voronoi,8);  %% De esta manera da una etiqueta a todas las celulas y da valor 1 a todas las celulas del borde

        %%Obtenemos nuevos centroides
        centro = regionprops(L_original,'Centroid');
        centros_nuevos = cat(1, centro.Centroid);
        centros_nuevos=round(centros_nuevos);
        centros_nuevos=fliplr(centros_nuevos); %[filas,columnas]
        initCentroids=centros_nuevos;



        FOLDER='E:\Pablo\Neuroblastoma\NeuroblastomeIntegration\TempResults';
        Archivo=strcat('Imagen_',num2str(i),'_Diagrama_',num2str(j),'_Vonoroi_1');

        save(strcat(FOLDER,'\',Archivo),'L_original')

        imwrite(L_original, (strcat(FOLDER,'\',Archivo,'.png')))
    end
end