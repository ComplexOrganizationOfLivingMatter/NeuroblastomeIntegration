%Developed by Pablo Vicente-Munuera
%Helped by Maria José Jiménez

function [ ] = calculatePersistentHomology()
    [stat,struc] = fileattrib;
    PathCurrent = struc.Name;
    lee_imagenes = dir(PathCurrent);
    lee_imagenes = lee_imagenes(3:size(lee_imagenes,1)-1)
    for imK = 1:size(lee_imagenes,1)
        if (lee_imagenes(imK).isdir == 0 && (size(strfind(lee_imagenes(imK).name, 'COL'),1) == 1 || size(strfind(lee_imagenes(imK).name, 'CD31'),1) == 1 || size(strfind(lee_imagenes(imK).name, 'RET'),1) == 1 || size(strfind(lee_imagenes(imK).name, 'GAG'),1) == 1))
            lee_imagenes(imK).name
            Img=imread(lee_imagenes(imK).name);
            Img = Img(:, :, 1);
            Img = im2bw(Img, 0.2);
            
        end
    end
end
