import networkx as nx
import scipy.io
import h5py
import numpy as np
import time
from time import gmtime, strftime
from os import listdir
from os.path import isfile, join
import os.path
import csv
from numpy import genfromtxt


mypaths = []
basePath = '/home/ubuntu/vboxshare/Neuroblastoma/Datos/Data/NuevosCasos160/Casos/'
weightOfWeightMatrix = 4 #The good ones
weightOfDistanceMatrix = 0.1 #the good ones

# mypaths.append(basePath + 'Vitronectine/Networks/DistanceMatrixWeights/')
# mypaths.append(basePath + 'COLAGENO/Networks/DistanceMatrixWeights/')
# mypaths.append(basePath + 'VasosSanguineos/Networks/DistanceMatrixWeights/')
# mypaths.append(basePath + 'GAGs/Networks/DistanceMatrixWeights/')
mypaths.append(basePath + 'RET/Networks/DistanceMatrixWeights/')

#mypaths.append('/home/pablo/vboxshare/Neuroblastoma/NeuroblastomeIntegration/TempResults/')

for mypath in mypaths:
	onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]

	for fileName in onlyfiles:
		outputFileName = fileName.split('.')
		directoriesFile = mypath.split('/');
		#print outputFileName[0][:-14]
		#---------------------------- SORTING ---------------------------------------#
		if "DistanceMatrix.mat" in fileName and "50Diamet" in fileName and os.path.isfile(basePath + directoriesFile[9] + '/' + directoriesFile[10] + '/SortingUsingWeightsAlgorithm/sortingUsingWeights_' + outputFileName[0][:-14] + 'It' + '1' + '.mat') == 0:
			start = time.time()
			print '-- Sorting ---'
			print strftime("%a, %d %b %Y %H:%M:%S", gmtime())
			#print start
			#print mypath + fileName
			mat = scipy.io.loadmat(mypath + fileName)
			distanceMatrix = np.matrix(mat['distanceBetweenObjects'])
			
			print len(distanceMatrix)
			if len(distanceMatrix) > 15:

				weightMatrix = np.matrix(mat['meanPercentageOfFibreWithinNeighborhood']) / 100
				distanceMatrix = distanceMatrix * weightOfDistanceMatrix
				weightMatrix = weightMatrix * weightOfWeightMatrix

				weightMatrix = np.matrix(np.tile(np.array(weightMatrix), [1, len(distanceMatrix)]))
				distanceMatrix = distanceMatrix / (weightMatrix/2 + 1 + weightMatrix.transpose()/2) #The one in the middle changes a lot

				distanceMatrixAux = distanceMatrix;
				#Creating network
				G = nx.Graph()
				#With an initial number of nodes
				G.add_nodes_from(np.arange(len(distanceMatrix)))

				iteration = 1
				while True:
					maxDistanceIteration = 0;
					indicesMaxDistanceIteration = 0
					numRow = 0;
					#distanceMatrixAux will be the matrix in which we will add remove the minimum closest
					#vertex of the row.
					for row in distanceMatrixAux:
						try:
							#minimum except zeros
							minValue = row[row != 0].min()
							#print minValue
							#indices of the min value
							indices = np.where(row == minValue)
							#first of indice's array is 0 always. Then it should be 'row', the real row.
							distanceMatrixAux[numRow, indices[1][0]] = 0
							#distanceMatrixAux[indices[1][0], row] = 0

							if minValue > maxDistanceIteration:
								maxDistanceIteration = minValue
						except Exception, e:
							pass

						numRow = numRow + 1
					

					indices = np.where(distanceMatrix <= maxDistanceIteration)
					#Remove edges
					for index in range(len(indices[0])):
						distanceMatrix[indices[0][index], indices[1][index]] = 0
						distanceMatrix[indices[1][index], indices[0][index]] = 0
						#Add the edge
						edge = (indices[0][index], indices[1][index])
						G.add_edge(*edge)


					# ----------- iteration is over! ------------#

					adjacencyMatrixOut = nx.adjacency_matrix(G)
					print outputFileName[0][:-14] + 'It' + str(iteration) + '.mat'
					scipy.io.savemat(basePath + directoriesFile[9] + '/' + directoriesFile[10] + '/SortingUsingWeightsAlgorithm/sortingUsingWeights_' + outputFileName[0][:-14] + 'It' + str(iteration) + '.mat', mdict={'adjacencyMatrix': adjacencyMatrixOut})
					
					iteration = iteration + 1

					#If the iteration goes over 300, it has to be an error
					if iteration > 300:
						print 'Error!'
						break

					#if the graph is connected, we finish the algorithm
					if nx.is_connected(G) : #or "Control" in fileName
						#if len(ccomp) == 1:
						scipy.io.savemat(basePath + directoriesFile[9] + '/' + directoriesFile[10] + '/SortingUsingWeightsAlgorithm/sortingUsingWeights_' + outputFileName[0][:-14] + 'ItFinal.mat', mdict={'adjacencyMatrix': adjacencyMatrixOut})
						break


			print strftime("%a, %d %b %Y %H:%M:%S", gmtime())
			end = time.time()
			print (end - start)
			print ('------------------------------------------------')

		#---------------------------- ITERATION ---------------------------------------#
		if "DistanceMatrix.mat" in fileName  and "50Diamet" in fileName and os.path.isfile(basePath + directoriesFile[9] + '/' + directoriesFile[10] + '/IterationUsingWeightsAlgorithm/minimumDistanceClassesBetweenPairsUsingWeights' + outputFileName[0][:-14] + 'It' + '1' + '.mat') == 0:
			print '-- Iteration ---'
			start = time.time()
			print strftime("%a, %d %b %Y %H:%M:%S", gmtime())
			#print start
			#print mypath + fileName
			mat = scipy.io.loadmat(mypath + fileName)
			distanceMatrix = np.matrix(mat['distanceBetweenObjects'])
			
			print len(distanceMatrix)
			if len(distanceMatrix) > 15:

				weightMatrix = np.matrix(mat['meanPercentageOfFibreWithinNeighborhood']) / 100
				distanceMatrix = distanceMatrix * weightOfDistanceMatrix
				weightMatrix = weightMatrix * weightOfWeightMatrix

				weightMatrix = np.matrix(np.tile(np.array(weightMatrix), [1, len(distanceMatrix)]))
				distanceMatrix = distanceMatrix / (weightMatrix/2 + 1 + weightMatrix.transpose()/2) #The one in the middle changes a lot

				distanceMatrixAux = distanceMatrix;
				#Creating network
				G = nx.Graph()
				#With an initial number of nodes
				G.add_nodes_from(np.arange(len(distanceMatrix)))

				iteration = 1
				while True:
					
					numRow = 0;
					for row in distanceMatrix:
						try:
							#minimum except zeros
							minValue = row[row != 0].min()
							#print minValue
							#indices of the min value
							indices = np.where(row == minValue)
							distanceMatrix[numRow, indices[1][0]] = 0
							distanceMatrix[indices[1][0], numRow] = 0

							edge = (numRow, indices[1][0])
							G.add_edge(*edge)


						except Exception, e:
							pass

						numRow = numRow + 1

					# ----------- iteration is over! ------------#

					adjacencyMatrixOut = nx.adjacency_matrix(G)
					print outputFileName[0][:-14] + 'It' + str(iteration) + '.mat'
					scipy.io.savemat(basePath + directoriesFile[9] + '/' + directoriesFile[10] + '/IterationUsingWeightsAlgorithm/minimumDistanceClassesBetweenPairsUsingWeights' + outputFileName[0][:-14] + 'It' + str(iteration) + '.mat', mdict={'adjacencyMatrix': adjacencyMatrixOut})
					
					iteration = iteration + 1

					#If the iteration goes over 300, it has to be an error
					if iteration > 300:
						print 'Error!'
						break

					#if the graph is connected, we finish the algorithm
					if nx.is_connected(G) : #or "Control" in fileName
						#if len(ccomp) == 1:
						scipy.io.savemat(basePath + directoriesFile[9] + '/' + directoriesFile[10] + '/IterationUsingWeightsAlgorithm/minimumDistanceClassesBetweenPairsUsingWeights' + outputFileName[0][:-14] + 'ItFinal.mat', mdict={'adjacencyMatrix': adjacencyMatrixOut})
						break


			print strftime("%a, %d %b %Y %H:%M:%S", gmtime())
			end = time.time()
			print (end - start)
			print ('------------------------------------------------')
