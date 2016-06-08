
 clear all
% close all

%% dWL- dWP 44 cc
nclases=2;
% 
% dWL
load '..\..\Datos_extraidos-b\Matriz_cc_dWL_44_cc.mat' 
vector_todas_caracteristicas=Matriz_cc(:,[1:44]);

n_imagenes_tipo1=size(vector_todas_caracteristicas,1);

% dWP
load ('..\..\Datos_extraidos-b\Matriz_cc_dWP_44_cc.mat')
vector_todas_caracteristicas=[vector_todas_caracteristicas;Matriz_cc(:,[1:44])];

n_imagenes_tipo2=size(vector_todas_caracteristicas,1)-n_imagenes_tipo1;



load '..\..\Datos_extraidos-b\Indices_dWL.mat' %18
indice_1=Indices_dWL;
load '..\..\Datos_extraidos-b\Indices_dWP.mat' %18
indice_2=Indices_dWP;

vector_todas_caracteristicas=vector_todas_caracteristicas(:,[1:8,11:22,25:end]);
n_imagenes=size(vector_todas_caracteristicas,1);
n_cc=size(vector_todas_caracteristicas,2);

% indice_cc_seleccionadas=[ 40,20,16,22,39,9,18,37,38,13,28,36,24,4,3,15,17 ];%CC CON RADIO 6 (VERSION A)
% % indice_cc_seleccionadas=[11     7   17  41  38 ];
% % indice_cc_seleccionadas=[ 11    7 27 34 43 24 20 42 3 ];
% indice_cc_seleccionadas=[11     8    25    20    32    36    22    15    44 ]; 
% % indice_cc_seleccionadas=[11,29,32 ]; %CC CON RADIO 6 (VERSION A) y DATOS ENTRENAMIENTO CAMBIADOS
% indice_cc_seleccionadas=[   29,32,39,18,12,43,7,19];
%indice_cc_seleccionadas=[ 10,20];%CC CON RADIO 4 (VERSION B)
%indice_cc_seleccionadas=[ 3,8,10,11,27,29,33];
indice_cc_seleccionadas=[ 8,10,3,27];
% %% dWP - dNP 44 cc
%  nclases=2;
% % dWP
% load ('..\..\Datos_extraidos-a\Matriz_cc_dWP_44_cc.mat')
% vector_todas_caracteristicas=Matriz_cc(:,1:44);
% 
% n_imagenes_tipo1=size(vector_todas_caracteristicas,1);
% 
% % dNP
% load ('..\..\Datos_extraidos-a\Matriz_cc_dNP_44_cc.mat')
% vector_todas_caracteristicas=[vector_todas_caracteristicas;Matriz_cc(:,1:44)];
% 
% n_imagenes_tipo2=size(vector_todas_caracteristicas,1)-n_imagenes_tipo1;
% 
% load '..\..\Datos_extraidos-a\Indices_dWP.mat' 
% indice_1=Indices_dWP;
% load '..\..\Datos_extraidos-a\Indices_dNP.mat' 
% indice_2=Indices_dNP;
% 
% 
% n_imagenes=size(vector_todas_caracteristicas,1);
% n_cc=size(vector_todas_caracteristicas,2);
% %indice_cc_seleccionadas=[ 21     5    43    24    16    42    34     9 ]; %CC CON RADIO 6 (VERSION A)
% % indice_cc_seleccionadas=[ 21     5    25 16 43 34 12 9 23 ];
% % indice_cc_seleccionadas=[ 21     5    25  ]; 
% %indice_cc_seleccionadas=[ 21     5    4 16 40 34 44 43 9 ];
%  indice_cc_seleccionadas=[16    11     5    21    10    41 ];%CC CON RADIO 4 (VERSION B)

% %% dWL - dNP 44 cc
%  nclases=2;
% % dWL
% load ('..\..\Datos_extraidos-a\Matriz_cc_dWL_44_cc.mat')
% vector_todas_caracteristicas=Matriz_cc(:,1:44);
% 
% n_imagenes_tipo1=size(vector_todas_caracteristicas,1);
% 
% % dNP
% load ('..\..\Datos_extraidos-a\Matriz_cc_dNP_44_cc.mat')
% vector_todas_caracteristicas=[vector_todas_caracteristicas;Matriz_cc(:,1:44)];
% 
% n_imagenes_tipo2=size(vector_todas_caracteristicas,1)-n_imagenes_tipo1;
% 
% load '..\..\Datos_extraidos-a\Indices_dWL.mat' 
% indice_1=Indices_dWL;
% load '..\..\Datos_extraidos-a\Indices_dNP.mat' 
% indice_2=Indices_dNP;
% 
% 
% n_imagenes=size(vector_todas_caracteristicas,1);
% n_cc=size(vector_todas_caracteristicas,2);
% %indice_cc_seleccionadas=[ 11    41    17     7    38];  %CC CON RADIO 6 (VERSION A)
 
%  %esto se borra luego
%  n_imagenes_tipo1=16;
%  n_imagenes_tipo2=15;
%  v=vector_todas_caracteristicas;
%  clear vector_todas_caracteristicas
%  vector_todas_caracteristicas(1,:)=v(1,:);
%  vector_todas_caracteristicas(2,:)=v(2,:);
%  vector_todas_caracteristicas(3,:)=v(3,:);
%  vector_todas_caracteristicas(4,:)=v(9,:);
%  vector_todas_caracteristicas(5,:)=v(12,:);
%  vector_todas_caracteristicas(6,:)=v(13,:);
%  vector_todas_caracteristicas(7,:)=v(14,:);
%  vector_todas_caracteristicas(8,:)=v(15,:);
%  vector_todas_caracteristicas(9,:)=v(16,:);
%  vector_todas_caracteristicas(10,:)=v(17,:);
%  vector_todas_caracteristicas(11,:)=v(19,:);
%  vector_todas_caracteristicas(12,:)=v(26,:);
%  vector_todas_caracteristicas(13,:)=v(27,:);
%  vector_todas_caracteristicas(14,:)=v(28,:);
%  vector_todas_caracteristicas(15,:)=v(29,:);
%  vector_todas_caracteristicas(16,:)=v(30,:);
%  vector_todas_caracteristicas(17,:)=v(4,:);
%  vector_todas_caracteristicas(18,:)=v(5,:);
%  vector_todas_caracteristicas(19,:)=v(6,:);
%  vector_todas_caracteristicas(20,:)=v(7,:);
%  vector_todas_caracteristicas(21,:)=v(8,:);
%  vector_todas_caracteristicas(22,:)=v(10,:);
%  vector_todas_caracteristicas(23,:)=v(11,:);
%  vector_todas_caracteristicas(24,:)=v(18,:);
%  vector_todas_caracteristicas(25,:)=v(20,:);
%  vector_todas_caracteristicas(26,:)=v(21,:);
%  vector_todas_caracteristicas(27,:)=v(22,:);
%  vector_todas_caracteristicas(28,:)=v(23,:);
%  vector_todas_caracteristicas(29,:)=v(24,:);
%  vector_todas_caracteristicas(30,:)=v(25,:);
%  vector_todas_caracteristicas(31,:)=v(31,:);
%  
%  indice_1=['dWL01';'dWL02';'dWL03';'dWL09';'dWL12';'dWL13';'dWL14';'dWL15';'dWP01';'dWP02';'dWP04';'dWP11';'dWP12';'dWP13';'dWP14';'dWP15'];
%  indice_2=['dWL04';'dWL05';'dWL06';'dWL07';'dWL08';'dWL10';'dWL11';'dWP03';'dWP05';'dWP06';'dWP07';'dWP08';'dWP09';'dWP10';'dWP16'];
%  %%%%%%%%%%%%%%%%%%%%



% %% dWL- dWP-dNP 44 cc
% nclases=3;
% 
% % dWL
% load '..\..\Datos_extraidos-b\Matriz_cc_dWL_44_cc.mat' 
% vector_todas_caracteristicas=Matriz_cc(:,[1:44]);
% 
% n_imagenes_tipo1=size(vector_todas_caracteristicas,1);
% 
% % dWP
% load ('..\..\Datos_extraidos-b\Matriz_cc_dWP_44_cc.mat')
% vector_todas_caracteristicas=[vector_todas_caracteristicas;Matriz_cc(:,[1:44])];
% 
% n_imagenes_tipo2=size(vector_todas_caracteristicas,1)-n_imagenes_tipo1;
% 
% % dNP
% load ('..\..\Datos_extraidos-b\Matriz_cc_dNP_44_cc.mat')
% vector_todas_caracteristicas=[vector_todas_caracteristicas;Matriz_cc(:,[1:44])];
% 
% vector_todas_caracteristicas=vector_todas_caracteristicas(:,[1:8,11:22,25:end]);
% 
% n_imagenes_tipo3=size(vector_todas_caracteristicas,1)-n_imagenes_tipo1-n_imagenes_tipo2;
% 
% 
% 
% load '..\..\Datos_extraidos-b\Indices_dWL.mat' %18
% indice_1=Indices_dWL;
% load '..\..\Datos_extraidos-b\Indices_dWP.mat' %18
% indice_2=Indices_dWP;
% load '..\..\Datos_extraidos-b\Indices_dNP.mat' %18
% indice_3=Indices_dNP;
% 
% n_imagenes=size(vector_todas_caracteristicas,1);
% n_cc=size(vector_todas_caracteristicas,2);
%  
% indice_cc_seleccionadas=[ 3 8 10 11 27 29 33 ];
%%
if nclases==4
n_imagenes=n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3+n_imagenes_tipo4;
end
if nclases==3
n_imagenes=n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3;
end
if nclases==2
n_imagenes=n_imagenes_tipo1+n_imagenes_tipo2;
end

if nclases==4
clases=ones(n_imagenes,1);
clases(n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2)=2;
clases(n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3)=3;
clases(n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3+n_imagenes_tipo4)=3;
end
if nclases==3
clases=ones(n_imagenes,1);
clases(n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2)=2;
clases(n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3)=3;
end
if nclases==2
clases=ones(n_imagenes,1);
clases(n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2)=2;
end

%% Normalizamos el vector caracteristicas
vector_caracteristicas=vector_todas_caracteristicas(:,indice_cc_seleccionadas);
n_cc_seleccionadas=length(indice_cc_seleccionadas);
for i=1:n_cc_seleccionadas
min_v_cc(i)=min(vector_caracteristicas(:,i));
vector_caracteristicas(:,i)=vector_caracteristicas(:,i)-min(vector_caracteristicas(:,i));
max_v_cc(i)=max(vector_caracteristicas(:,i));
vector_caracteristicas(:,i)=vector_caracteristicas(:,i)/max(vector_caracteristicas(:,i));
end


%% PCA
X=vector_caracteristicas';
%Calculo la media
Media=mean(X,2);

% Le resto la media a cada imagen
for i = 1:size(X,2)
    X(:,i) = X(:,i) - Media;
end

 L = X'*X;
 
 % Cálculo de los autovalores/autovesctores
 [Vectors,Values] = eig(L);
 [d_ordenados,ind]=sort(diag(Values),'descend');   % se ordenan los autovalores
 V=Vectors(:,ind);



 %Convierto los autovalores de X'X en los autovectores de X*X'
 Vectors = X*V;
 
 % Normalizo los vectores, para conseguir longitud unitaria
 for i=1:size(X,2)
    Vectors(:,i) = Vectors(:,i)/norm(Vectors(:,i));
 end
 
if nclases==2
V=Vectors(:,1:2);
V3=Vectors(:,1:3);
W3=V3'*X;  %Proyecciones
else
    V=Vectors(:,1:3);
end
% V=Vectors(:,[2,3]);
W=V'*X;  %Proyecciones

%%%% Obtencion de numeros a partir de graficas metodo3 (LUCIANO)
label=[ones(1, n_imagenes_tipo1), 2*ones(1,n_imagenes_tipo2)];
[T, sintraluc, sinterluc, Sintra, Sinter] = valid_sumsqures(W',label,2);
C=sinterluc/sintraluc;
Ratio_pca=trace(C)

cd N-PCA
save PCA_dWL-dWP_V2 Ratio_pca

%% representar

if nclases==2   
    
    figure, plot(W(1,1:n_imagenes_tipo1),W(2,1:n_imagenes_tipo1),'.g','MarkerSize',18), text(W(1,1:n_imagenes_tipo1),W(2,1:n_imagenes_tipo1),num2str(indice_1))
    hold on, plot(W(1,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(2,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),'.r','MarkerSize',18), text(W(1,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(2,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),num2str(indice_2))
    %   hold on, plot(W_cl(1,1:n_imagenes_cl),W_cl(2,1:n_imagenes_cl),'.y','MarkerSize',18), text(W_cl(1,1:n_imagenes_cl),W_cl(2,1:n_imagenes_cl),num2str(indice_cl))
    

    stringres=strcat('PCA = ',num2str(Ratio_pca),'------->Caracteristicas seleccionadas:',num2str(indice_cc_seleccionadas));
    title(stringres)
   
    
    
    % 3 dimensiones
    
    % figure, plot3(W3(1,1:n_imagenes_tipo1),W3(2,1:n_imagenes_tipo1),W3(3,1:n_imagenes_tipo1),'.g','MarkerSize',18), text(W(1,1:n_imagenes_tipo1),W(2,1:n_imagenes_tipo1),num2str(indice_1))
    %   hold on, plot3(W3(1,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W3(2,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W3(3,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),'.b','MarkerSize',18)%, text(W3(1,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(2,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),num2str(indice_2))
    % %   hold on, plot(W_cl(1,1:n_imagenes_cl),W_cl(2,1:n_imagenes_cl),'.y','MarkerSize',18), text(W_cl(1,1:n_imagenes_cl),W_cl(2,1:n_imagenes_cl),num2str(indice_cl))
    %
    %   hold on, plot3(W_cl3(1,[ 7 8 9 14]),W_cl3(2,[ 7 8 9 14]),W_cl3(3,[ 7 8 9 14]),'.','Color',[0 0.4 0],'MarkerSize',18)%, text(W_cl(1,[ 7 8 9 14]),W_cl(2,[ 7 8 9 14]),num2str(indice_cl([ 7 8 9 14],:)))
    %  hold on, plot3(W_cl3(1,[1 2 3 4 5 10]),W_cl3(2,[1 2 3 4 5 10]),W_cl3(3,[1 2 3 4 5 10]),'.','Color',[0.4 0 0],'MarkerSize',18)%, text(W_cl(1,[1 2 3 4 5 10]),W_cl(2,[1 2 3 4 5 10]),num2str(indice_cl([1 2 3 4 5 10],:)))
    %  hold on, plot3(W_cl3(1,[11 12 ]),W_cl3(2,[11 12 ]),W_cl3(3,[11 12 ]),'.','Color',[0.5 0.7 1],'MarkerSize',18)%, text(W_cl(1,[11 12 ]),W_cl(2,[11 12 ]),num2str(indice_cl([11 12 ],:)))
    %  hold on, plot3(W_cl3(1,[13 ]),W_cl3(2,[13 ]),W_cl3(3,[13 ]),'.','Color',[0 0 0],'MarkerSize',18)%, text(W_cl(1,[13 ]),W_cl(2,[13 ]),num2str(indice_cl([13],:)))
    %
    %  %test 4
    %  %hold on, plot(W_cl(1,[18 24 25 28 ]),W_cl(2,[18 24 25 28 ]),'.','Color',[0 0.4 0],'MarkerSize',18), text(W_cl(1,[18 24 25 28 ]),W_cl(2,[18 24 25 28 ]),num2str(indice_cl([18 24 25 28],:)))
    %  %   hold on, plot(W_cl(1,[26 27]),W_cl(2,[26 27 ]),'.','Color',[0.4 0 0],'MarkerSize',18), text(W_cl(1,[26 27 ]),W_cl(2,[26 27 ]),num2str(indice_cl([26 27],:)))
    %     hold on, plot3(W_cl3(1,[19 20]),W_cl3(2,[19 20 ]),W_cl3(3,[19 20 ]),'.','Color',[0.5 0.7 1],'MarkerSize',18)%, text(W_cl(1,[19 20]),W_cl(2,[19 20 ]),num2str(indice_cl([19 20],:)))
    
    
end


if nclases==3
  figure, plot(W(1,1:n_imagenes_tipo1),W(2,1:n_imagenes_tipo1),'.g','MarkerSize',30), text(W(1,1:n_imagenes_tipo1),W(2,1:n_imagenes_tipo1),num2str(indice_1))
  hold on, plot(W(1,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(2,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),'.r','MarkerSize',30), text(W(1,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(2,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),num2str(indice_2))
    hold on, plot(W(1,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),W(2,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),'.b','MarkerSize',30), text(W(1,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),W(2,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),num2str(indice_3))
 % hold on, plot(W_cl(1,1:n_imagenes_cl),W_cl(2,1:n_imagenes_cl),'.y'), text(W_cl(1,1:n_imagenes_cl),W_cl(2,1:n_imagenes_cl),num2str(indice_cl))
title('PCA 1 y 2')
end

if nclases==3
    V=Vectors(:,1:3);
    W=V'*X;  %Proyecciones
%    W_cl=V'*datos_test_PCA;

  figure, plot(W(2,1:n_imagenes_tipo1),W(3,1:n_imagenes_tipo1),'.g','MarkerSize',30), text(W(2,1:n_imagenes_tipo1),W(3,1:n_imagenes_tipo1),num2str(indice_1))
  hold on, plot(W(2,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(3,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),'.r','MarkerSize',30), text(W(2,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(3,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),num2str(indice_2))
    hold on, plot(W(2,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),W(3,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),'.b','MarkerSize',30), text(W(2,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),W(3,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),num2str(indice_3))
 % hold on, plot(W_cl(1,1:n_imagenes_cl),W_cl(2,1:n_imagenes_cl),'.y'), text(W_cl(1,1:n_imagenes_cl),W_cl(2,1:n_imagenes_cl),num2str(indice_cl))
title('PCA 2 y 3')
end

if nclases==3
     V=Vectors(:,1:3);
    W=V'*X;  %Proyecciones++
%    W_cl=V'*datos_test_PCA;

  figure, plot(W(1,1:n_imagenes_tipo1),W(3,1:n_imagenes_tipo1),'.g','MarkerSize',30), text(W(1,1:n_imagenes_tipo1),W(3,1:n_imagenes_tipo1),num2str(indice_1))
  hold on, plot(W(1,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(3,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),'.r','MarkerSize',30), text(W(1,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(3,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),num2str(indice_2))
    hold on, plot(W(1,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),W(3,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),'.b','MarkerSize',30), text(W(1,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),W(3,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),num2str(indice_3))
 % hold on, plot(W_cl(1,1:n_imagenes_cl),W_cl(2,1:n_imagenes_cl),'.y'), text(W_cl(1,1:n_imagenes_cl),W_cl(2,1:n_imagenes_cl),num2str(indice_cl))
title('PCA 1 y 3')
end

if nclases==3
    V=Vectors(:,1:3);
    W=V'*X;  %Proyecciones
 %   W_cl=V'*datos_test_PCA;

  figure, plot3(W(1,1:n_imagenes_tipo1),W(2,1:n_imagenes_tipo1),W(3,1:n_imagenes_tipo1),'.g','MarkerSize',30)%, text(W(1,1:n_imagenes_tipo1),W(2,1:n_imagenes_tipo1),W(3,1:n_imagenes_tipo1),num2str(indice_1))
  hold on, plot3(W(1,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(2,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(3,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),'.r','MarkerSize',30)%, text(W(1,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(2,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(3,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),num2str(indice_2))
  hold on, plot3(W(1,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),W(2,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),W(3,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),'.b','MarkerSize',30)%, text(W(1,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),W(2,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),W(3,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),num2str(indice_3))
 %hold on, plot3(W_cl(1,1:n_imagenes_cl),W_cl(2,1:n_imagenes_cl),W_cl(3,1:n_imagenes_cl),'.black','MarkerSize',18)%, text(W_cl(1,1:n_imagenes_cl),W_cl(2,1:n_imagenes_cl),W_cl(3,1:n_imagenes_cl),num2str(indice_cl))
title( num2str(indice_cc_seleccionadas))
legend('Controles','Distrofias','Atrofias');
% axis equal
grid on
end

%con distintos colores para las imagenes test3
% if nclases==3
%     %     V=Vectors(:,1:3);
%     %     W=V'*X;  %Proyecciones
%     %     W_cl=V'*datos_test_PCA;
%     
%     figure, plot3(W(1,1:n_imagenes_tipo1),W(2,1:n_imagenes_tipo1),W(3,1:n_imagenes_tipo1),'.g','MarkerSize',30), text(W(1,1:n_imagenes_tipo1),W(2,1:n_imagenes_tipo1),W(3,1:n_imagenes_tipo1),num2str(indice_1))
%     hold on, plot3(W(1,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(2,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(3,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),'.r','MarkerSize',30), text(W(1,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(2,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(3,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),num2str(indice_2))
%     hold on, plot3(W(1,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),W(2,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),W(3,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),'.b','MarkerSize',30), text(W(1,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),W(2,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),W(3,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),num2str(indice_3))
%      
%   
%     title( num2str(indice_cc_seleccionadas))
%     % legend('Controles','Distrofias','Atrofias');
%     % axis equal
%     xlabel('PCA 1')
%     ylabel('PCA 2')
%     zlabel('PCA 3')
%     grid on
% end


if nclases==4
    figure, plot(W(1,1:n_imagenes_tipo1),W(2,1:n_imagenes_tipo1),'.g'), text(W(1,1:n_imagenes_tipo1),W(2,1:n_imagenes_tipo1),num2str(indice_1))
    hold on, plot(W(1,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(2,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),'.r'), text(W(1,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(2,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),num2str(indice_2))
    hold on, plot(W(1,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),W(2,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),'.b'), text(W(1,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),W(2,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),num2str(indice_3))
    hold on, plot(W(1,n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3+n_imagenes_tipo4),W(2,n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3+n_imagenes_tipo4),'.m'), text(W(1,n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3+n_imagenes_tipo4),W(2,n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3+n_imagenes_tipo4),num2str(indice_4))
    % hold on, plot(W_cl(1,1:n_imagenes_cl),W_cl(2,1:n_imagenes_cl),'.y'), text(W_cl(1,1:n_imagenes_cl),W_cl(2,1:n_imagenes_cl),num2str(indice_cl))
    title('PCA')
end

% W=W';
% vector_caracteristicas=W;
%
% vector_caracteristicas=[clases vector_caracteristicas];
%% VIDEO

% % if nclases==3
% %     V=Vectors(:,1:3);
% %     W=V'*X;  %Proyecciones
% %     W_cl=V'*datos_test_PCA;
% %
% %   figure, plot3(W(1,1:n_imagenes_tipo1),W(2,1:n_imagenes_tipo1),W(3,1:n_imagenes_tipo1),'.g','MarkerSize',30)%, text(W(1,1:n_imagenes_tipo1),W(2,1:n_imagenes_tipo1),W(3,1:n_imagenes_tipo1),num2str(indice_1))
% %   hold on, plot3(W(1,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(2,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(3,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),'.r','MarkerSize',30)%, text(W(1,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(2,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(3,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),num2str(indice_2))
% %   hold on, plot3(W(1,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),W(2,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),W(3,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),'.b','MarkerSize',30)%, text(W(1,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),W(2,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),W(3,n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3),num2str(indice_3))
% % % hold on, plot3(W_cl(1,1:n_imagenes_cl),W_cl(2,1:n_imagenes_cl),W_cl(3,1:n_imagenes_cl),'.black','MarkerSize',40)%, text(proyectados(1:n_imagenes_cl,1),proyectados(1:n_imagenes_cl,2),num2str(indice_X))
% % title( num2str(indice_cc_seleccionadas))
% % xlabel('PCA 1')
% % ylabel('PCA 2')
% % zlabel('PCA 3')
% % %legend('Controles','Distrofias','Atrofias');
% % % axis equal
% % grid on
% % end


% fig1=figure(1)
% pause
%
% %az = [ 20 40 60 80 100 120 140 160 180 200 220 ];
% az=1:2:360;
%  el = 10;
% % el = 70;
%
% mov = avifile('prueba1.avi')
% numframes=length(az);
% for i=1:numframes
%     view(az(i), el);
%     A=getframe(fig1);
%     mov = addframe(mov,A)
% end
% mov = close(mov);





%% Correlacion

% % indice_distrofias=['QD521';'QD531';'QD532';'QD541';'QD551';'QD552';'QD561';'QD571';'QD581';'QD591';'QD592';'QD601';'QD602';'QD611';'QD612';'QD621']
% % indice_distrofias_X2=['QD631';'QD632';'QD641';'QD642'];
% % indice_todos_distrofias=[indice_distrofias;indice_distrofias_X2]
% % indice_2=indice_todos_distrofias;  %20 imagenes
% %
% % indice_grado_distrofias=['2-3';'__2';'__2';'__2';'__1';'__1';'2-3';'__2';'__2';'1-2';'1-2';'3-4';'3-4';'__2';'__2';'__2']
% % indice_grado_distrofias_X2=['__1';'__1';'2-3';'2-3'];
% % indice_grado_todos_distrofias=[indice_grado_distrofias;indice_grado_distrofias_X2]
% % indice_grado_2=indice_grado_todos_distrofias;  %20 imagenes
% %
% % if nclases==2
% %     figure, plot(W(1,1:n_imagenes_tipo1),W(2,1:n_imagenes_tipo1),'.g','MarkerSize',18)%, text(W(1,1:n_imagenes_tipo1),W(2,1:n_imagenes_tipo1),num2str(indice_1))
% %     hold on, plot(W(1,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(2,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),'.r','MarkerSize',18), text(W(1,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),W(2,n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2),num2str(indice_grado_2))
% % %   hold on, plot(W_cl(1,1:n_imagenes_cl),W_cl(2,1:n_imagenes_cl),'.y','MarkerSize',18), text(W_cl(1,1:n_imagenes_cl),W_cl(2,1:n_imagenes_cl),num2str(indice_cl))
% %     title( num2str(indice_cc_seleccionadas))
% % %legend('Cuadriceps','Distrofias', 'Test 3')
% % end
%
%
% centroide_control_y=mean(W(2,1:n_imagenes_tipo1))
% centroide_control_x=mean(W(1,1:n_imagenes_tipo1))

% centroide_control_y=mode(W(2,1:n_imagenes_tipo1))
% centroide_control_x=mode(W(1,1:n_imagenes_tipo1))

% hold on, plot(centroide_control_x,centroide_control_y,'.black','MarkerSize',25)

% if nclases==2
%     for i=1:n_imagenes
%         distancia(i)=sqrt((W(1,i)-centroide_control_x)^2+(W(2,i)-centroide_control_y)^2);
%     end
%     
%     % distancia_distrofias=distancia(n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2);
%     % grados_distrofias=[2.5, 2,2, 2, 1, 1, 2.5,2, 2, 1.5, 1.5, 3.5, 3.5, 2, 2, 2, 1, 1, 2.5, 2.5];
%     % % figure, plot(distancia_distrofias, grados_distrofias, '.')
%     % R_distancia = corr(distancia_distrofias',grados_distrofias')
%     % [R_distancia, p] = corrcoef(distancia_distrofias',grados_distrofias')
%     
%     distancia_atrofias=distancia(n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2-4);  % le quito 4 porque no tengo los grados de las 4 ultimas imagenes
%     grados_atrofias=[2 2 2 1 0 0 0.5 0.5 2 2 2 2 2.5];
%     %figure, plot(distancia_atrofias, grados_atrofias, '.')
%     %axis equal
%     R_distancia_atrofias_2 = corr(distancia_atrofias',grados_atrofias')
%     [R_distancia_atrofias, p] = corrcoef(distancia_atrofias',grados_atrofias')
%     
%     
%     centroide_control_y=mean(W3(2,1:n_imagenes_tipo1))
%     centroide_control_x=mean(W3(1,1:n_imagenes_tipo1))
%     centroide_control_z=mean(W3(3,1:n_imagenes_tipo1))
%     
%     for i=1:n_imagenes
%         distancia(i)=sqrt((W3(1,i)-centroide_control_x)^2+(W3(2,i)-centroide_control_y)^2+(W3(3,i)-centroide_control_z)^2);
%     end
%     
%     distancia_atrofias=distancia(n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2-4);  % le quito 4 porque no tengo los grados de las 4 ultimas imagenes
%     grados_atrofias=[2 2 2 1 0 0 0.5 0.5 2 2 2 2 2.5];
%     %figure, plot(distancia_atrofias, grados_atrofias, '.')
%     %axis equal
%     R_distancia_atrofias_3 = corr(distancia_atrofias',grados_atrofias')
%     [R_distancia_atrofias, p] = corrcoef(distancia_atrofias',grados_atrofias')
%     R_distancia_atrofias_2
%     R_distancia_atrofias_3
% end
% 
% % %% incluyo en las distrofias, las test 3, con el centroide de los controles
% % for i=1:14
% % distancia_test(i)=sqrt((W_cl(1,i)-centroide_control_x)^2+(W(2,i)-centroide_control_y)^2);
% % end
% % distancia_distrofias_test3=distancia_test([1 2 3 4 5 10]);
% % distancia_distrofias_con_test3=[distancia_distrofias,distancia_distrofias_test3];
% % grados_distrofias_con_test3=[2.5, 2,2, 2, 1, 1, 2.5,2, 2, 1.5, 1.5, 3.5, 3.5, 2, 2, 2, 1, 1, 2.5, 2.5, 2.5,2.5,2.5,2.5,2.5,3];
% % R_distancia = corr(distancia_distrofias_con_test3',grados_distrofias_con_test3')
% %
% %
% %
% % %% incluyo en las distrofias, las test 3, con el centroide nuevo debido a los teste 3 controles
% %
% % % calculo de centroide nuevo
% % centroide_control_y=mean([W(2,1:n_imagenes_tipo1),W_cl(2,[6 7 8 9 14])]);
% % centroide_control_x=mean([W(1,1:n_imagenes_tipo1),W_cl(1,[6 7 8 9 14])]);
% % % hold on, plot(centroide_control_x,centroide_control_y,'.blue','MarkerSize',25)
% %
% % for i=1:14
% % distancia_test(i)=sqrt((W_cl(1,i)-centroide_control_x)^2+(W(2,i)-centroide_control_y)^2);
% % end
% % distancia_distrofias_test3=distancia_test([1 2 3 4 5 10]);
% % distancia_distrofias_con_test3=[distancia_distrofias,distancia_distrofias_test3];
% % grados_distrofias_con_test3=[2.5, 2,2, 2, 1, 1, 2.5,2, 2, 1.5, 1.5, 3.5, 3.5, 2, 2, 2, 1, 1, 2.5, 2.5, 2.5,2.5,2.5,2.5,2.5,3];
% % R_distancia = corr(distancia_distrofias_con_test3',grados_distrofias_con_test3')
% %
% 
% 
% if nclases==3
%     
%     centroide_control_y=mean(W(2,1:n_imagenes_tipo1))
%     centroide_control_x=mean(W(1,1:n_imagenes_tipo1))
%     centroide_control_z=mean(W(3,1:n_imagenes_tipo1))
%     
%     for i=1:n_imagenes
%         distancia(i)=sqrt((W(1,i)-centroide_control_x)^2+(W(2,i)-centroide_control_y)^2+(W(3,i)-centroide_control_z)^2);
%     end
%     
%     distancia_distrofias=distancia(n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2);
%     grados_distrofias=[2.5, 2,2, 2, 1, 1, 2.5,2, 2, 1.5, 1.5, 3.5, 3.5, 2, 2, 2, 1, 1, 2.5, 2.5];
%     % figure, plot(distancia_distrofias, grados_distrofias, '.')
%     R_distancia_distrofias = corr(distancia_distrofias',grados_distrofias')
%     
%     distancia_atrofias=distancia(n_imagenes_tipo1+n_imagenes_tipo2+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3-4);  % le quito 4 porque no tengo los grados de las 4 ultimas imagenes
%     grados_atrofias=[2 2 2 1 0 0 0.5 0.5 2 2 2 2 2.5];
%     %figure, plot(distancia_atrofias, grados_atrofias, '.')
%     %axis equal
%     R_distancia_atrofias = corr(distancia_atrofias',grados_atrofias')
%     %[R_distancia_atrofias, p] = corrcoef(distancia_atrofias',grados_atrofias')
%     
%     
%     distancia_conjunta=distancia(n_imagenes_tipo1+1:n_imagenes_tipo1+n_imagenes_tipo2+n_imagenes_tipo3-4);  % le quito 4 porque no tengo los grados de las 4 ultimas imagenes
%     grados_conjunta=[2.5, 2,2, 2, 1, 1, 2.5,2, 2, 1.5, 1.5, 3.5, 3.5, 2, 2, 2, 1, 1, 2.5, 2.5 2 2 2 1 0 0 0.5 0.5 2 2 2 2 2.5];
%     %figure, plot(distancia_atrofias, grados_atrofias, '.')
%     %axis equal
%     R_distancia_conjunta = corr(distancia_conjunta',grados_conjunta')
%     
% end


