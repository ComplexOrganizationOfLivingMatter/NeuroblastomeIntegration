%% Generación de Imágenes Voronoi a través de puntos


clear all

Iteration=700;
Images=12;
H=1024; % Tamaño de la imagen que se quiere generar
W=1024;
FOLDER='E:\Pablo\PhD-miscelanious\voronoiGraphlets\data\biologicalImagesAndVoronoi\voronoiDiagrams\images';

for i=2:Images
    %ptc = Chose_seeds_positions(0, 5500, 5500, 200, 25);
    image = imread(strcat(FOLDER, '\imagen_',num2str(i),'_Diagrama_20.png'));
    image = im2bw(image(:,:,1), 0.2);
    segmentedImage = watershed(1 - image, 8);
    centroids = regionprops(segmentedImage, 'Centroid');
    ptc = {centroids.Centroid};
    ptc = vertcat(ptc{:});
    ptc = round(ptc);
    ptc = fliplr(ptc);
    
    for j=21:Iteration
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
        
        
        
        
        if j < 100
            Archivo=strcat('imagen_',num2str(i),'_Diagrama_0',num2str(j));
        else
            Archivo=strcat('imagen_',num2str(i),'_Diagrama_',num2str(j));
        end
        
        %save(strcat(FOLDER,'\',Archivo),'L_original')
        
        imwrite(L_original, (strcat(FOLDER,'\',Archivo,'.png')))
        
        
        
    end
end

