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

##Initial Analysis
#basePath = '/home/ubuntu/vboxshare/Neuroblastoma/Datos/Data/NuevosCasos160/Casos/'
#Mice analysis
basePath = '/home/ubuntu/vboxshare/Neuroblastoma/Results/capturingFeatures/Mice/round0/MarkersFeatures/'

mypaths.append(basePath + 'Vitronectine/DistanceMatrixWeights/')
mypaths.append(basePath + 'Vitronectine/ControlNetwork/')
mypaths.append(basePath + 'RET/DistanceMatrixWeights/')
mypaths.append(basePath + 'RET/ControlNetwork/')
mypaths.append(basePath + 'VasosSanguineos/DistanceMatrixWeights/')
mypaths.append(basePath + 'VasosSanguineos/ControlNetwork/')
mypaths.append(basePath + 'COLAGENO/DistanceMatrixWeights/')
mypaths.append(basePath + 'COLAGENO/ControlNetwork/')
mypaths.append(basePath + 'GAGs/DistanceMatrixWeights/')
mypaths.append(basePath + 'GAGs/ControlNetwork/')
mypaths.append(basePath + 'LymphaticVessels/DistanceMatrixWeights/')
mypaths.append(basePath + 'LymphaticVessels/ControlNetwork/') 



for mypath in mypaths:
	onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]

	for fileName in onlyfiles:
		outputFileName = fileName.split('.')
		directoriesFile = mypath.split('/');
		#print outputFileName[0][:-14]
		#---------------------------- SORTING ---------------------------------------#
		if "DistanceMatrix.mat" in fileName and ("50Diamet" in fileName or "Diamet" not in fileName) and os.path.isfile(basePath + '/' + directoriesFile[10] + '/SortingAlgorithm/sorting_' + outputFileName[0][:-14] + 'It' + '1' + '.mat') == 0:
			start = time.time()
			print '-- Sorting ---'
			print strftime("%a, %d %b %Y %H:%M:%S", gmtime())
			#print start
			#print mypath + fileName
			if os.path.isfile(mypath + outputFileName[0] + '.csv')  == False:
				mat = scipy.io.loadmat(mypath + fileName)
				if "Control" in fileName:
					distanceMatrix = np.matrix(mat['distanceMatrixControl'])
				else:
					distanceMatrix = np.matrix(mat['distanceBetweenObjects'])
			else:
				distanceMatrix = np.matrix(genfromtxt(mypath + outputFileName[0] + '.csv', delimiter=' '))
			
			distanceMatrixAux = distanceMatrix;
			
			print len(distanceMatrix)
			if len(distanceMatrix) > 15:
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
					scipy.io.savemat(basePath + '/' + directoriesFile[10] + '/SortingAlgorithm/sorting_' + outputFileName[0][:-14] + 'It' + str(iteration) + '.mat', mdict={'adjacencyMatrix': adjacencyMatrixOut})
					
					iteration = iteration + 1

					#If the iteration goes over 300, it has to be an error
					if iteration > 300:
						print 'Error!'
						break

					#if the graph is connected, we finish the algorithm
					if nx.is_connected(G) : #or "Control" in fileName
						#if len(ccomp) == 1:
						scipy.io.savemat(basePath + '/' + directoriesFile[10] + '/SortingAlgorithm/sorting_' + outputFileName[0][:-14] + 'ItFinal.mat', mdict={'adjacencyMatrix': adjacencyMatrixOut})
						break


			print strftime("%a, %d %b %Y %H:%M:%S", gmtime())
			end = time.time()
			print (end - start)
			print ('------------------------------------------------')

		#---------------------------- ITERATION ---------------------------------------#
		if "DistanceMatrix.mat" in fileName  and ("50Diamet" in fileName or "Diamet" not in fileName) and os.path.isfile(basePath + '/' + directoriesFile[10] + '/IterationAlgorithm/minimumDistanceClassesBetweenPairs' + outputFileName[0][:-14] + 'It' + '1' + '.mat') == 0:
			print '-- Iteration ---'
			start = time.time()
			print strftime("%a, %d %b %Y %H:%M:%S", gmtime())
			#print start
			#print mypath + fileName
			if os.path.isfile(mypath + outputFileName[0] + '.csv')  == False:
				mat = scipy.io.loadmat(mypath + fileName)
				if "Control" in fileName:
					distanceMatrix = np.matrix(mat['distanceMatrixControl'])
				else:
					distanceMatrix = np.matrix(mat['distanceBetweenObjects'])
			else:
				distanceMatrix = np.matrix(genfromtxt(mypath + outputFileName[0] + '.csv', delimiter=' '))
			
			distanceMatrixAux = distanceMatrix;
			
			print len(distanceMatrix)
			if len(distanceMatrix) > 15:
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
					scipy.io.savemat(basePath + '/' + directoriesFile[10] + '/IterationAlgorithm/minimumDistanceClassesBetweenPairs' + outputFileName[0][:-14] + 'It' + str(iteration) + '.mat', mdict={'adjacencyMatrix': adjacencyMatrixOut})
					
					iteration = iteration + 1

					#If the iteration goes over 300, it has to be an error
					if iteration > 300:
						print 'Error!'
						break

					#if the graph is connected, we finish the algorithm
					if nx.is_connected(G) : #or "Control" in fileName
						#if len(ccomp) == 1:
						scipy.io.savemat(basePath + '/' + directoriesFile[10] + '/IterationAlgorithm/minimumDistanceClassesBetweenPairs' + outputFileName[0][:-14] + 'ItFinal.mat', mdict={'adjacencyMatrix': adjacencyMatrixOut})
						break


			print strftime("%a, %d %b %Y %H:%M:%S", gmtime())
			end = time.time()
			print (end - start)
			print ('------------------------------------------------')
