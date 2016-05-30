%Created by Pablo Vicente-Munuera

clf
rgb = imread('Datos\Data\Casos\CASO 1. Y01_01B16459B\CoreA\2. Y01_01B16459A 015 COL.tif');
sizeRgb = 7000
imshow(rgb)
hold on
Rad3Over2 = (sqrt(3) / 2);
hexagonDiameter = 40;
[X Y] = meshgrid(0:hexagonDiameter:sizeRgb);
n = size(X,1);
X = Rad3Over2 * X;

if mod(n,2) == 1
    points = repmat([0 (hexagonDiameter/2)],[n, (n+1)/2]);
    Y = Y + points(:,1:length(points)-1);
else
    Y = Y + repmat([0 (hexagonDiameter/2)],[n, n/2]);
end


% Plot the hexagonal mesh, including cell borders
[vx,vy] = voronoi(X(:),Y(:));
set(p, 'LineWidth',0.0000000000001)

%export_fig test.bmp -r800