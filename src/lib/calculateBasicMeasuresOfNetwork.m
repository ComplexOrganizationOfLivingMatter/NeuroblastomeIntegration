function [ stringData ] = calculateBasicMeasuresOfNetwork( adjacencyMatrix )
%CALCULATEBASICMEASURESOFNETWORK Calculate several important measures of a given network
%   This file should calculate the following measures of a network:
%   Clustering coefficient, network diameter, connectedness,
%   network density, average path length (or characteristic path length),
%   average degree and others.
%
%   Developed by Pablo Vicente-Munuera
	
	%Clustering coefficient unweighted undirected
	ccuu = transitivity_bu(adjacencyMatrix);
	%Clustering coefficient weighted undirected
	ccwu = transitivity_wu(adjacencyMatrix);
	
	%Assortivity
	assor = assortativity(adjacencyMatrix, 0);
	
	%Density undirected unweighted
	den = density_und(adjacencyMatrix);
	
	%   Outputs:    lambda,         characteristic path length
	%               efficiency,     global efficiency
	%               ecc,            eccentricity (for each vertex)
	%               radius,         radius of graph
	%               diameter,       diameter of graph
	[lambda,efficiency,ecc,radius,diameter] = charpath(adjacencyMatrix);
	
	%Transform to a string
	stringData = strcat(num2str(ccuu), ', ', num2str(ccwu), ', ', num2str(assor), ', ', num2str(den), ', ', num2str(efficiency), ', ', num2str(diameter), ', ', num2str(lambda));

end

