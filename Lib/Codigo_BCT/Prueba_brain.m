% clear all;
% close all;

function [n_conexiones_cada_nodos, Suma_pesos_cada_nodo, Correlacion_entre_grados_nodos, Densidad_conexiones, Coef_cluster, T, estructura_optima,modularidad_maximizada, Matriz_distancias_mas_cortas_de_todos_nodos,lambda,efficiency,ecc_todos,radius,diameter, BC]=Prueba_brain(grafo,grafo_binario,grafo_rect,centros_rect)

% construyo grafo

% grafo=zeros(6);
% 
% grafo(1,2)=1;
% grafo(2,1)=1;
% grafo(2,3)=1;
% grafo(3,2)=1;
% grafo(2,4)=2;
% grafo(4,2)=2;
% grafo(2,5)=3;
% grafo(5,2)=3;
% grafo(4,6)=2;
% grafo(6,4)=2;
% grafo(5,6)=2;
% grafo(6,5)=2;
% grafo(5,7)=1;
% grafo(7,5)=1;
% grafo(4,5)=1;
% grafo(5,4)=1;
% 
% grafo_binario(1,2)=1;
% grafo_binario(2,1)=1;
% grafo_binario(2,3)=1;
% grafo_binario(3,2)=1;
% grafo_binario(2,4)=1;
% grafo_binario(4,2)=1;
% grafo_binario(2,5)=1;
% grafo_binario(5,2)=1;
% grafo_binario(4,6)=1;
% grafo_binario(6,4)=1;
% grafo_binario(5,6)=1;
% grafo_binario(6,5)=1;
% grafo_binario(5,7)=1;
% grafo_binario(7,5)=1;
% grafo_binario(4,5)=1;
% grafo_binario(5,4)=1;

%% Medidas basicas
n_conexiones_cada_nodos=degrees_und(grafo_binario);
Suma_pesos_cada_nodo=strengths_und(grafo);

%% Medidas de resitencia
Correlacion_entre_grados_nodos=assortativity(grafo_rect,0); % valor positivo indica que los nodos tienden a unirse con nodos con el mismo grado
Densidad_conexiones=density_und(grafo_rect);
%% Medidas de segregacion
Coef_cluster=clustering_coef_wu(grafo);  %the fraction of node’s neighbors that are neighbors of each other
T=transitivity_wu(grafo_rect);  % alternativa al coef cluster
[estructura_optima,modularidad_maximizada]=modularity_und(grafo_rect);

%% 
Matriz_distancias_mas_cortas_de_todos_nodos=distance_wei(grafo);
%% Medidas de integración
Matriz_distancias_rectagulo=Matriz_distancias_mas_cortas_de_todos_nodos(centros_rect,centros_rect);
[lambda,efficiency,ecc,radius,diameter]=charpath(Matriz_distancias_rectagulo) ;
[lambda2,efficiency2,ecc_todos,radius2,diameter2]=charpath(Matriz_distancias_mas_cortas_de_todos_nodos) ;

%% Medidas de centralidad
BC=betweenness_wei(grafo);







%% Degree and Assortativity
% n_conexiones_cada_nodos=degrees_und(grafo)
% Suma_pesos_cada_nodo=strengths_und(grafo)
%matching_ind(grafo_binario);
% Correlacion_entre_grados_nodos=assortativity(grafo,0) % valor positivo indica que los nodos tienden a unirse con nodos con el mismo grado

%% Density
% Densidad_conexiones=density_und(grafo)

%% Clustering and Modularity
% Coef_cluster=clustering_coef_wu(grafo)  %the fraction of node’s neighbors that are neighbors of each other
% transitivity_wu(grafo)  % alternativa al coef cluster

% [estructura_optima,modularidad_maximizada]=modularity_und(grafo)

%% Paths, Distances and Cycles
%findpaths(grafo_binario,2,2,1) %desde nodo 2 con longitud maxima de 2
% Matriz_distancias_mas_cortas_de_todos_nodos=distance_wei(grafo)

% [lambda,efficiency,ecc,radius,diameter]=charpath(grafo) 
cycprob(grafo_binario);

%% Centrality

% betweenness_wei(grafo) %Nodes with high values of betweenness centrality participate in a large number of shortest paths.
% edge_betweenness_wei(grafo)  % Edges with high values of betweenness centrality participate in a large number of shortest paths.
% module_degree_zscore(grafo)
%  participation_coef(grafo,2)

%% toolbox matlab

grafo_binario_sparse= sparse(grafo_binario);
grafo_sparse= sparse(grafo);

% [dist] = graphallshortestpaths(grafo_binario_sparse, 'Directed', false) % ya lo tenemos en distance_wei y con pesos
%[S, C] = graphconncomp(grafo_sparse, 'Directed', false) 
% TF = graphisspantree(grafo_binario_sparse)
% [Tree, pred] = graphminspantree(grafo_sparse)
% view(biograph(Tree,[],'ShowArrows','off','ShowWeights','on'))
% [dist, path, pred] = graphshortestpath(grafo_sparse, 3, 6)
