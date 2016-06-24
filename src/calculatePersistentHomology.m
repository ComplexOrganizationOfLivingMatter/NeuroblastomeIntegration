%Developed by Pablo Vicente-Munuera
%Helped by Maria José Jiménez

function [ ] = calculatePersistentHomology(PathCurrent)
    load_javaplex
    lee_imagenes = dir(PathCurrent);
    lee_imagenes = lee_imagenes(3:size(lee_imagenes,1)-1)
    for imK = 1:size(lee_imagenes,1)
        if (lee_imagenes(imK).isdir == 0 && size(strfind(lower(lee_imagenes(imK).name), 'neg'),1) == 0 && (size(strfind(lee_imagenes(imK).name, 'COL'),1) == 0 && size(strfind(lee_imagenes(imK).name, 'CD31'),1) == 0 && size(strfind(lee_imagenes(imK).name, 'RET'),1) == 0 && size(strfind(lee_imagenes(imK).name, 'GAG'),1) == 0))
            lee_imagenes(imK).name
			inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
			max_dimension = 2;
			num_divisions = 20;
            outputFileName = strcat('Adjacency\persistentHomology', inNameFile(1), 'MaxDim', num2str(max_dimension), '_NumDivision', num2str(20), '.mat');
			if exist(outputFileName{:}, 'file') ~= 2
				Img=imread(lee_imagenes(imK).name);
				Img = Img(:, :, 1);
				Img = im2bw(Img, 0.2);
				%pointsImg = generatePointCloudFromImage(Img);
				C = bwlabel(Img);
				S = regionprops(C,'Centroid');
				centroids = vertcat(S.Centroid);
				distanceBetweenObjects = pdist(centroids,'euclidean');
				%VietorisRips params
				 %We only want holes not anything more
				max_filtration_value = max(distanceBetweenObjects)/2;
				clear Img C S distanceBetweenObjects
				
				stream = api.Plex4.createVietorisRipsStream(centroids, max_dimension, max_filtration_value, num_divisions);
				persistence = api.Plex4.getModularSimplicialAlgorithm(max_dimension, 2);
				intervals = persistence.computeIntervals(stream);
				save(outputFileName{:}, 'stream', 'persistence', 'intervals', '-v7.3');
				clear stream persistence
				
				%Visualization
				outputFileNameImg = strcat('visualize\persistentHomology', inNameFile(1), 'MaxDim', num2str(max_dimension), '_NumDivision', num2str(20), '.mat');
				options.filename = outputFileNameImg{:};
				options.max_filtration_value = max_filtration_value;
				options.max_dimension = max_dimension - 1;
				plot_barcodes(intervals, options);
				clear intervals
			end
        end
    end
end
