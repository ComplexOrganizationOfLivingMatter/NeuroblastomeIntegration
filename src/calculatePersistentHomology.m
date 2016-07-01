function [ ] = calculatePersistentHomology(PathCurrent)
%calculatePersistentHomology 
%   
%   
%   Developed by Pablo Vicente-Munuera
%   Helped by Maria José Jiménez
    load_javaplex
    lee_imagenes = dir(PathCurrent);
    lee_imagenes = lee_imagenes(3:size(lee_imagenes,1)-2)
    for imK = 1:size(lee_imagenes,1)
        if (lee_imagenes(imK).isdir == 0 && size(strfind(lower(lee_imagenes(imK).name), 'neg'),1) == 0 && (size(strfind(lee_imagenes(imK).name, 'COL'),1) == 0 && size(strfind(lee_imagenes(imK).name, 'CD31'),1) == 0 && size(strfind(lee_imagenes(imK).name, 'RET'),1) == 0 && size(strfind(lee_imagenes(imK).name, 'GAG'),1) == 0))
            lee_imagenes(imK).name
            inNameFile = strsplit(strrep(lee_imagenes(imK).name,' ','_'), '.');
            max_dimension = 2;
            num_divisions = 50;

            Img=imread(lee_imagenes(imK).name);
            Img = Img(:, :, 1);
            Img = im2bw(Img, 0.2);
            %Img = reduceDatasetViaClosure(Img, 30);
            %pointsImg = generatePointCloudFromImage(Img);
            C = bwlabel(Img);
            S = regionprops(C,'Centroid');
            centroids = vertcat(S.Centroid);
            if size(centroids, 1) > 1
                %centroids = centroids/max(centroids(:));
                distanceBetweenObjects = squareform( pdist(centroids,'euclidean'));
                outputFileName = strcat(PathCurrent, 'Adjacency\centroids', inNameFile(1), '.csv');
                csvwrite(outputFileName{:}, centroids);
                %We only want holes not anything more
                max_filtration_value = 0.5;
                if exist(outputFileName{:}, 'file') ~= 2
                    clear Img C S distanceBetweenObjects

                    %-------------- ALL THIS CODE IS MAINLY TAKEN FROM THE JAVA_PLEX TUTORIAL -------------------------%

                    %Vietoris rips which is the algorithm that puts an edge between the points if they're within a distance radius
                    %It also creates the several networks (to be exactly num_divisions networks) with the differents radius.
                    stream = api.Plex4.createVietorisRipsStream(centroids, max_dimension, max_filtration_value, num_divisions)
                    %Then it calculates the simplicial complexes of dimension 'max_dimension'.
                    persistence = api.Plex4.getModularSimplicialAlgorithm(max_dimension, 2)
                    %And finally, we get the intervals of connected components, and holes. Persistent homology.
                    intervals = persistence.computeIntervals(stream)
                    intervalsStr = char(intervals.toString);
                    intervalsBetti = char(intervals.getBettiNumbers);
                    %We save what we can, which is not much
                    save(outputFileName{:}, 'intervalsStr', 'intervalsBetti', '-v7.3');
                    clear stream persistence

                    %The last part is the visualization one.
                    outputFileNameImg = strcat(PathCurrent, 'visualize\persistentHomology', inNameFile(1), 'MaxDim', num2str(max_dimension), '_NumDivision', num2str(num_divisions), '_MaxValue', num2str(max_filtration_value), '.jpg');
                    options.filename = outputFileNameImg{:};
                    options.max_filtration_value = max_filtration_value;
                    options.max_dimension = max_dimension - 1;
                    plot_barcodes(intervals, options);
                    clear intervals
                end
            end
        end
    end
end
