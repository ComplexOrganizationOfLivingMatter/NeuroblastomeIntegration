%Created by Pablo Vicente-Munuera

Rad3Over2 = sqrt(3) / 2;
[X Y] = meshgrid(0:1:41);
n = size(X,1);
X = Rad3Over2 * X;
Y = Y + repmat([0 0.5],[n,n/2]);

% Plot the hexagonal mesh, including cell borders
[XV YV] = voronoi(X(:),Y(:)); plot(XV,YV,'b-')
axis equal, axis([0 20 0 20]), zoom on