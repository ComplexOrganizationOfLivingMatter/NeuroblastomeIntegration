import networkx as nx
import scipy.io
import h5py
import numpy as np

fileName = '/home/pablo/vboxshare/Neuroblastoma/Datos/Data/Casos/CASO 1. Y01_01B16459B/CoreA/Adjacency/minimumDistanceClasses10_01B16459A_CD11c_negativos_Y01DistanceMatrix.mat'

mat = scipy.io.loadmat(fileName)
distanceMatrix = np.matrix(mat['distanceBetweenObjects'])

#Creating network
G = nx.Graph()
#With an initial number of nodes
G.add_nodes_from(np.arange(len(distanceMatrix)))

iteration = 1
while True:

	minDegree = min(G.degree().values())
	#print minDegree
	if minDegree >= iteration: #create the network of iteration
		#Output files of the network

		outputFileName = fileName.split('/')
		outputFileName = outputFileName[11].split('.')
		adjacencyMatrixOut = nx.adjacency_matrix(G)
		print outputFileName[1].trim('DistanceMatrix')
		scipy.io.savemat(outputFileName[1].trim('DistanceMatrix') + 'It' + str(iteration) + '.mat', mdict={'adjacencyMatrix': adjacencyMatrixOut.todense()})
		iteration = iteration + 1
		ccomp = nx.connected_components(G)
		
		if len(ccomp) == 1:
			break


	minValue = distanceMatrix[distanceMatrix != 0].min()
	indices = np.where(distanceMatrix == minValue)

	#Remove that edge
	#print indices
	for index in range(len(indices[0])):
		distanceMatrix[indices[0][index], indices[1][index]] = 0.0
		#Add the edge
		edge = (indices[0][index], indices[1][index])
		G.add_edge(*edge)

	