import networkx as nx
import scipy.io
import h5py
import numpy as np
import time
from time import gmtime, strftime
from os import listdir
from os.path import isfile, join
import os.path


mypath = '/home/pablo/vboxshare/Neuroblastoma/Datos/Data/Casos/CASO 10. Y2_99B00646B/CoreB/Adjacency/'
onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]
#fileName = '/home/pablo/vboxshare/Neuroblastoma/Datos/Data/Casos/CASO 2. Y02A_02B03119A/CoreA/Adjacency/minimumDistanceClasses5_Y02A_02B03119A_CD45_Negativas_IPPDistanceMatrix.mat'
#fileName = '/media/Data/Pablo/Neuroblastoma/Datos/Data/Casos/CASO 1. Y01_01B16459B/CoreA/Adjacency/minimumDistanceClasses13_01B16459A_CD163_negativos_Y01DistanceMatrix.mat'


for fileName in onlyfiles:
	outputFileName = fileName.split('.')
	print outputFileName[0].strip('DistanceMatrix') + 'It' + '1' + '.mat'
	if "DistanceMatrix.mat" in fileName and os.path.isfile(mypath + outputFileName[0].strip('DistanceMatrix') + 'It' + '1' + '.mat') == 0:
		start = time.time()
		print strftime("%a, %d %b %Y %H:%M:%S", gmtime())
		#print start
		print mypath + fileName
		mat = scipy.io.loadmat(mypath + fileName)
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

				#outputFileName = fileName.split('/')
				#outputFileName = outputFileName[11].split('.')
				outputFileName = fileName.split('.')
				adjacencyMatrixOut = nx.adjacency_matrix(G)
				print outputFileName[0].strip('DistanceMatrix') + 'It' + str(iteration) + '.mat'
				scipy.io.savemat(mypath + outputFileName[0].strip('DistanceMatrix') + 'It' + str(iteration) + '.mat', mdict={'adjacencyMatrix': adjacencyMatrixOut.todense()})
				iteration = iteration + 1
				print strftime("%a, %d %b %Y %H:%M:%S", gmtime())
				ccomp = sorted(nx.connected_components(G), key = len, reverse=True)
				
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



		print strftime("%a, %d %b %Y %H:%M:%S", gmtime())
		end = time.time()
		print (end - start)
