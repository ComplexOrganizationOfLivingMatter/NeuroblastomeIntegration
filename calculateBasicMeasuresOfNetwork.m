function [ ] = calculateBasicMeasuresOfNetwork( adjacencyMatrix )
%calculateBasicMeasuresOfNetwork Calculate several important measures of a given network
%   This file should calculate the following measures of a network:
%   Clustering coefficient, network diameter, connectedness,
%   network density, average path length (or characteristic path length),
%   average degree and others.
	
	%Clustering coefficient unweighted undirected
	ccuu = clustering_coef_bu(adjacencyMatrix);
	%Clustering coefficient weighted undirected
	ccwu = clustering_coef_wu(adjacencyMatrix);
	
	%Assortivity
	assor = assortativity(adjacencyMatrix, 0);
	
	%Density undirected unweighted
	den = density_ud(adjacencyMatrix);
	
	%   Outputs:    lambda,         characteristic path length
	%               efficiency,     global efficiency
	%               ecc,            eccentricity (for each vertex)
	%               radius,         radius of graph
	%               diameter,       diameter of graph
	[lambda,efficiency,ecc,radius,diameter] = charpath(adjacencyMatrix);

end

