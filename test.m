%Created by Pablo Vicente-Munuera

clf
rgb = imread('Datos\Data\Casos\CaSO 1. Y01_01B16459B\CoreA\1. Y01_01B16459A 015 RET.tif');
sizeRgb = size(rgb) + size(rgb)/8
imshow(rgb)
hold on
Rad3Over2 = (sqrt(3) / 2);
hexagonDiameter = 40;
[X Y] = meshgrid(0:hexagonDiameter:sizeRgb(1));
n = size(X,1);
X = Rad3Over2 * X;
Y = Y + repmat([0 hexagonDiameter/2],[n, n/2]);

% Plot the hexagonal mesh, including cell borders
voronoi(X(:),Y(:));