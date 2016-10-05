%% Generación de Imágenes Voronoi a través de puntos


clear all

 Iteration=200;
 Images=1;
 H=2048; % Tamaño de la imagen que se quiere generar 
 W=2048; % En principio la definimos con las dimensiones de la drosophila

 for i=1
      ptc = Chose_seeds_positions(0, 5500, 5500, 200, 25);

     
    for j=1:Iteration
 
 
        %% Generar imagen Voronoi
        imagen=zeros(H,W); % Se define imagen que contiene puntos
        
        for k=1:size(ptc,1)
            imagen(ptc(k,1),ptc(k,2))=1;
        end
 
        D = bwdist(imagen);        %% Calcula las distancias más próximas de las casillas a la semilla
        DL = watershed(D);         %% Separa regiones (celulas) por proximidad
        bgm = DL == 0;             %% Le da valor 1 a los límites y cero al interior de las células
        Voronoi=bgm;

        L_original=bwlabel(1-Voronoi,8);  %% De esta manera da una etiqueta a todas las celulas y da valor 1 a todas las celulas del borde

        %%Obtenemos nuevos centroides

        centro = regionprops(L_original,'Centroid');
        centros_nuevos = cat(1, centro.Centroid);
        centros_nuevos=round(centros_nuevos);
        centros_nuevos=fliplr(centros_nuevos); %[filas,columnas]
        ptc=centros_nuevos;


        
        FOLDER='Imagenes';
        Archivo=strcat('Imagen_',num2str(i),'_Diagrama_',num2str(j),'_Vonoroi_1');
        
        save(strcat(FOLDER,'\',Archivo),'L_original')
        
        imwrite(L_original, (strcat(FOLDER,'\',Archivo,'.png')))
        
         
        
     end
 end

